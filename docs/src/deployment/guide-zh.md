## 部署指南 ( Outdated )

### 硬件

- Minisforum MS-01, x3; 每台至少 2 块存储;
- 10G 交换机, 至少 4 口, 推荐 8 口以上, x1;
- NAS, x1;

### 软件

- gitops 目录: [soulwhisper/homelab-ops](https://github.com/soulwhisper/homelab-ops);
- 工作机: [soulwhisper/nix-config#nix-dev](https://github.com/soulwhisper/nix-config/tree/main/hosts/nix-dev), 或 Archlinux;
- 引导工具: [ventoy](https://www.ventoy.net/cn/index.html);

### 相关技术

- [external-secrets-1password](https://external-secrets.io/main/provider/1password-automation/);
- [external-dns-cloudflare](https://github.com/kubernetes-sigs/external-dns/blob/master/docs/tutorials/cloudflare.md);
- [sops-age](https://github.com/getsops/sops?tab=readme-ov-file#encrypting-using-age);
- [talos](https://www.talos.dev), [talhelper](https://budimanjojo.github.io/talhelper/latest/);

### 准备工作

- 准备代理;
- 准备第三方密钥管理工具, 推荐使用 1password; 生成 1password 开发工具中的访问令牌;
- 准备一个私人域名, 推荐使用 cloudflare, 此处域名为 `noirprime.com`; 配置 cloudflare-tunnel;
- 准备 NAS, 同时在 NAS 上部署 Adguard, Minio 和代理服务端, 共享备份目录 ( 此处目录为 `/mnt/pool_hdd/media` );
- 为 Homelab-Ops 单独划分一个子网, 其中 NAS 使用 `.10` 的 IP;
- 使用 10G 光纤将 MS-01 与交换机相连, 将 NAS 与交换机相连，在交换机内部配置 DHCP, 范围为上面划定的独立子网 ( `.100-.200` );
- 在 Adguard 中配置 DNS 重写, 指定主机名和其对应的 IP 地址; 该操作也可通过静态 DHCP 主机名实现;

### 初始化

- 使用 git 下载 gitops 目录到本地;
- 修改 `https://github.com/soulwhisper/homelab-ops/tree/main/kubernetes/infrastructure/bootstrap/talos` 目录下的 K8S 配置;
  - 替换 `172.19.82.` 为自己的子网, 根据需要调整主机 IP 地址 ( `.100-.200` );
  - 如不需要 Tailscale, 段落 `extensionServices` 可删除;
  - 其他配置无需修改;
- 使用 `talhelper gen secret > talsecret.sops.yaml` 生成自己的 `talsecret.sops.yaml`;
- 使用 age 生成自己的密钥, 参照 `ExternalSecret.md` 生成自己的 1password 密钥;
- 替换以下文档中的内容;
  - `kubernetes/infrastructure/bootstrap/bootstrap.env`
  - `kubernetes/infrastructure/bootstrap/talos/talhelper.env`
  - `kubernetes/components/flux/sops/secret.sops.yaml`
- 使用 `infra/scripts/minio-bucket-keys.py` 初始化 NAS 上的 Minio;

### 部署工作

- 根据 talconfig 中的 schematic 配置在 [TalosLinuxImageFactory](https://factory.talos.dev/) 上生成镜像 iso;
- 使用 ventoy 引导 MS-01 UEFI 启动, 关闭 Secure-boot;
- 在本地 gitops 目录中运行以下指令完成初步部署;

```shell
task talos:generate-clusterconfig
task talos:apply-clusterconfig
task talos:bootstrap
```

- 启用 gitops
  - 将修改后的本地目录推送到 git 服务器上自己的目录, 修改 `kubernetes/flux/config/cluster.yaml` 中的 url 地址;
  - 在本地 gitops 目录中运行 `task flux:bootstrap`;
