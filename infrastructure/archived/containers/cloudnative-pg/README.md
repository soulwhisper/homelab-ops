## Postgres with Extensions

- [pig-cli](https://pigsty.io/ext/pig/intro/) provides easy and clean way to manage pgsql extensions;
- Debian 12 bookworm has best deb compatibility, [extensions_list](https://pigsty.io/ext/list/deb/);

### Patch CNPG

- build custom image from `ghcr.io/cloudnative-pg/postgresql:17-standard-bookworm`;
- add Pigsty GPG key and signed upstream repository;
- install extensions with APT repo;

### Supabase-based

- This category explains how to use `supabase/postgres:17`, [ref](https://github.com/supabase/postgres), as cnpg base-image;
- Also check `Dockerfile`;

> cnpg-cluster

```yaml
# ...
spec:
  postgresUID: 105 # set this or provide custom image
  postgresGID: 106 # set this or provide custom image
  postgresql:
    shared_preload_libraries:
      - auto_explain
      - pg_cron
      - pg_net
      - pg_stat_monitor
      - pg_tle
      - pgaudit
      - pgsodium
      - pg_stat_statements
      - plan_filter
      - plpgsql_check
      - safeupdate
      - supautils
    parameters:
      auto_explain.log_min_duration: "10s"
      cron.database_name: "postgres"
      pgsodium.getkey_script: "/usr/lib/postgresql/bin/pgsodium_getkey.sh"
      vault.getkey_script: "/usr/lib/postgresql/bin/pgsodium_getkey.sh"
      supautils.extensions_parameter_overrides: '{"pg_cron":{"schema":"pg_catalog"}}'
      supautils.policy_grants: '{"postgres":["auth.audit_log_entries","auth.identities","auth.refresh_tokens","auth.sessions","auth.users","realtime.messages","storage.buckets","storage.migrations","storage.objects","storage.s3_multipart_uploads","storage.s3_multipart_uploads_parts"]}'
      supautils.drop_trigger_grants: '{"postgres":["auth.audit_log_entries","auth.identities","auth.refresh_tokens","auth.sessions","auth.users","realtime.messages","storage.buckets","storage.migrations","storage.objects","storage.s3_multipart_uploads","storage.s3_multipart_uploads_parts"]}'
      supautils.privileged_extensions: "address_standardizer, address_standardizer_data_us, autoinc, bloom, btree_gin, btree_gist, citext, cube, dblink, dict_int, dict_xsyn, earthdistance, fuzzystrmatch, hstore, http, hypopg, index_advisor, insert_username, intarray, isn, ltree, moddatetime, orioledb, pg_buffercache, pg_cron, pg_graphql, pg_hashids, pg_jsonschema, pg_net, pg_prewarm, pg_repack, pg_stat_monitor, pg_stat_statements, pg_tle, pg_trgm, pg_walinspect, pgaudit, pgcrypto, pgjwt, pgroonga, pgroonga_database, pgrouting, pgrowlocks, pgsodium, pgstattuple, pgtap, plcoffee, pljava, plls, plpgsql_check, postgis, postgis_raster, postgis_sfcgal, postgis_tiger_geocoder, postgis_topology, postgres_fdw, refint, rum, seg, sslinfo, supabase_vault, supautils, tablefunc, tcn, tsm_system_rows, tsm_system_time, unaccent, uuid-ossp, vector, wrappers"
      supautils.extension_custom_scripts_path: "/etc/postgresql-custom/extension-custom-scripts"
      supautils.privileged_extensions_superuser: "supabase_admin"
      supautils.privileged_role: "postgres"
      supautils.privileged_role_allowed_configs: "auto_explain.*, log_lock_waits, log_min_duration_statement, log_min_messages, log_replication_commands, log_statement, log_temp_files, pg_net.batch_size, pg_net.ttl, pg_stat_statements.*, pgaudit.log, pgaudit.log_catalog, pgaudit.log_client, pgaudit.log_level, pgaudit.log_relation, pgaudit.log_rows, pgaudit.log_statement, pgaudit.log_statement_once, pgaudit.role, pgrst.*, plan_filter.*, safeupdate.enabled, session_replication_role, track_io_timing, wal_compression"
      supautils.reserved_memberships: "pg_read_server_files, pg_write_server_files, pg_execute_server_program, supabase_admin, supabase_auth_admin, supabase_storage_admin, supabase_read_only_user, supabase_realtime_admin, supabase_replication_admin, dashboard_user, pgbouncer, authenticator"
      supautils.reserved_roles: "supabase_admin, supabase_auth_admin, supabase_storage_admin, supabase_read_only_user, supabase_realtime_admin, supabase_replication_admin, dashboard_user, pgbouncer, service_role*, authenticator*, authenticated*, anon*"
    pg_hba:
      - "local all  supabase_admin      scram-sha-256"
      - "local all  all                 peer map=supabase_map"
      - "host  all  all  127.0.0.1/32   trust"
      - "host  all  all  ::1/128        trust"
      - "host  all  all  10.0.0.0/8     scram-sha-256"
      - "host  all  all  172.16.0.0/12  scram-sha-256"
      - "host  all  all  192.168.0.0/16 scram-sha-256"
      - "host  all  all  0.0.0.0/0      scram-sha-256"
      - "host  all  all  ::0/0          scram-sha-256"
    pg_ident:
      # Note that here we have to use 'local' to map the supabase_admin user to the postgres user
      # because cnpg has a higher priority of 'local' over 'supabase_map'.
      - "local         postgres   supabase_admin"
      - "local         root       postgres"
      - "local         ubuntu     postgres"
      - "local         gotrue     supabase_auth_admin"
      - "local         postgrest  authenticator"
      - "local         adminapi   postgres"
# ...
```

> deprecated: patch cnpg to supabase

```shell
# Dockerfile
## ref:https://github.com/supabase/postgres/pkgs/container/postgres
## ext: auto_explain,pg_stat_statements,pgaudit,vector is included in cnpg-image
## ext: pg_backtrace, is removed due to incompatibility(only for PG12)
RUN apt update && \
    pig ext add -y hypopg index_advisor pg_cron pg_graphql pg_hashids pg_jsonschema pg_net && \
    pig ext add -y pg_plan_filter pg_repack safeupdate pg_stat_monitor pg_tle pgmq pgroonga pgrouting && \
    pig ext add -y pgsodium pg_http pgtap plpgsql_check postgis rum wrappers supautils pg_vault wal2json

```

```yaml
spec:
  postgresql:
    shared_preload_libraries:
      - pg_cron
      - pg_net
      - pg_stat_monitor
      - pg_tle
      - pgsodium
      - plan_filter
      - plpgsql_check
      - safeupdate
      - supautils
    parameters:
      auto_explain.log_min_duration: "10s"
      cron.database_name: "postgres"
  # ...
  bootstrap:
    initdb:
      postInitSQL:
        - CREATE EXTENSION IF NOT EXISTS hypopg;
        - CREATE EXTENSION IF NOT EXISTS index_advisor;
        - CREATE EXTENSION IF NOT EXISTS pg_graphql;
        - CREATE EXTENSION IF NOT EXISTS pg_hashids;
        - CREATE EXTENSION IF NOT EXISTS pg_jsonschema;
        - CREATE EXTENSION IF NOT EXISTS pg_net;
        - CREATE EXTENSION IF NOT EXISTS pg_repack;
        - CREATE EXTENSION IF NOT EXISTS pg_stat_monitor;
        - CREATE EXTENSION IF NOT EXISTS pg_tle;
        - CREATE EXTENSION IF NOT EXISTS pgmq;
        - CREATE EXTENSION IF NOT EXISTS pgroonga;
        - CREATE EXTENSION IF NOT EXISTS pgrouting CASCADE;
        - CREATE EXTENSION IF NOT EXISTS pgsodium;
        - CREATE EXTENSION IF NOT EXISTS http;
        - CREATE EXTENSION IF NOT EXISTS pgtap;
        - CREATE EXTENSION IF NOT EXISTS plpgsql_check CASCADE;
        - CREATE EXTENSION IF NOT EXISTS postgis;
        - CREATE EXTENSION IF NOT EXISTS rum;
        - CREATE EXTENSION IF NOT EXISTS wrappers;
        - CREATE EXTENSION IF NOT EXISTS supabase_vault CASCADE
```
