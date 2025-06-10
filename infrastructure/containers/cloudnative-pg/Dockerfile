FROM ghcr.io/cloudnative-pg/postgresql:17-standard-bookworm

## : add extensions with pig-cli support
## : ref:https://ext.pigsty.io/#/list?id=debian-12-bookworm-compatible-os-d12
USER root

RUN apt update && \
    apt install -y curl && \
    mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://repo.pigsty.io/key | gpg --dearmor -o /etc/apt/keyrings/pigsty.gpg && \
    tee /etc/apt/sources.list.d/pigsty.list > /dev/null <<EOF
deb [signed-by=/etc/apt/keyrings/pigsty.gpg] https://repo.pigsty.io/apt/infra generic main
deb [signed-by=/etc/apt/keyrings/pigsty.gpg] https://repo.pigsty.io/apt/pgsql/bookworm bookworm main
EOF

## : extensions : add PostGIS,TimescaleDB,VectorChord(req.vector)
RUN apt update && \
    apt install -y pig && \
    pig ext install postgis timescaledb timescaledb_toolkit vchord

USER 26
