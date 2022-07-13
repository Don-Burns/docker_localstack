FROM vault
COPY init-vault.sh /usr/local/bin/init-vault.sh

RUN apk add curl jq
ENV VAULT_ADDR='http://0.0.0.0:8200'

ENTRYPOINT ["init-vault.sh"]