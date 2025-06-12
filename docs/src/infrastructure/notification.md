## Notification

### Hub

- choose `apprise` as notification-hub, [ref](https://hub.docker.com/r/caronc/apprise);
- app -> hub -> platforms;
- via webhook: `http://hostname:8000/notify`
- to severchan: `schan://sendkey/`

### Method

> Pushover

- Old-fashioned way, widely used. Realtime alerts might need proxy (for me).

> Serverchan

- via webhook, [ref](https://sct.ftqq.com/); free-tier is enough; dont need proxy;
- if work, prefer `sct_appkey`, dont need another app, push to work_channel;
- if home, prefer `sc3_appkey`, dont need app running, push to status_bar;
- support markdown message;

### Implementation

> Pushover

```yaml
# alertmanager
## via env:PUSHOVER_TOKEN, env:PUSHOVER_USER_KEY
config:
  receivers:
    - name: pushover
      pushover_configs:
        - send_resolved: true
          priority: |-
            {{ if eq .Status "firing" }}1{{ else }}0{{ end }}
          title: >-
            [{{ .Status | toUpper }}{{ if eq .Status "firing" }}:{{ .Alerts.Firing | len }}{{ end }}]
            {{ .CommonLabels.alertname }}
          message: |-
            {{- range .Alerts }}
              {{- if ne .Annotations.description "" }}
                {{ .Annotations.description }}
              {{- else if ne .Annotations.summary "" }}
                {{ .Annotations.summary }}
              {{- else if ne .Annotations.message "" }}
                {{ .Annotations.message }}
              {{- else }}
                Alert description not available
              {{- end }}
              {{- if gt (len .Labels.SortedPairs) 0 }}
                <small>
                  {{- range .Labels.SortedPairs }}
                    <b>{{ .Name }}:</b> {{ .Value }}
                  {{- end }}
                </small>
              {{- end }}
            {{- end }}
          sound: gamelan
          ttl: 86400s
          token:
            name: *name
            key: PUSHOVER_TOKEN
          user_key:
            name: *name
            key: PUSHOVER_USER_KEY

# gatus
## via env:PUSHOVER_TOKEN, env:PUSHOVER_USER_KEY
endpoints:
  - name: example
    alerts:
      - type: pushover

```

> Serverchan

```yaml
# alertmanager
## via env:SERVERCHAN_URL
config:
  receivers:
    - name: serverchan
      webhook_configs:
        - send_resolved: true
          url:
            name: *name
            key: SERVERCHAN_URL

# gatus
## via env:SERVERCHAN_URL
alerting:
  custom:
    url: "${SERVERCHAN_URL}"
    method: "POST"
    body: |
      {
        "text": "[ALERT_TRIGGERED_OR_RESOLVED]: [ENDPOINT_GROUP] - [ENDPOINT_NAME] - [ALERT_DESCRIPTION] - [RESULT_ERRORS]"
      }
    placeholders:
      ALERT_TRIGGERED_OR_RESOLVED:
        TRIGGERED: "FAILURE"
        RESOLVED: "RECOVERED"

endpoints:
  - name: example
    alerts:
      - type: custom
```
