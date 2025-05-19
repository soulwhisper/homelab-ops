# Templates

- This is a template for most self-hosted apps without its own charts

```yaml
---
# yaml-language-server: $schema=https://raw.githubusercontent.com/bjw-s-labs/helm-charts/main/charts/other/app-template/schemas/helmrelease-helm-v2.schema.json
apiVersion: helm.toolkit.fluxcd.io/v2
kind: HelmRelease
metadata:
  name: example-app
spec:
  interval: 30m
  chartRef:
    kind: OCIRepository
    name: app-template
    namespace: gitops-system
  install:
    crds: CreateReplace
    remediation:
      retries: -1
  upgrade:
    cleanupOnFail: true
    crds: CreateReplace
    remediation:
      retries: 3

  values:
    defaultPodOptions:
      # hostUsers: false   # if root, most self-hosted apps
      securityContext:     # if non-root, most media-apps
        runAsUser: 2000
        runAsGroup: 2000
        runAsNonRoot: true
        fsGroup: 2000
        fsGroupChangePolicy: OnRootMismatch

    controllers:
      example-app:
        annotations:
          reloader.stakater.com/auto: "true"
        containers:
          app:
            image:
              repository: path/to/repo
              tag: 1.0.0
            env:
              TZ: Asia/Shanghai
            securityContext:
              allowPrivilegeEscalation: false
              capabilities:
                drop:
                  - ALL
              seccompProfile:
                type: RuntimeDefault
            resources:
              requests:
                cpu: 15m
                memory: 128Mi
              limits:
                memory: 512Mi

    service:
      app:
        controller: &app example-app
        ports:
          http:
            port: &port 8080
    route:
      app:
        hostnames:
          - sub.example.com
        parentRefs:
          - name: internal
            namespace: kube-system
            sectionName: http
        rules:
          - backendRefs:
              - name: *app
                port: *port

    persistence:
      app:
        existingClaim: example-app
        globalMounts:
          - path: /app/data
            subPath: data
      tmp:
        type: emptyDir
        globalMounts:
          - path: /tmp
            subPath: tmp
      media:
        type: nfs
        server: nas.homelab.internal
        path: /mnt/Arcanum/shared/media
        advancedMounts:
          auto-bangumi:
            app:
              - path: /data
                subPath: data

```
