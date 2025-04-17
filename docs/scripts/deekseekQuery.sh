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
MODEL_LLM=deepseek-chat
#MODEL_LLM=deepseek-reasoner
MODEL_API_KEY=${DEEPSEEK_API_KEY}
BASE_URL=https://api.deepseek.com/chat/completions
#API_URL="${BASE_URL}/${MODEL_LLM}:generateContent?key=${MODEL_API_KEY}"

# System prompt fijo (personalizable)
#SYSTEM_PROMPT="Eres un asistente útil que responde en español"
SYSTEM_PROMPT="Eres un asistente muy educado y eficiente"
# Capturar TODOS los argumentos como pregunta única
USER_QUESTION="$*"
#echo $USER_QUESTION

# Obtener respuesta de la API
#{\"role\": \"system\", \"content\": \"Eres un asistente hispano parlante, no me des respuestas en ingles\"},

#RESPONSE=$(curl -s -X POST "$BASE_URL" \
RESPONSE=$(curl -s $BASE_URL \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $MODEL_API_KEY" \
  -d "{
    \"model\": \"$MODEL_LLM\",
    \"messages\": [
		{\"role\": \"system\", \"content\": \"$SYSTEM_PROMPT\"},
		{\"role\": \"user\", \"content\": \"$USER_QUESTION\"}
    ],
	\"stream\": false
}")
# agregar para mas config\"generationConfig\": { \"temperature\": 1.0, \"maxOutputTokens\": 800 },

#echo $RESPONSE
# Extraer el texto usando grep y sed
## version warm
#TEXT=$(echo "$RESPONSE" | grep -zoP '"text":\s*"\K[^"]*"' | tr -d '"' | sed 's/\\n/\n/g')
#TEXT=$(echo "$RESPONSE" | grep -oP '"text":\s*"\K[^"]*' | sed 's/\\n/\n/g')
TEXT=$(echo "$RESPONSE" | grep -oP '"content":\s*"\K(?:\\"|[^"])*' | sed -e 's/\\n/\n/g' -e 's/\\"/"/g' -e 's/\\\\/\\/g')

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
printf "%s" "$TEXT" | nvim -c "set nomodified" -c "set wrap" -
