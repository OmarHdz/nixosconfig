#!/usr/bin/env bash

# pyvenv-run.sh: Ejecuta un comando Python dentro de un venv gestionado por uv,
# intentando aislarlo del Python de Nix.

PROJECT_DIR="$(pwd)" # Asume que se ejecuta desde la raíz del proyecto
VENV_DIR="${PROJECT_DIR}/.venv"
PYTHON_IN_VENV="${VENV_DIR}/bin/python"
DESIRED_PYTHON_VERSION="/usr/bin/python3.12" # O la versión que quieras, ej: "3.11", "python3.11"

# --- Comandos ---
# El primer argumento al script puede ser un comando especial: 'create', 'recreate', 'shell'
# Si no, se asume que todos los argumentos son para el comando python.
COMMAND_TO_RUN=("$@")
SPECIAL_COMMAND=""

if [[ "$1" == "create" || "$1" == "recreate" || "$1" == "shell" ]]; then
  SPECIAL_COMMAND="$1"
  shift                 # Quitar el comando especial de los argumentos
  COMMAND_TO_RUN=("$@") # El resto son argumentos para python (si 'shell' no tiene más)
fi

# --- Función para crear/recrear el venv ---
create_or_recreate_venv() {
  if [ "$1" == "recreate" ] && [ -d "${VENV_DIR}" ]; then
    echo "Recreando venv en ${VENV_DIR} con ${DESIRED_PYTHON_VERSION}..."
    rm -rf "${VENV_DIR}"
  elif [ -d "${VENV_DIR}" ]; then
    # Verificar si el Python en el venv es el deseado (aproximación)
    # Esto es una comprobación básica; uv podría ser más inteligente al reutilizar.
    current_venv_python_version=$("${PYTHON_IN_VENV}" --version 2>&1)
    if [[ "$current_venv_python_version" != *"${DESIRED_PYTHON_VERSION//python/}"* ]]; then # Compara "3.12" con "Python 3.12.x"
      echo "El venv existente no usa la versión de Python deseada (${DESIRED_PYTHON_VERSION}). Recreando..."
      rm -rf "${VENV_DIR}"
    else
      echo "Venv existente encontrado en ${VENV_DIR} con la versión de Python correcta."
      return 0 # Venv ya existe y es correcto
    fi
  fi

  if [ ! -d "${VENV_DIR}" ]; then
    echo "Creando venv en ${VENV_DIR} con ${DESIRED_PYTHON_VERSION} usando uv..."
    if command -v uv &>/dev/null; then
      # Asegurarse de que uv esté disponible
      if ! uv venv -p "${DESIRED_PYTHON_VERSION}" "${VENV_DIR}"; then
        echo "Error: Falló la creación del venv con 'uv venv -p ${DESIRED_PYTHON_VERSION} ${VENV_DIR}'."
        echo "Asegúrate de que uv pueda encontrar/instalar ${DESIRED_PYTHON_VERSION}."
        exit 1
      fi
      echo "Venv creado. Por favor, instala tus dependencias, por ejemplo:"
      echo "  source ${VENV_DIR}/bin/activate"
      echo "  uv pip install numpy pandas ..."
      echo "  deactivate"
    else
      echo "Error: Comando 'uv' no encontrado. Por favor, instala uv."
      exit 1
    fi
  fi
}

# --- Manejo de comandos especiales ---
if [ "${SPECIAL_COMMAND}" == "create" ]; then
  create_or_recreate_venv "create"
  exit 0
fi

if [ "${SPECIAL_COMMAND}" == "recreate" ]; then
  create_or_recreate_venv "recreate"
  exit 0
fi

# --- Verificar si el venv existe para ejecución normal o shell ---
if [ ! -f "${PYTHON_IN_VENV}" ]; then
  echo "Error: Venv no encontrado en ${VENV_DIR}"
  echo "Puedes crearlo con: $0 create"
  exit 1
fi

# --- Función principal de ejecución ---
run_in_isolated_venv() {
  local python_executable="$1"
  shift # Quitar el ejecutable de python de los argumentos
  local python_args=("$@")

  _OLD_PYTHONPATH="${PYTHONPATH:-}"
  _OLD_PYTHONHOME="${PYTHONHOME:-}" # PYTHONHOME también puede causar problemas
  export PYTHONPATH=""
  export PYTHONHOME="" # Desconfigurar PYTHONHOME también

  # Opcional: Desconfigurar PYTHONSTARTUP si es un problema persistente
  # _OLD_PYTHONSTARTUP="${PYTHONSTARTUP:-}"
  # unset PYTHONSTARTUP

  # Usamos un subshell para que la activación del venv y los cambios de env vars
  # no afecten a la shell principal.
  (
    # echo "Activando venv desde ${VENV_DIR} para ejecución..."
    source "${VENV_DIR}/bin/activate"

    # Opcional: Imprimir sys.path y variables relevantes para depuración
    # "${python_executable}" -c "import sys, os; print('--- sys.path DENTRO DEL WRAPPER ---'); [print(p) for p in sys.path]; print('--- ENV VARS RELEVANTES ---'); [print(f'{k}={v}') for k,v in os.environ.items() if 'NIX' in k or 'PATH' in k or 'PYTHON' in k or 'LIB' in k]"

    if [ "${SPECIAL_COMMAND}" == "shell" ]; then
      echo "Entrando en una shell dentro del venv (Teclea 'exit' o Ctrl+D para salir)..."
      # Iniciar una nueva shell (tu shell actual, ej. zsh, bash) con el venv activado
      # Esto es útil para trabajo interactivo
      ${SHELL}
    elif [ ${#python_args[@]} -eq 0 ]; then
      echo "No se proporcionó ningún script/comando de Python. Iniciando intérprete interactivo..."
      "${python_executable}"
    else
      # echo "Ejecutando comando: ${python_executable} ${python_args[*]}"
      "${python_executable}" "${python_args[@]}"
    fi
  )
  # El subshell ya ha terminado, las variables de entorno originales deberían estar restauradas
  # en la shell principal debido al alcance del subshell.
}

# --- Ejecución ---
run_in_isolated_venv "${PYTHON_IN_VENV}" "${COMMAND_TO_RUN[@]}"

exit $?
