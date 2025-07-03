## CRDs

- There is a time lag between when a CRD is created (or updated) and when the Kubernetes API server fully recognizes and serves the new resource type. Just wait.

### Install before init

- prometheus-crds, by ks `monitoring-system/prometheus-operator-crds`;
- gateway-api, no chart;
- external-secrets, by ks `security-system/external-secrets`; needed by components;

### Managed manually

- silence-operator

```shell
kubectl delete crd silences.monitoring.giantswarm.io
kubectl apply --server-side -f https://raw.githubusercontent.com/giantswarm/silence-operator/main/config/crd/bases/observability.giantswarm.io_silences.yaml
```
