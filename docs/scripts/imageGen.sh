# Check if an argument is provided
if [ -n "$1" ]; then
  TEXT="$1"
else
  TEXT="Create a 3D rendered image of an unicorn with wings and a top hat flying over a happy, futuristic sci-fi city with lots of greenery."
fi

# Default output file
OUTPUT="salidadefa.png"

# Shift off the options and their arguments.
# shift $((OPTIND - 1))

echo "Enter the output file name (e.g., image.png):"
read OUTPUT

echo "Se guardara el archivo en $OUTPUT"

# The remaining arguments are the text.
if [ -n "$1" ]; then
  TEXT="$*"
else
  TEXT="Create a 3D rendered image of an unicorn with wings and a top hat flying over a happy, futuristic sci-fi city with lots of greenery."
fi

echo "TEXT=$TEXT"
echo "paso1"
# echo $TEXT_ESCAPED

LOAD=$(jq -n \
  --arg text "$TEXT" \
  '{
    contents: [
      {
        parts: [
          {
            text: $text
          }
        ]
      }
    ],
    generationConfig: {
      responseModalities: ["Text", "Image"]
    }
  }')

echo "$LOAD" | jq '.'
echo "paso2"

RESPONSE=$(curl -s -X POST \
  "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash-exp-image-generation:generateContent?key=$GEMINI_API_KEY" \
  -H "Content-Type: application/json" \
  -d "$LOAD")

# Descomenta si no se esta generando la imagen para ver el error
# echo "$RESPONSE"

if echo "$RESPONSE" | grep -q '"data":'; then
  echo "$RESPONSE" |
    grep -o '"data": "[^"]*"' |
    cut -d'"' -f4 |
    base64 --decode >"$OUTPUT"

  echo "Archivo guardado en $OUTPUT"
else
  echo "Error: No se pudo obtener la imagen."
fi
