## Slack app for alertmanager

```shell
# alertmanager
    alertmanager:
      config:
        receivers:
          - name: "null"
          - name: "default-receiver"
            slack_configs:
              - send_resolved: true
                # https://api.slack.com/messaging/webhooks
                api_url:
                  name: *name
                  key: SLACK_URL
                channel:
                  name: *name
                  key: SLACK_CHANNEL
```
