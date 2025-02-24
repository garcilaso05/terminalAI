#!/bin/bash

# Funcion para hacer una consulta a la API de Gemini
# Se tiene que reemplazar el valor de la variable api_key con la clave de la API
# En el README se explica cómo obtener una clave de la API
# Si no puedes buscar por internet como hacerlo

# Easter Egg
# Puedes activar una carita aleatoria en el prompt si lo deseas
# Solo tienes que comentar la línea 53 y descomentar la línea 54

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

# Function to generate a random color
function random_color() {
  local colors=("31" "32" "33" "34" "35" "36")
  echo "${colors[$RANDOM % ${#colors[@]}]}"
}

# Function to generate a random face (easter egg)
function random_face() {
  local faces=(
    "⚈ ʖ⚈"
    "(¬‿¬)"
    "(>‿◠)"
    "(^ʖ^)"
    "ಠ ʖಠ"
    "(•◡•)"
  )
  echo "${faces[$RANDOM % ${#faces[@]}]}"
}

# Loop para que se hagan consultas hasta que se escriba "salir"

while true; do
  echo ""
  echo -e "\e[36m|-----------------------------|"
  echo -e "|  \e[33m¡Pregunta lo que quieras!\e[36m  |"
#  echo -e "|  \e[33m¡Pregunta lo que quieras!\e[36m  |      \e[34m$(random_face)\e[36m"
  echo -e "|-----------------------------|\e[0m"
  echo ""  
  read -p $'\e[35m  >>>  \e[0m' prompt
  echo ""
  if [[ "$prompt" == "salir" ]]; then
  echo -e "\e[32m¡Hasta luego!\e[0m"
  echo -e "by garcilaso05\e[0m"
  echo ""
    break
  fi

  query_gemini "$prompt"

  # Control de errores
  if [[ -z "$answer" ]]; then
    echo -e "\e[31mError al procesar la consulta.\e[0m"
  fi
done
