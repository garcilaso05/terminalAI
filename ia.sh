#!/bin/bash

# Funcion para hacer una consulta a la API de Gemini
# Se tiene que reemplazar el valor de la variable api_key con la clave de la API
# En el README se explica cómo obtener una clave de la API
# Si no puedes buscar por internet como hacerlo

function query_gemini() {
  local prompt="$1"
  local api_key="  "  # Introduce aquí tu clave de la API

  response=$(curl \
    -H "Content-Type: application/json" \
    -d "{\"contents\":[{\"parts\":[{\"text\":\"$prompt\"}]}]}" \
    -X POST "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key=$api_key" \
    -s)  # Enviamos y recibimos el contenido de la respuesta

  # Extraemos la respuesta que nos interesa y la guardamos en la variable answer
  answer=$(echo "$response" | jq -r '.candidates[0].content.parts[0].text')

  echo "$answer"
  echo ""
}

# Loop para que se hagan consultas hasta que se escriba "salir"
while true; do
  echo ""
  echo "|-----------------------------|"
  echo "|  ¡Pregunta lo que quieras!  |"
  echo "|-----------------------------|"
  echo ""  
  read -p "  >>>  " prompt
  echo ""
  if [[ "$prompt" == "salir" ]]; then
    break
  fi

  query_gemini "$prompt"

  # Control de errores
  if [[ -z "$answer" ]]; then
    echo "Error al procesar la consulta."
  fi
done
