## EMQX

- community edition not support any kind of replication;
- deprecated due to extra complexity;

### Dashboards

```yaml
emqx-overview:
  url: https://raw.githubusercontent.com/emqx/emqx-exporter/refs/heads/main/grafana-dashboard/template/emqx-5/overview.json
  datasource: Prometheus
emqx-authentication:
  url: https://raw.githubusercontent.com/emqx/emqx-exporter/refs/heads/main/grafana-dashboard/template/emqx-5/authentication.json
  datasource: Prometheus
emqx-authorization:
  url: https://raw.githubusercontent.com/emqx/emqx-exporter/refs/heads/main/grafana-dashboard/template/emqx-5/authorization.json
  datasource: Prometheus
emqx-client-events:
  url: https://raw.githubusercontent.com/emqx/emqx-exporter/refs/heads/main/grafana-dashboard/template/emqx-5/client-events.json
  datasource: Prometheus
emqx-messages:
  url: https://raw.githubusercontent.com/emqx/emqx-exporter/refs/heads/main/grafana-dashboard/template/emqx-5/messages.json
  datasource: Prometheus
emqx-rule-engine-count:
  url: https://raw.githubusercontent.com/emqx/emqx-exporter/refs/heads/main/grafana-dashboard/template/emqx-5/rule-engine-count.json
  datasource: Prometheus
emqx-rule-engine-rate:
  url: https://raw.githubusercontent.com/emqx/emqx-exporter/refs/heads/main/grafana-dashboard/template/emqx-5/rule-engine-rate.json
  datasource: Prometheus
```
