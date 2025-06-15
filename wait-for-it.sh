#!/usr/bin/env bash
# wait-for-it.sh

HOST="$1"
PORT="$2"

echo "Esperando a $HOST:$PORT..."

while ! nc -z $HOST $PORT; do
  sleep 2
done

echo "$HOST:$PORT está disponible, iniciando la aplicación..."
shift 2
exec "$@"
