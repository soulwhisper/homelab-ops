## PIG support

- [pig-cli](https://pigsty.io/ext/pig/intro/) provides easy and clean way to manage pgsql extensions;
- Debian 12 bookworm has best deb compatibility, [extensions_list](https://pigsty.io/ext/list/deb/);

## Patch CNPG

- build custom image from `ghcr.io/cloudnative-pg/postgresql:17-standard-bookworm`;
- add Pigsty GPG key and signed upstream repository;
- install extensions with APT repo;

## Extensions

- `Category:TIME`, timescaledb, timescaledb_toolkit;
- `Category:GIS`, postgis;
- `Category:RAG`, vchord(req.vector);

### LOAD

```conf
shared_preload_libraries = 'timescaledb';
shared_preload_libraries = 'vchord';
```

### DDL

```sql
CREATE EXTENSION postgis;
CREATE EXTENSION timescaledb;
CREATE EXTENSION timescaledb_toolkit;
CREATE EXTENSION vchord CASCADE;
```
