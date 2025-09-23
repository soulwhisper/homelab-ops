set quiet := true
set shell := ['bash', '-euo', 'pipefail', '-c']

mod infra ".justfiles/infra"
mod k8s ".justfiles/k8s"
mod talos ".justfiles/talos"

export OPS_DIR := invocation_directory()
export K8S_DIR := OPS_DIR / "kubernetes"
export TALOS_DIR:= OPS_DIR / "infrastructure/talos"

# KUBECONFIG := OPS_DIR / "infrastructure/talos/clusterconfig/kubeconfig"
# TALOSCONFIG := OPS_DIR / "infrastructure/talos/clusterconfig/talosconfig"

minijinja_args := '--autoescape none --env --lstrip-blocks --trim-blocks'

[private]
default:
  just --list

[doc('Restore configuration files from backup location')]
env:
  cp ~/.kube/config "$KUBECONFIG"
  cp ~/.talos/config "$TALOSCONFIG"
  direnv allow
  @echo "K8S environment restored."

[doc('Force Flux to pull in changes from your Git repository')]
reconcile:
  flux --namespace gitops-system reconcile kustomization gitops-system --with-source

[doc('Bootstrap Cluster')]
bootstrap:
  @echo "Bootstrapping Talos..."
  just talos _bootstrap_talos
  @echo "completed."
  @echo "Bootstrapping K8s..."
  just talos _bootstrap_k8s
  just talos kubeconfig
  @echo "completed."
  @if ! kubectl wait nodes --for=condition=Ready=True --all --timeout=10s &>/dev/null; then \
    until kubectl wait nodes --for=condition=Ready=False --all --timeout=10s &>/dev/null; do \
      echo "Nodes not available, waiting for nodes to be available. Retrying in 5 seconds..."; \
      sleep 5; \
    done \
  fi
  @echo "Bootstrapping Apps..."
  just _bootstrap_apps
  @echo "completed."
  @echo "Cluster bootstrapped. Rebooting nodes..."
  talosctl reboot
  @echo "completed."

_template file:
  minijinja-cli {{file}} {{minijinja_args}} | op inject

_bootstrap_apps:
  just _template "{{K8S_DIR}}/bootstrap/resources.yaml.j2" | kubectl apply --server-side -f -
  helmfile --file "{{K8S_DIR}}/bootstrap/helmfile.yaml" sync --hide-notes
