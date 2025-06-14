#!/bin/bash

# Script para ver archivos CSV en formato de tabla, con selección de columnas
# por nombre o índice, usando herramientas estándar de la terminal.
# ... (resto de los comentarios iniciales) ...

# --- Funciones Auxiliares (Definidas Globalmente) ---
PH_SQUOTE_CHAR="§"
PH_DQUOTE_CHAR="‡"
PH_INT_COMMA="@@@INT_C@@@"
DELIM_CSV=','
DELIM_COL=$'\t'

_placeholder_comas_internas_doble_comilla() {
  echo "$1" | sed -E ":a; s/(\"[^\",]*)$DELIM_CSV([^\"]*\")/\1$PH_INT_COMMA\2/g; ta"
}
_proteger_comillas_simples() {
  echo "$1" | sed "s/'/$PH_SQUOTE_CHAR/g"
}
_restaurar_comillas_simples() {
  echo "$1" | sed "s/$PH_SQUOTE_CHAR/'/g"
}
_proteger_comillas_dobles() {
  echo "$1" | sed "s/\"/$PH_DQUOTE_CHAR/g"
}
_restaurar_comillas_dobles() {
  echo "$1" | sed "s/$PH_DQUOTE_CHAR/\"/g"
}
_revertir_ph_comas_internas() {
  echo "$1" | sed "s/$PH_INT_COMMA/$DELIM_CSV/g"
}
_csv_a_delim_col() {
  echo "$1" | sed "s/$DELIM_CSV/$DELIM_COL/g"
}

# --- Función Principal ---
ver_csv_tabla() {
  if [ "$#" -eq 0 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    echo "Uso: $(basename "$0") <archivo.csv> [nombres_o_indices_columnas]" >&2
    # ... (ayuda completa como en la versión anterior) ...
    echo "" >&2
    echo "Muestra un archivo CSV en formato de tabla, con selección de columnas opcional." >&2
    echo "Se pueden especificar columnas por nombre (si el CSV tiene encabezado)" >&2
    echo "o por número de índice (comenzando en 1)." >&2
    echo "" >&2
    echo "Argumentos:" >&2
    echo "  <archivo.csv>            Ruta al archivo CSV a procesar." >&2
    echo "  [columnas]             (Opcional) Nombres de columna (ej. \"Nombre,Ciudad\") o" >&2
    echo "                           números de columna (ej. \"1,3,4\"), separados por comas." >&2
    echo "                           Si se omite, se muestran todas las columnas." >&2
    echo "" >&2
    echo "Ejemplos:" >&2
    echo "  $(basename "$0") datos.csv" >&2
    echo "  $(basename "$0") datos.csv \"Nombre Columna,Email\"  # Selecciona por nombre" >&2
    echo "  $(basename "$0") datos.csv 1,3                     # Selecciona por índice" >&2
    echo "" >&2
    echo "Placeholders usados internamente para comillas: simple='$PH_SQUOTE_CHAR', doble(opc)='$PH_DQUOTE_CHAR'." >&2
    echo "Asegúrate de que estos caracteres no existan en tus datos si activas su protección." >&2
    if [ "$#" -eq 0 ]; then return 1; else return 0; fi
  fi

  ARCHIVO_CSV="$1"
  COLUMNAS_ESPECIFICADAS="${2:-}"

  if [ ! -f "$ARCHIVO_CSV" ]; then
    echo "Error: El archivo '$ARCHIVO_CSV' no existe." >&2
    return 1
  fi
  if [ ! -r "$ARCHIVO_CSV" ]; then
    echo "Error: No se tienen permisos de lectura para el archivo '$ARCHIVO_CSV'." >&2
    return 1
  fi
  if [ ! -s "$ARCHIVO_CSV" ]; then echo "Advertencia: El archivo '$ARCHIVO_CSV' está vacío." >&2; fi

  INDICES_PARA_CUT=""

  if [ -n "$COLUMNAS_ESPECIFICADAS" ]; then
    if echo "$COLUMNAS_ESPECIFICADAS" | grep -Eq "^\s*[0-9]+(\s*,\s*[0-9]+)*\s*$"; then
      INDICES_PARA_CUT="$COLUMNAS_ESPECIFICADAS"
    else
      PRIMERA_LINEA_BRUTA=$(head -n 1 "$ARCHIVO_CSV")
      if [ -z "$PRIMERA_LINEA_BRUTA" ]; then
        echo "Error: El archivo CSV está vacío o no tiene encabezado para buscar nombres de columna." >&2
        return 1
      fi

      HEADER_PARA_AWK=$(_placeholder_comas_internas_doble_comilla "$PRIMERA_LINEA_BRUTA")

      INDICES_PARA_CUT=$(echo "$HEADER_PARA_AWK" | awk -v ph_int_c="$PH_INT_COMMA" -v delim_csv="$DELIM_CSV" -v nombres_req_str="$COLUMNAS_ESPECIFICADAS" \
        -F "$DELIM_CSV" '
                BEGIN {
                    split(nombres_req_str, arr_nombres_req, ",");
                    for (i in arr_nombres_req) {
                        gsub(/^[ \t]+|[ \t]+$/, "", arr_nombres_req[i]);
                        mapa_nombres_req[arr_nombres_req[i]] = 1;
                        orden_nombres_req[i] = arr_nombres_req[i];
                    }
                }
                {
                    indices_encontrados_str = "";
                    # mapa_indices_usados = ""; # <--- ESTA LÍNEA SE ELIMINA O COMENTA

                    for (idx_orden = 1; idx_orden <= length(orden_nombres_req); idx_orden++) {
                        nombre_buscado = orden_nombres_req[idx_orden]; 
                        encontrado_este_nombre = 0;
                        for (i_header = 1; i_header <= NF; i_header++) {
                            nombre_col_actual = $i_header;
                            gsub(/^[ \t"'"'"']+|[ \t"'"'"']+$/, "", nombre_col_actual); 
                            gsub(ph_int_c, delim_csv, nombre_col_actual); 
                            
                            if (nombre_col_actual == nombre_buscado) {
                                if (!(i_header in mapa_indices_usados)) { # awk crea mapa_indices_usados como array aquí si no existe
                                    if (indices_encontrados_str != "") indices_encontrados_str = indices_encontrados_str ",";
                                    indices_encontrados_str = indices_encontrados_str i_header;
                                    mapa_indices_usados[i_header] = 1; 
                                    encontrado_este_nombre = 1; 
                                    break; 
                                }
                            }
                        }
                        if (encontrado_este_nombre == 0) {
                            print "Error: Nombre de columna no encontrado: \"" nombre_buscado "\"" > "/dev/stderr"; 
                            exit 1;
                        }
                    }
                    print indices_encontrados_str;
                }')

      if [ -z "$INDICES_PARA_CUT" ] || echo "$INDICES_PARA_CUT" | grep -q "Error:"; then
        if ! echo "$INDICES_PARA_CUT" | grep -q "Error:"; then echo "Error: No se pudieron mapear nombres de columna a índices." >&2; fi
        return 1
      fi
    fi
  fi

  PIPELINE="cat \"$ARCHIVO_CSV\""
  PIPELINE="$PIPELINE | while IFS= read -r l; do _placeholder_comas_internas_doble_comilla \"\$l\"; done"
  PIPELINE="$PIPELINE | while IFS= read -r l; do _proteger_comillas_simples \"\$l\"; done"
  # PIPELINE="$PIPELINE | while IFS= read -r l; do _proteger_comillas_dobles \"\$l\"; done" # Opcional

  if [ -n "$INDICES_PARA_CUT" ]; then
    PIPELINE="$PIPELINE | cut -d'$DELIM_CSV' -f'$INDICES_PARA_CUT'"
  fi

  PIPELINE="$PIPELINE | while IFS= read -r l; do _csv_a_delim_col \"\$l\"; done"
  PIPELINE="$PIPELINE | while IFS= read -r l; do _revertir_ph_comas_internas \"\$l\"; done"
  PIPELINE="$PIPELINE | column -t -s \"\$'$DELIM_COL'\""
  PIPELINE="$PIPELINE | while IFS= read -r l; do _restaurar_comillas_simples \"\$l\"; done"
  # PIPELINE="$PIPELINE | while IFS= read -r l; do _restaurar_comillas_dobles \"\$l\"; done" # Opcional
  PIPELINE="$PIPELINE | less -S"

  eval "$PIPELINE"

  local pipeline_exit_status=${PIPESTATUS[${#PIPESTATUS[@]} - 1]}
  if [ "$pipeline_exit_status" -ne 0 ] && [ "$pipeline_exit_status" -ne 130 ] && [ "$pipeline_exit_status" -ne 141 ]; then
    echo "Advertencia: El pipeline terminó con estado $pipeline_exit_status" >&2
  fi
  return "$pipeline_exit_status"
}

# --- Punto de entrada del script ---
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  export -f _placeholder_comas_internas_doble_comilla
  export -f _proteger_comillas_simples
  export -f _restaurar_comillas_simples
  export -f _proteger_comillas_dobles
  export -f _restaurar_comillas_dobles
  export -f _revertir_ph_comas_internas
  export -f _csv_a_delim_col

  ver_csv_tabla "$@"
  exit $?
fi
