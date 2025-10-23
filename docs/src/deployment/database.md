## Database

### Relational

- Use `Postgresql` as app general database, with `cloudnative-pg` support, in `database-system` namespace;
- Use `pig` to build central postgres instance with extensions, [ref](https://github.com/soulwhisper/homelab-ops/infrastructure/containers/cloudnative-pg/README.md);
- Serve `${APP}-initdb` and `${APP}-pguser` secrets per app via `component:cnpg`, in app namespaces;
- Current instance `Postgres` contains `vector, vchord`;
- Current Status: Active;

### In-Memory

- Use `Dragonfly` as app in-memory data store instead of `valkey` and `redis`;
- Serve 1 instance per app via `component:dragonfly`, in app namespaces;
- Current Status: Active;

### MQTT

- Use `EMQX` for home-assistant zigbee2mqtt;
- No need to backup for homelab usage;
