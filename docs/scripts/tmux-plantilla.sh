#!/bin/bash

# 1. Comprobar si se pasó un argumento
if [ -z "$1" ]; then
  echo "Uso: $0 <ruta-de-la-carpeta>"
  exit 1
fi

# 2. Obtener la ruta absoluta y el nombre de la sesión
DIR_PATH=$(realpath "$1")
SESSION_NAME=$(basename "$DIR_PATH")

# 3. Comprobar si la sesión ya existe para no duplicarla
tmux has-session -t "$SESSION_NAME" 2>/dev/null

if [ $? != 0 ]; then
  # --- AQUÍ EMPIEZA LA MAGIA ---

  # Crear la sesión en modo 'detached' (-d) y definir la carpeta de trabajo (-c)
  tmux new-session -d -s "$SESSION_NAME" -c "$DIR_PATH"

  # ==========================================
  # VENTANA 1: Editor de código
  # ==========================================
  # C-m es presionar la tecla enter
  # Renombrar la primera ventana (índice 0)
  tmux rename-window -t "$SESSION_NAME:1" 'runServer'
  # Enviar comando (ej. abrir nvim o vim)
  tmux send-keys -t "$SESSION_NAME:1" 'clear && echo "Correr Servidor "' C-m

  tmux new-window -t "$SESSION_NAME" -n 'gemini' -c "$DIR_PATH"
  # tmux rename-window -t "$SESSION_NAME:2" 'gemini'
  # Enviar comando (ej. abrir nvim o vim)
  tmux send-keys -t "$SESSION_NAME:gemini" 'clear && echo "Ejecutar Gemini"' C-m

  tmux new-window -t "$SESSION_NAME" -n 'editCode' -c "$DIR_PATH"
  # tmux rename-window -t "$SESSION_NAME:3" 'editCode'
  # Enviar comando (ej. abrir nvim o vim)
  # tmux send-keys -t "$SESSION_NAME:editCode" 'nvim .' C-m
  tmux send-keys -t "$SESSION_NAME:editCode" 'clear && echo "v main.py"' C-m

  tmux new-window -t "$SESSION_NAME" -n 'rockpi' -c "$DIR_PATH"
  # tmux rename-window -t "$SESSION_NAME:2" 'gemini'
  # Enviar comando (ej. abrir nvim o vim)
  # tmux send-keys -t "$SESSION_NAME:rockpi" 'clear && echo "ssh rock@192.168.100.200"' C-m
  tmux send-keys -t "$SESSION_NAME:rockpi" 'ssh rock@192.168.100.200'

  tmux new-window -t "$SESSION_NAME" -n 'serverhome2' -c "$DIR_PATH"
  # tmux rename-window -t "$SESSION_NAME:2" 'gemini'
  # Enviar comando (ej. abrir nvim o vim)
  # tmux send-keys -t "$SESSION_NAME:rockpi" 'clear && echo "ssh rock@192.168.100.200"' C-m
  tmux send-keys -t "$SESSION_NAME:serverhome2" 'ssh devpro@192.168.100.182'

  # ==========================================
  # VENTANA 2: Consola y Logs
  # ==========================================
  # Crear nueva ventana (-n nombre)
  tmux new-window -t "$SESSION_NAME" -n 'Terminal' -c "$DIR_PATH"

  # Dividir la ventana 2 en dos paneles (horizontalmente)
  tmux split-window -h -t "$SESSION_NAME:6" -c "$DIR_PATH"

  # Redimensionar si quieres (opcional)
  tmux resize-pane -t "$SESSION_NAME:6.1" -x 80%

  # Seleccionar el primer panel de esta ventana
  tmux select-pane -t "$SESSION_NAME:6.1"

  # ==========================================
  # VOLVER AL INICIO
  # ==========================================
  # Seleccionar la primera ventana para empezar ahí
  tmux select-window -t "$SESSION_NAME:1"
fi

# 4. INTELIGENCIA: Decidir si conectar o cambiar
if [ -z "$TMUX" ]; then
  # Si la variable $TMUX está vacía, significa que estamos en una terminal normal.
  # Así que hacemos attach.
  tmux attach -t "$SESSION_NAME"
else
  # Si la variable $TMUX tiene algo, ya estamos dentro de tmux.
  # Usamos switch-client para saltar a la nueva sesión sin anidar.
  tmux switch-client -t "$SESSION_NAME"
fi

# 4. Conectarse a la sesión
# tmux attach -t "$SESSION_NAME"
