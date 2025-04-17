#!/bin/bash

# uusar /usr/bin/sh
# Verificar argumentos
# Usa esto si necesitas dos o mas argumentos if [ -z "$1" ] || [ -z "$2" ]; then
# Verificar si se proporcionó una pregunta
if [ -z "$1" ]; then
  echo "Error: Proporciona una pregunta"
  echo "Uso: $0 tu pregunta completa aquí sin comillas"
  exit 1
fi

# URL de la API
#MODEL_LLM=gemini-1.5-flash
#MODEL_LLM=gemini-2.0-flash
MODEL_LLM=gemini-2.0-pro-exp-02-05
MODEL_API_KEY=${GEMINI_API_KEY}
BASE_URL=https://generativelanguage.googleapis.com/v1beta/models
API_URL="${BASE_URL}/${MODEL_LLM}:generateContent?key=${MODEL_API_KEY}"

# System prompt fijo (personalizable)
#SYSTEM_PROMPT="Eres un asistente útil que responde en español"
SYSTEM_PROMPT="Eres un asistente muy educado y eficiente"
# Capturar TODOS los argumentos como pregunta única
USER_QUESTION="$*"
echo $USER_QUESTION
#echo $USER_QUESTION

# Obtener respuesta de la API
#{\"role\": \"system\", \"content\": \"Eres un asistente hispano parlante, no me des respuestas en ingles\"},

RESPONSE=$(curl -s -X POST "$API_URL" \
  -H "Content-Type: application/json" \
  -d "{
    \"system_instruction\": { \"parts\": { \"text\": \"$SYSTEM_PROMPT\"} },
        \"contents\": { \"parts\": {"text": \"$USER_QUESTION\"} },
}")
# agregar para mas config\"generationConfig\": { \"temperature\": 1.0, \"maxOutputTokens\": 800 },

# Extraer el texto usando grep y sed
## version warm
#TEXT=$(echo "$RESPONSE" | grep -zoP '"text":\s*"\K[^"]*"' | tr -d '"' | sed 's/\\n/\n/g')
#TEXT=$(echo "$RESPONSE" | grep -oP '"text":\s*"\K[^"]*' | sed 's/\\n/\n/g')
#TEXT=$(echo "$RESPONSE" | grep -oP '"text":\s*"\K(?:\\"|[^"])*' | sed -e 's/\\n/\n/g' -e 's/\\"/"/g' -e 's/\\\\/\\/g')
TEXT=$(echo "$RESPONSE" | grep -zoP '"text":\s*"\K(?:\\"|[^"])*' | sed -e 's/\\n/\n/g' -e 's/\\"/"/g' -e 's/\\\\/\\/g' | tr -d '\0')

# Verificar si se obtuvo el texto
if [ -z "$TEXT" ]; then
  echo "Error: No se pudo extraer el texto de la respuesta"
  echo "Respuesta completa:"
  echo "$RESPONSE"
  exit 1
fi

# Copiar al portapapeles de Windows y mostrar
#echo -e "\nRespuesta:"
#echo -e "$TEXT"
#echo -e "$TEXT" | clip.exe
#echo -e "\n✅ Texto copiado al portapapeles!"
#echo $TEXT | vim -c "set nomodified" -c "set wrap" -
echo -e "Usando $MODEL_LLM"
#echo $TEXT
#printf "%s" "$TEXT" | nvim -c "set nomodified" -c "set wrap" -
printf "%s" "$TEXT" >~/nixosconfig/docs/scripts/preguntasAi/answerQuery.md #&& nvim -c "set nomodified" -c "set wrap" ~/mySetUpSh/aiQuery/answerQuery.md
nvim -c "set nomodified" -c "set wrap" ~/nixosconfig/docs/scripts/preguntasAi/answerQuery.md
