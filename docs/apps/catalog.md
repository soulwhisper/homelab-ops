# Application Catalog

86 applications across 13 namespaces, managed via Flux GitOps.

> Ratings: ⭐⭐⭐⭐⭐ deeply optimized · ⭐⭐⭐⭐ production-ready · ⭐⭐⭐ well-configured

## kube-system — Cluster Infrastructure (11)

| App              | Purpose                                            |   Rating   |
| ---------------- | -------------------------------------------------- | :--------: |
| Cilium           | CNI, eBPF, Hubble (netkit, BBR, BIGTCP, Maglev LB) | ⭐⭐⭐⭐⭐ |
| CoreDNS          | Cluster DNS                                        |  ⭐⭐⭐⭐  |
| Spegel           | P2P image distribution                             |  ⭐⭐⭐⭐  |
| FRR-K8s          | BGP peering with core switch (BFD)                 | ⭐⭐⭐⭐⭐ |
| Metrics Server   | Resource metrics for HPA/VPA                       |  ⭐⭐⭐⭐  |
| Intel GPU Plugin | i915 GPU exposure for transcoding                  |  ⭐⭐⭐⭐  |
| Reloader         | Auto-restart on ConfigMap/Secret change            |  ⭐⭐⭐⭐  |
| Descheduler      | Pod rebalancing                                    |   ⭐⭐⭐   |
| K8tz             | Timezone injection (Asia/Shanghai)                 |   ⭐⭐⭐   |
| Runtime Classes  | Kata Containers VM isolation                       | ⭐⭐⭐⭐⭐ |
| Gateway API CRDs | CRDs for kgateway                                  |  ⭐⭐⭐⭐  |

## gitops-system — GitOps Engine (3)

| App                       | Purpose                    |   Rating   |
| ------------------------- | -------------------------- | :--------: |
| Flux Operator + Instance  | GitOps controller          | ⭐⭐⭐⭐⭐ |
| System Upgrade Controller | Talos/K8s version upgrades | ⭐⭐⭐⭐⭐ |

## security-system — Security (4)

| App               | Purpose                     |   Rating   |
| ----------------- | --------------------------- | :--------: |
| External Secrets  | 1Password → K8s Secret sync | ⭐⭐⭐⭐⭐ |
| 1Password Connect | 1Password API bridge        | ⭐⭐⭐⭐⭐ |
| Authentik         | SSO/OIDC provider (14 apps) | ⭐⭐⭐⭐⭐ |
| Cert-Manager      | TLS certificate automation  |  ⭐⭐⭐⭐  |

## networking-system — Network Services (3)

| App           | Purpose                                 |   Rating   |
| ------------- | --------------------------------------- | :--------: |
| Kgateway      | Envoy Gateway API (internal + external) | ⭐⭐⭐⭐⭐ |
| Agent Gateway | AI LLM (5-model routing) + MCP gateway  | ⭐⭐⭐⭐⭐ |
| External DNS  | AdGuardHome DNS automation              |  ⭐⭐⭐⭐  |

## storage-system — Storage (5)

| App                 | Purpose                                  |   Rating   |
| ------------------- | ---------------------------------------- | :--------: |
| Rook-Ceph           | Distributed storage (RBD + CephFS + RGW) | ⭐⭐⭐⭐⭐ |
| VolSync             | PVC backup (Kopia → Ceph S3)             |  ⭐⭐⭐⭐  |
| Snapshot Controller | Volume snapshot management               |  ⭐⭐⭐⭐  |
| OpenEBS LocalPV     | Node-local persistent storage            |   ⭐⭐⭐   |
| CSI Driver NFS      | Synology NFS mount CSI                   |   ⭐⭐⭐   |

## database-system — Databases (3)

| App           | Purpose                                      |   Rating   |
| ------------- | -------------------------------------------- | :--------: |
| CloudNativePG | PostgreSQL cluster (PGVector, Barman backup) | ⭐⭐⭐⭐⭐ |
| Dragonfly     | Redis-compatible cache                       | ⭐⭐⭐⭐⭐ |
| ClickHouse    | Analytical database (Langfuse backend)       |  ⭐⭐⭐⭐  |

## monitoring-system — Observability (14)

| App                     | Purpose                                                |   Rating   |
| ----------------------- | ------------------------------------------------------ | :--------: |
| VictoriaMetrics Cluster | Time-series metrics (30d retention)                    | ⭐⭐⭐⭐⭐ |
| VictoriaLogs            | Log aggregation                                        |  ⭐⭐⭐⭐  |
| VictoriaTraces          | Distributed tracing                                    |  ⭐⭐⭐⭐  |
| Grafana                 | Dashboards (vendir-synced)                             |  ⭐⭐⭐⭐  |
| OTEL Collector          | Telemetry pipeline (credential redaction, dual export) | ⭐⭐⭐⭐⭐ |
| Node Exporter           | Host-level metrics                                     |  ⭐⭐⭐⭐  |
| Kube-State-Metrics      | K8s object state metrics                               |  ⭐⭐⭐⭐  |
| Smartctl Exporter       | NVMe/SSD SMART monitoring                              |  ⭐⭐⭐⭐  |
| Blackbox Exporter       | Endpoint probing (HTTP/TCP/ICMP)                       |   ⭐⭐⭐   |
| Heartbeats              | CronJob heartbeat monitoring                           |   ⭐⭐⭐   |
| Silence Operator        | Alert silencing for maintenance                        |  ⭐⭐⭐⭐  |
| Headlamp                | K8s Web UI (RBAC + OIDC)                               |  ⭐⭐⭐⭐  |
| Langfuse                | LLM observability (ClickHouse + CNPG + S3)             | ⭐⭐⭐⭐⭐ |
| Prometheus CRDs         | Operator CRDs                                          |  ⭐⭐⭐⭐  |

## smarthome-apps — Smart Home (7)

| App            | Purpose                                |   Rating   |
| -------------- | -------------------------------------- | :--------: |
| Home Assistant | Home automation hub (OIDC, HACS, SGCC) | ⭐⭐⭐⭐⭐ |
| Mosquitto      | MQTT broker (LoadBalancer IP)          |  ⭐⭐⭐⭐  |
| Zigbee2MQTT    | Zigbee → MQTT bridge                   |  ⭐⭐⭐⭐  |
| Frigate        | AI NVR (Coral TPU)                     |  ⭐⭐⭐⭐  |
| Scrypted       | Video streaming (iGPU QSV)             |  ⭐⭐⭐⭐  |
| Code Server    | Web IDE (OIDC)                         |  ⭐⭐⭐⭐  |
| Smarthome-NFS  | Shared NFS storage (500Gi)             |   ⭐⭐⭐   |

## media-apps — Media (11)

| App         | Purpose                                    |   Rating   |
| ----------- | ------------------------------------------ | :--------: |
| Jellyfin    | Media streaming (iGPU transcode)           |  ⭐⭐⭐⭐  |
| Immich      | Photo management (CNPG + ML)               | ⭐⭐⭐⭐⭐ |
| Navidrome   | Music streaming (Subsonic)                 |  ⭐⭐⭐⭐  |
| Kavita      | Comic/eBook reader (OIDC)                  |  ⭐⭐⭐⭐  |
| Qbittorrent | Torrent client (LoadBalancer IP + QUI)     |  ⭐⭐⭐⭐  |
| MeTube      | Video downloader (yt-dlp)                  |   ⭐⭐⭐   |
| MoviePilot  | Media automation (CNPG + Dragonfly + iGPU) | ⭐⭐⭐⭐⭐ |
| Media-NFS   | Shared media storage                       |   ⭐⭐⭐   |

## selfhosted-apps — Self-Hosted Services (16)

| App            | Purpose                                          |   Rating   |
| -------------- | ------------------------------------------------ | :--------: |
| Stirling-PDF   | PDF toolkit (50+ operations)                     |  ⭐⭐⭐⭐  |
| NetBox         | DCIM/IPAM (9 plugins, CNPG + Dragonfly)          | ⭐⭐⭐⭐⭐ |
| Miniflux       | RSS reader (CNPG, OIDC)                          |  ⭐⭐⭐⭐  |
| RSSHub         | RSS feed generator (Dragonfly, OIDC)             |  ⭐⭐⭐⭐  |
| SearXNG        | Privacy meta-search (Dragonfly, bot detection)   | ⭐⭐⭐⭐⭐ |
| Homepage       | App dashboard                                    |  ⭐⭐⭐⭐  |
| Karakeep       | Bookmark manager (Kata VM, Chrome + Meilisearch) | ⭐⭐⭐⭐⭐ |
| Hindsight      | AI memory platform (pgvector, OTEL, MCP)         | ⭐⭐⭐⭐⭐ |
| Open-Notebook  | AI research notebook (SurrealDB)                 | ⭐⭐⭐⭐⭐ |
| Firecrawl      | Web scraping pipeline (Kata, 3 containers, MCP)  | ⭐⭐⭐⭐⭐ |
| SillyTavern    | AI character chat (AgentGateway)                 |  ⭐⭐⭐⭐  |
| Fast-Note-Sync | Obsidian sync (REST + MCP + WebSocket)           |  ⭐⭐⭐⭐  |
| Bambuddy       | 3D printer monitor (Bambu Lab)                   |   ⭐⭐⭐   |
| Dispatcharr    | IPTV dispatch (iGPU transcode)                   |   ⭐⭐⭐   |

## servitor-apps — AI Infrastructure (5)

| App               | Purpose                                                                 |   Rating   |
| ----------------- | ----------------------------------------------------------------------- | :--------: |
| Hermes Agent      | AI agent suite (Kata VM, WeChat)                                        | ⭐⭐⭐⭐⭐ |
| Llama (llama.cpp) | Local LLM (Qwen3.5-4B, CephFS 50Gi)                                     | ⭐⭐⭐⭐⭐ |
| ToolHive          | MCP gateway (11 servers, semantic search)                               | ⭐⭐⭐⭐⭐ |
| Devbox            | AI dev sandbox (Kata VM, AgentGateway)                                  |  ⭐⭐⭐⭐  |
| MCP Servers       | kubernetes/HA/hindsight/honcho/note/github/firecrawl/grafana/flux/vlogs | ⭐⭐⭐⭐⭐ |

## gaming-apps — Gaming (3)

| App               | Purpose                               |  Rating  |
| ----------------- | ------------------------------------- | :------: |
| Crafty Controller | Minecraft server control panel        |  ⭐⭐⭐  |
| FoundryVTT        | Virtual tabletop RPG (ExternalSecret) | ⭐⭐⭐⭐ |
| Gaming-NFS        | Shared game storage                   |  ⭐⭐⭐  |

## worker-apps — CI/CD (1)

| App        | Purpose           |  Rating  |
| ---------- | ----------------- | :------: |
| Woodpecker | Self-hosted CI/CD | ⭐⭐⭐⭐ |
