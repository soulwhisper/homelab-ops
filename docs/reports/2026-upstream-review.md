# 2026 Upstream Feature Review

Research date: 2026-09-04. Scope: all 90 in-cluster HelmReleases plus the 9
Synology compose stacks (`infrastructure/synology/`), each checked against its
2026 upstream release history (official sources). Method: per-namespace
parallel research passes, findings cross-checked against this repo's actual
configs. This is a capability-adoption review, not a version-bump list —
Renovate already keeps versions near-latest.

## Verdict legend

- **ADOPT** — clear benefit, implementable now
- **CONSIDER** — benefit with effort, risk, or a version gate
- **SKIP** — nothing material for this cluster
- **WATCH** — not actionable yet; tracked upstream item

## Implemented in this PR

| # | Feature | Where |
|---|---------|-------|
| 1 | VM `UncleanShutdown` + vmauth invalid-token alerts; Cilium config-drift alert | `monitoring-system/victoria-metrics` |
| 5 | node-exporter `nvmesubsystem` + expanded `edac` collectors | `monitoring-system/node-exporter` |
| 7 | kgateway ext-auth `headersToClient` for authentik redirects | `security-system` / gateway extension |
| 14 | Gatus OIDC via authentik + `/metrics` into VictoriaMetrics | `infrastructure/synology/gatus` |
| 15 | cert-manager ACME ARI (RFC 9773) feature gate | `security-system/cert-manager` |
| 16 | karakeep chrome image swap + embedding auto-tagging | `selfhosted-apps/karakeep` |
| 27 | dispatcharr trusted proxies behind kgateway | `selfhosted-apps/dispatcharr` |
| — | authentik `AUTHENTIK_WEB__BASE_URL` (mandatory in 2026.11) + trusted proxy CIDRs | `security-system/authentik` |

## Evaluated, deliberately not implemented

| # | Item | Reason |
|---|------|--------|
| 2 | LogsQL 2026 operators | capability, no config to write; existing rules unaffected by parser break |
| 3 | Grafana Traces Drilldown on VictoriaTraces | needs VT Tempo-API datasource validation; tracked separately |
| 4 | Grafana NoData/Error pending periods | gated on Grafana 12.4 |
| 6 | VM relabeling/cache improvements | already active in deployed v1.150 |
| 8 | gateway-level TrafficPolicy | no cluster-wide default worth forcing; per-route policies already exist |
| 9 | `route_source` trace metadata | invasive per-route annotation churn; revisit with tracing roadmap |
| 10 | Cilium weighted Maglev / trafficDistribution | no concrete service needs draining today; capability noted |
| 11 | TCPRoute/UDPRoute adoption | no non-HTTP service currently needs Gateway routing |
| 12 | external-dns CRD registry | tied to the v0.22 migration; prep tracked as landmine |
| 13 | authentik OBO/DCR | runtime-side provider config, not repo YAML; evaluate with agent IAM work |
| 17 | versitygw posix bucket versioning | redundant: DSM snapshots + kopia/barman self-versioning |
| 18 | CNPG DatabaseRole CRD | no concrete role to manage yet |
| 19 | CNPG in-place pg_upgrade path | future PG 19 work, no action now |
| 20 | Flux SSA field-ignore rules | no live drift problem to target |
| 21 | Talos 1.14 XFS/trim/scrub | done in PR #3457 |
| 22 | Frigate 0.17 features | config lives on PVC, not in repo |
| 23 | Jellyfin 12.0 | RC stage; adopt at stable with PVC backup (QSV overflow fix matters for i915) |
| 24 | Immich v3.2 | RC stage; zero config work when stable |
| 25 | Hindsight knowledge pages | app-level adoption, no repo config |
| 26 | Woodpecker concurrency/backend gates | env-gate names need verification against deployed values; deferred |
| 28 | Forgejo hook centralization + zoekt | runtime admin action (`forgejo admin hooks resync`); zoekt optional |
| 29 | homepage MCP server | homepage config on PVC; evaluate alongside agent access policy |

## Strategic watch items

- **frr-k8s vs Talos native BGPInstanceConfig**: not yet — interface-only
  advertisement, BFD default-domain-only, day-1 software. Revisit Talos 1.15/1.16.
- **Grafana 13**: React 19 plugin audit + DB backup before schema-v2 migration.
- **spegel 0.8**: removes the hostPort mechanism this cluster configures;
  change values before Renovate lands GA.
- **external-dns 0.22**: annotation-prefix flip can delete records; cluster is
  compliant on every breaking axis — dry-run first sync after upgrade.
- **volsync**: pinned to the perfectra1n fork for the kopia mover; fork is
  ~200 commits behind upstream — watch for an upstream kopia merge.
- **cephImage**: unpinned (chart default Tentacle 20.2.4); pin before Rook 1.21.

## Per-area research summary

### Observability
VictoriaMetrics 2026 line: native-histogram ingestion, MetricsQL `fill`,
relabeling −30% CPU on `if`-chains, per-target `__max_scrape_size__`, vmauth
remote-write 408 fix, working-set cache persisted on shutdown (less
post-restart slowness on ceph-block), v1.151 Basic-Auth bypass fix.
VictoriaLogs v1.52 distroless; v1.53 (pending) fixes a duplicate-stream-field
panic and makes internal endpoints POST-only. VictoriaTraces maturing fast:
Tempo APIs, Traces Drilldown support, vtagent persistent queue. Grafana 12.3/12.4
security and alert-quality work; 13.x is a deliberate hold.

### Networking
Cilium 1.20 (deployed): weighted Maglev backends, `trafficDistribution`,
config-drift metric, Hubble policy-correlated verdicts. kgateway 2.4:
gateway-level TrafficPolicy, ext-auth `headersToClient`, Brotli/Zstd,
route-source metadata. Gateway API 1.6 CRDs already carry TCPRoute/UDPRoute GA
and ListenerSet. frr-k8s stays (see watch items).

### Security
authentik 2026.8: trusted-proxy-CIDR forwarded headers, Base URL mandatory in
2026.11, OAuth token-exchange/OBO + DCR (agent-IAM relevant), Rust entrypoint.
cert-manager 1.21: ARI support. external-secrets 2.10: nothing applicable.
1Password Connect: quiet.

### Storage / database / gitops
Rook 1.20 CSI-operator migration done; Ceph Tentacle 20.2.4. CNPG 1.30
security train live; DatabaseRole CRD + podSelectorRefs pg_hba available.
Flux 2.9: SSA ignore rules, post-render strategies, OIDC receivers; repo is
v1beta2-clean. volsync fork watch stands.

### Media / smarthome / selfhosted
Jellyfin 12 (RC) QSV fix; Immich 3.2 (RC) Search v2; kavita 0.9.1 security +
jemalloc; karakeep semantic search; Frigate 0.17 local training/GenAI/OpenVINO;
Home Assistant 2026.9 (watch LLM tool-name prefixing); mosquitto 2.0 line stale.

### Synology
All compose stacks current. Forgejo v16 hooks centralization pending;
Gatus unauthenticated UI; zot's valkey 9.1.2 security image to confirm;
versitygw posix versioning optional.
