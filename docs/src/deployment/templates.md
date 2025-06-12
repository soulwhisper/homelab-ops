## Templates

- This is a template for most self-hosted apps without its own charts
- with substitute support, non-sensitive but repeative environments are set in configMap:cluster-settings;
- sensitive environments could be set using `label: override.substitution.flux.home.arpa/enabled=true` and `substituteFrom` secrets;

```yaml
# ks.yaml
---
# yaml-language-server: $schema=https://kubernetes-schemas.noirprime.com/kustomize.toolkit.fluxcd.io/kustomization_v1.json
apiVersion: kustomize.toolkit.fluxcd.io/v1
kind: Kustomization
metadata:
  name: &appname example-app-1
  namespace: &namespace example-ns-1
  labels:
    override.substitution.flux.home.arpa/enabled: "true"
spec:
  targetNamespace: *namespace
  commonMetadata:
    labels:
      app.kubernetes.io/name: *appname
  interval: 30m
  timeout: 5m
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
  postBuild:
    substituteFrom:
      - kind: ConfigMap
        name: cluster-settings
      - kind: Secret
        name: example-app-2

# helmrelease.yaml
---
# yaml-language-server: $schema=https://kubernetes-schemas.noirprime.com/helm.toolkit.fluxcd.io/helmrelease_v2.json
apiVersion: helm.toolkit.fluxcd.io/v2
kind: HelmRelease
metadata:
  name: &name example-app
spec:
  interval: 30m
  chartRef:
    kind: OCIRepository
    name: app-template
    namespace: gitops-system
  maxHistory: 2
  install:
    crds: CreateReplace
    remediation:
      retries: -1
  upgrade:
    cleanupOnFail: true
    crds: CreateReplace
    remediation:
      retries: 3
  uninstall:
    keepHistory: false

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
        serviceAccount: # if only one defined, can be ignored
          identifier: example-app

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
              TZ: "${TIMEZONE}"
              HTTP_PROXY: "${HTTP_PROXY}"
              HTTPS_PROXY: "${HTTPS_PROXY}"
              NO_PROXY: "${NO_PROXY}"
              DB_USERNAME:
                valueFrom:
                  secretKeyRef:
                    name: &pguser example-app-pguser
                    key: user
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
            envFrom:
              - configMapRef:
                  name: *name
              - secretRef:
                  name: *name
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
        controller: *name
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
            sectionName: https
        rules:
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
            subPath: data
      tmpfs:
        type: emptyDir
        globalMounts:
          - path: /tmp
            subPath: tmp
      media:
        type: nfs
        server: nas.homelab.internal
        path: /mnt/Arcanum/shared/media
        advancedMounts:
          example-app:
            app:
              - path: /data
                subPath: data

```
