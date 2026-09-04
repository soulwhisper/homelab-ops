# 2026 上游观察与判断指南

调研日期：2026-09-04。范围：集群内 90 个 HelmRelease + Synology 上 9 个
compose 栈，逐项对照 2026 年上游发布记录（官方来源）。

本报告不回答"升哪个版本"（Renovate 已覆盖），而是回答两个问题：

1. **盯什么** —— 哪些上游动向值得持续观察，观察的具体信号是什么；
2. **怎么判** —— 信号出现后，用什么标准判断"该动 / 不该动"。

## 判断框架（所有条目共用）

任何上游变化落到这个集群，按四问过滤：

| 问题 | 判据 |
|------|------|
| 有没有使用者？ | 集群里有没有真实消费该功能的工作负载；没有 → 忽略 |
| 默认值是否已覆盖？ | 上游新默认值是否已经隐含收益；是 → 不重复配置 |
| 失败域多大？ | 改错了影响面是单应用还是 etcd/网络/存储层；后者必须先在 test 环境验证 |
| 可回滚吗？ | 纯 GitOps 配置可回滚；数据迁移/PVC 变更需先备份 |

## 主动观察项（watch list）

| 观察对象 | 观察信号 | 行动判据 |
|----------|----------|----------|
| **Talos 原生 BGPInstanceConfig 替代 frr-k8s** | Talos 1.15/1.16 release notes：是否支持前缀（非接口）通告、BFD 进 VRF | 两个能力都落地且经过至少一个小版本沉淀 → test 环境先跑；否则维持 frr-k8s |
| **spegel 0.8** | Renovate 出现 0.8.x PR | 触发即动：0.8 移除了本集群在用的 hostPort 机制，先改 values 再合 |
| **external-dns 0.22** | helm chart 1.22 发布 | 注解前缀翻转可能删记录；本集群各破坏面已合规，升级后先跑一次 `--dry-run` |
| **Grafana 13** | 13.x 稳定版 + 插件清单 | 升级前先过 React 19 插件兼容性，DB 备份后再做 schema-v2 自动迁移 |
| **VictoriaLogs v1.53** | v1.53 发布 | 修复重复流字段 panic；内部端点改为 POST-only —— 升级前审计调用脚本 |
| **OTel collector chart 携带 v0.160** | chart 更新 | 评估 `batch` → `queuebatch`（O(1) 字节批处理）；注意 memory_limiter 指标改名对仪表板的影响 |
| **volsync fork 漂移** | upstream backube 合并 kopia mover 或发布安全修复 | fork 已落后 ~200 commit；upstream 原生支持 kopia 之日即回迁之时 |
| **Rook 1.21** | 1.21 发布 | 合并前显式 pin cephImage（当前跟随 chart 默认 Tentacle 20.2.4），把 Ceph 升级时机拿到手里 |
| **Jellyfin 12.0** | 正式版发布（当前 RC7） | 含 i915 QuickSync 的 QSV 溢出修复；升级前先备份 config PVC，插件需重装 |
| **mosquitto 2.0 分支停更** | 当前 2.0.22 停留在 2025-07 | 升 2.1.2 时同步迁移废弃的 `password_file` 配置 |
| **authentik 2026.11** | 2026.11 发布 | `AUTHENTIK_WEB__BASE_URL` 已提前配置（PR #3473），到期无动作 |

## 已实施 / 已判断（本轮结论）

### 已实施（PR #3457 / #3473）

- VM `UncleanShutdown` + Cilium `ConfigMapDrift` 告警 —— 盯的是"进程非正常退出"与"ConfigMap 改了但没生效"两类静默故障
- node-exporter `nvmesubsystem`/`edac` 采集器 —— NVMe 与内存 ECC 可观测性
- kgateway ext-auth `headersToClient` —— authentik 登录重定向恢复可达
- cert-manager ACME ARI —— Let's Encrypt 大规模吊销时的续期窗口
- karakeep 语义搜索（embeddings 走 MacStudio qwen3-embedding-4b）+ chrome 镜像替换
- authentik `BASE_URL` / 可信代理 CIDR
- Talos 1.14 全量 multi-doc 迁移（PR #3457，含 XFS scrub、RAID1 引导测试环境等）

### 判断为"不动"（含理由）

| 条目 | 判断 |
|------|------|
| Talos NRI 默认开启 | 无插件即惰性；没有 NRI 消费者，关闭是负收益 |
| SysfsConfig | 现有调优全部属于 sysctl / 内核参数，无可迁移项 |
| XFS AG 几何 | 现有 2TB 卷 ≈100GiB AG，已高于新默认 64GiB 下限；重格式化才生效，无需动作 |
| versitygw 桶版本控制 | DSM 快照 + kopia/barman 自版本化已覆盖该风险 |
| CNPG DatabaseRole / Flux SSA 忽略规则 | 无具体对象指向；为空写配置是负资产 |
| `exclude-from-external-load-balancers` 标签 | Cilium LB 路径不消费此标签；移除无意义 |
| Frigate 0.17 / homepage MCP / hindsight 知识页 | 配置在 PVC/运行时，不在仓库内 |

## 复查节奏

- **每周**：Renovate PR 里的 release notes 扫一眼破坏面（spegel、external-dns 类）
- **每月**：对照本表 watch list 检查信号是否触发
- **每季度**：重跑一次全量上游扫描，更新本报告
