#!/bin/sh
set -m

docker-entrypoint.sh server -dev-kv-v1 -dev-root-token-id "rootToken" &
echo "Waiting for Vault to initialize..."
while [ "$(curl http://127.0.0.1:8200/v1/sys/health | jq '.initialized')" != "true" ]; do
    echo 'Vault is Initializing...'
    sleep 2
done

echo "Vault Started."

fg %1
