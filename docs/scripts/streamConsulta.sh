#!/bin/bash
# usar /usr/bin/sh
if [ -z "$1" ]; then
  echo "Error: Proporciona una pregunta"
  echo "Uso: $0 tu pregunta completa aquí sin comillas"
  exit 1
fi
# URL de la API
MODEL_LLM=gemini-2.0-pro-exp-02-05
MODEL_API_KEY=${GEMINI_API_KEY}
BASE_URL=https://generativelanguage.googleapis.com/v1beta/models
API_URL="${BASE_URL}/${MODEL_LLM}:streamGenerateContent?key=${MODEL_API_KEY}"
# System prompt fijo (personalizable)
SYSTEM_PROMPT="Eres un asistente muy educado y eficiente"
# Capturar TODOS los argumentos como pregunta única
USER_QUESTION="$*"
#echo $USER_QUESTION
curl -s -N -X POST "$API_URL" \
  -H "Content-Type: application/json" \
  --no-buffer \
  -d "{
    \"system_instruction\": { \"parts\": { \"text\": \"$SYSTEM_PROMPT\"} },
    \"contents\": { \"parts\": {\"text\": \"$USER_QUESTION\"} }
  }" 2>/dev/null |
  awk -v RS='}' '
{
    gsub(/\\n/, " ")          # Replace literal \n with spaces
    # Remove JSON syntax and irrelevant fields, keeping "text:"
    gsub(/\n|\r|[{}"\[\],]|content:|parts:|candidates:|role:|modelVersion:|usageMetadata:|promptTokenCount|totalTokenCount/, "")
    if (match($0, /text: *(.+)/, m)) {
        # Eliminar espacios múltiples y reemplazarlos por un solo espacio
        gsub(/ {2,}/, " ", m[1])
        printf "%s", m[1]
        fflush()
    }
}'
