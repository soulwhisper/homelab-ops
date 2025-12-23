## Multi-doc Configuration

```
talos/
├── talconfig.yaml
├── patches/
│   ├── global/
│   │   ├── 05-time-sync.yaml
│   │   ├── 10-net-lo.yaml
│   │   ├── 20-dns-resolver.yaml
│   │   └── 80-extension-nut.yaml
│   ├── controlplane/
│   │   ├── 70-api-audit-policy.yaml
│   │   └── 75-etcd-tuning.yaml
│   ├── worker/
│   │   └── 60-kubelet-resource.yaml
│   └── nodes/
│       ├── exarch-01/
│       │   ├── 00-hostname.yaml
│       │   ├── 12-net-bond0.yaml
│       │   └── 35-extra-mounts.yaml
│       └── exarch-02/
│           ├── ...
```

| Prefix | Category           | Function                                   | Config Paths                 | Example                     |
| ------ | ------------------ | ------------------------------------------ | ---------------------------- | --------------------------- |
| 00-09  | Identity & Boot    | Node identity                              | HostnameConfig               | 00-hostname.yaml            |
|        |                    | Time synchronization                       | TimeConfig                   | 05-time-sync.yaml           |
|        |                    | Early boot kernel arguments                | .machine.install             |                             |
| 10-19  | Networking (L1-L3) | Physical links                             | LinkConfig                   | 10-link-enp3s0.yaml         |
|        |                    | Bonding                                    | BondConfig                   | 12-bond0-lacp.yaml          |
|        |                    | VLAN                                       | VLANConfig                   | 15-vlan-iot.yaml            |
|        |                    | Addressing and Routing                     | AddressConfig                |                             |
| 20-29  | Networking (L4-L7) | DNS resolution                             | ResolverConfig               | 20-dns-resolver.yaml        |
|        |                    | Static host entries                        | StaticHostConfig             | 25-hosts-local.yaml         |
| 30-39  | Storage & Mounts   | Disk formatting, Partitions                | VolumeConfig                 |                             |
|        |                    | Encryption (LUKS)                          |                              | 32-disk-encryption.yaml     |
|        |                    | Extra mounts                               | .machine.kubelet.extraMounts | 35-mount-longhorn.yaml      |
| 40-49  | Kernel & System    | Sysctl tuning                              | .machine.sysctls             | 40-sysctl-tuning.yaml       |
|        |                    | Kernel modules                             | .machine.kernel.modules      | 45-modules-zfs.yaml         |
|        |                    | System logging                             | .machine.logging             |                             |
| 50-59  | Container Runtime  | Image registries, mirrors                  | .machine.registries          | 50-registry-mirrors.yaml    |
|        |                    | Credential providers, container signatures | .machine.imagePolicy         | 55-cosign-policy.yaml       |
| 60-69  | Kubernetes Core    | Kubelet args                               | .machine.kubelet             | 60-kubelet-resource.yaml    |
|        |                    | Node labels/taints                         | .machine.nodeLabels          | 65-node-labels.yaml         |
|        |                    | Kube-proxy, Cluster discovery              | .machine.network.discovery   |                             |
| 70-79  | Control Plane      | API Server                                 | .cluster.apiServer           | 70-apiserver-audit.yaml     |
|        |                    | Etcd configuration                         | .cluster.etcd                | 75-etcd-metrics.yaml        |
| 80-89  | Extensions         | Talos extensions                           | ExtensionServiceConfig       | 80-extension-tailscale.yaml |
|        |                    |                                            | .machine.features            | 85-gvisor-runtime.yaml      |
| 90-99  | Overrides & Debug  | disabling security features                | Any                          | 90-disable-secureboot.yaml  |
|        |                    | environment overrides                      |                              | 99-enable-hci-console.yaml  |
