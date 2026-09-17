#!/usr/bin/env bash

HOST="${TARGET_HOST:-${1:-127.0.0.1}}"
PORT="${PORT:-${2:-8080}}"

if timeout 1 bash -c "</dev/tcp/$HOST/$PORT" 2>/dev/null; then
    echo "Host $HOST e Porta $PORT está aberta e respondendo!"
else
    echo "Host $HOST e Porta $PORT está fechada!"
    exit 1
fi

HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://$HOST:$PORT/actuator/health)
PAYLOAD=$(curl -s http://$HOST:$PORT/actuator/health)

if [[ "$HTTP_STATUS" == "200" ]] && echo "$PAYLOAD" | grep '"status":"UP"' ; then
    echo "Serviço saudável (HTTP 200)"    
else
    echo "Falha no serviço (HTTP $HTTP_STATUS)"
    exit 1
fi

echo "Healthcheck concluído com sucesso!"
exit 0