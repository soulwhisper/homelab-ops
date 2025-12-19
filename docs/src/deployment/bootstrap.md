## Bootstrap

```shell
cd homelab-ops
direnv allow

eval $(op signin)

# bootstrap, mode='prod'
just talos image prod
just talos generate prod
just bootstrap

# check
kubectl get ks -A
kubectl get hr -A

# reboot each machine at least once to ensure env propagated

```
