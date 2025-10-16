## Templates

- This is a template for most self-hosted apps without its own charts
- with substitute support, non-sensitive environments are set in configMap:cluster-settings;
- substitute can be disabled with `label: override.substitution.flux.home.arpa/disabled=true`;
- `kustomizeconfig.yaml` still needed for official helm charts with `values.yaml` during boostrap;
- "{{ .Release.Name }}" and "{{ .Release.Namespace }}" not always rendered, use yaml anchors instead;

```yaml
# ks.yaml
---
# yaml-language-server: $schema=https://kubernetes-schemas.noirprime.com/kustomize.toolkit.fluxcd.io/kustomization_v1.json
apiVersion: kustomize.toolkit.fluxcd.io/v1
kind: Kustomization
metadata:
  name: example-app-1
spec:
  interval: 1h
  path: "./kubernetes/apps/example-ns-1/example-app-1/app"
  prune: true
  sourceRef:
    kind: GitRepository
    name: gitops-system
    namespace: gitops-system
  wait: false
  dependsOn:
    - name: example-app-2
      namespace: example-ns-2

# helmrelease.yaml, since app-template-4.1.1
---
# yaml-language-server: $schema=https://kubernetes-schemas.noirprime.com/helm.toolkit.fluxcd.io/helmrelease_v2.json
apiVersion: helm.toolkit.fluxcd.io/v2
kind: HelmRelease
metadata:
  name: &name example-app
spec:
  interval: 1h
  chartRef:
    kind: OCIRepository
    name: app-template
    namespace: gitops-system

  values:
    defaultPodOptions:
      hostUsers: false                        # new way
      # securityContext:                      # old way
      #   runAsUser: 2000
      #   runAsGroup: 2000
      #   runAsNonRoot: true
      #   fsGroup: 2000                       # optional
      #   fsGroupChangePolicy: OnRootMismatch # optional
    controllers:
      example-app:
        annotations:
          reloader.stakater.com/auto: "true"
        serviceAccount: # can be ignored if only one serviceaccount
          identifier: *name
        initContainers:
          init-db:
            image:
              repository: ghcr.io/home-operations/postgres-init
              tag: "17"
            envFrom:
              - secretRef:
                  name: example-app-initdb
        containers:
          app:
            image:
              repository: path/to/repo
              tag: 1.0.0
            env:
              HTTP_PROXY: "${HTTP_PROXY}"
              HTTPS_PROXY: "${HTTPS_PROXY}"
              NO_PROXY: "${NO_PROXY}"
              DB_USERNAME:
                valueFrom:
                  secretKeyRef:
                    name: &pguser example-app-pguser
                    key: username
              DB_PASSWORD:
                valueFrom:
                  secretKeyRef:
                    name: *pguser
                    key: password
              DB_DATABASE_NAME:
                valueFrom:
                  secretKeyRef:
                    name: *pguser
                    key: db
              DB_HOSTNAME:
                valueFrom:
                  secretKeyRef:
                    name: *pguser
                    key: host
              DB_PORT:
                valueFrom:
                  secretKeyRef:
                    name: *pguser
                    key: port
            envFrom: &envFrom
              - configMapRef:
                  name: *name
              - secretRef:
                  name: *name
            ports:
              - name: http
                containerPort: &port 8080
            resources:
              requests:
                cpu: 15m
              limits:
                memory: 512Mi
            securityContext:
              allowPrivilegeEscalation: false
              capabilities: { drop: ["ALL"] }
              readOnlyRootFilesystem: true

    service:
      app:
        controller: *name     # can be ignored if only one controller
        ports:
          http:
            primary: true     # can be ignored if only one port
            port: *port
          metrics:
            port: *metricsPort
        primary: true         # can be ignored if only one service, only one primary
    serviceMonitor:
      app:
        serviceName: *name    # can be ignored if only one service
        endpoints:
          - port: metrics
    route:
      app:
        hostnames:
          - sub.example.com
        parentRefs:
          - name: internal
            namespace: kube-system
            sectionName: https
        rules:                 # can be ignored if only one service
          - backendRefs:
              - identifier: app
                port: *port

    serviceAccount:
      example-app: {}
    persistence:
      app:
        existingClaim: *name
        globalMounts:
          - path: /app/data
            subPath: data     # can be ignored if only one path
      tmpfs:
        type: emptyDir
        globalMounts:
          - path: /tmp
            subPath: tmp      # can be ignored if only one path
      media:
        type: nfs
        server: nas.homelab.internal
        path: /mnt/Arcanum/Media
        advancedMounts:
          example-app:
            app:
              - path: /data
                subPath: data

```
