#!/bin/bash

# Guardar el nombre del archivo a ejecutar
FILE="$1"

# Enviar el comando para ejecutar python, pero con un pequeño retraso
tmux send-keys -t 1 "sleep 2 && python \"$FILE\" && echo -e '\n--- Ejecución completada ---'" C-m
