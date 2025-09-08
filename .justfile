#!/usr/bin/env -S just --justfile

set quiet := true
set shell := ['bash', '-euo', 'pipefail', '-c']

mod bootstrap ".justfiles/bootstrap"
mod flux ".justfiles/bootstrap"
mod infra ".justfiles/infra"
mod k8s ".justfiles/k8s"
mod talos ".justfiles/talos"
mod volsync ".justfiles/volsync"

export ROOT_DIR := invocation_directory()
export K8S_DIR := ROOT_DIR / "kubernetes"
export TALOS_DIR:= ROOT_DIR / "infrastructure/talos"
export KUBECONFIG := TALOS_DIR / "clusterconfig/kubeconfig"
export TALOSCONFIG := TALOS_DIR / "clusterconfig/talosconfig"

minijinja_args := '--autoescape none --env --lstrip-blocks --trim-blocks'

[private]
default:
  just --list

[doc('Restore configuration files from backup location')]
env:
  cp ~/.kube/config {{ KUBECONFIG }}
  cp ~/.talos/config {{ TALOSCONFIG }}
  direnv allow
  just log INFO "K8S environment restored."

[doc('Force Flux to pull in changes from your Git repository')]
reconcile:
  flux --namespace gitops-system reconcile kustomization gitops-system --with-source

[doc('Force Flux to flush ks in all namespaces')]
flush:
  just flux suspend-ks-all
  just flux resume-ks-all
