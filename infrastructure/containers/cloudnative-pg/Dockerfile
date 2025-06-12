# ARG BASE=ghcr.io/cloudnative-pg/postgresql:17-standard-bookworm
ARG BASE=ghcr.io/supabase/postgres:latest
FROM $BASE AS cnpg-dev

## : add extensions with pig-cli support
## : ref:https://ext.pigsty.io/#/list
USER root

RUN apt update && \
    apt install -y curl lsb-release && \
    mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://repo.pigsty.io/key | gpg --dearmor -o /etc/apt/keyrings/pigsty.gpg && \
    tee /etc/apt/sources.list.d/pigsty.list > /dev/null <<EOF
deb [signed-by=/etc/apt/keyrings/pigsty.gpg] https://repo.pigsty.io/apt/infra generic main
deb [signed-by=/etc/apt/keyrings/pigsty.gpg] https://repo.pigsty.io/apt/pgsql/$(lsb_release -cs) $(lsb_release -cs) main
EOF

## : cnpg-req : overwrite basics
## : extensions : add VectorChord(req.vector)
RUN apt update && \
    apt install -y --no-install-recommends locales-all pig && \
    pig ext install pgaudit pg_failover_slots pgvector vchord && \
    apt purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false && \
    rm -rf /var/lib/apt/lists/* /var/cache/* /var/log/*

RUN usermod -u 26 -g 102 postgres
USER 26
