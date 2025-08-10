<div align="center">

<img src="https://github.com/soulwhisper/homelab-ops/blob/main/docs/_assets/logo.jpg?raw=true" width="144px" height="144px"/>

### <img src="https://fonts.gstatic.com/s/e/notoemoji/latest/1f680/512.gif" alt="🚀" width="16" height="16"> My Homelab Operations repository <img src="https://fonts.gstatic.com/s/e/notoemoji/latest/1f6a7/512.gif" alt="🚧" width="16" height="16">

_... managed by Flux, Renovate and GitHub Actions_ <img src="https://fonts.gstatic.com/s/e/notoemoji/latest/1f916/512.gif" alt="🤖" width="16" height="16">

[![Discord](https://img.shields.io/discord/673534664354430999?style=for-the-badge&label&logo=discord&logoColor=white&color=blue)](https://discord.gg/homelab-operations)

[![Talos](https://img.shields.io/endpoint?url=https%3A%2F%2Fkromgo.noirprime.com%2Ftalos_version&style=for-the-badge&logo=talos&logoColor=white&color=blue&label=talos)](https://talos.dev)&nbsp;
[![Kubernetes](https://img.shields.io/endpoint?url=https%3A%2F%2Fkromgo.noirprime.com%2Fkubernetes_version&style=for-the-badge&logo=kubernetes&logoColor=white&color=blue&label=k8s)](https://kubernetes.io)&nbsp;&nbsp;
[![Flux](https://img.shields.io/endpoint?url=https%3A%2F%2Fkromgo.noirprime.com%2Fflux_version&style=for-the-badge&logo=flux&logoColor=white&color=blue&label=flux)](https://fluxcd.io)&nbsp;&nbsp;
![Status](https://img.shields.io/website?url=https%3A%2F%2Fstatus.noirprime.com&up_message=UP&up_color=white&down_message=DOWN&down_color=red&style=for-the-badge&logo=statuspal&logoColor=white&label=STATUS&color=blue)

[![Age](https://img.shields.io/endpoint?url=https%3A%2F%2Fkromgo.noirprime.com%2Fcluster_age_days&style=flat-square&label=Age&color=green)](https://github.com/kashalls/kromgo)&nbsp;
[![Node](https://img.shields.io/endpoint?url=https%3A%2F%2Fkromgo.noirprime.com%2Fcluster_node_count&style=flat-square&label=Nodes&color=green)](https://github.com/kashalls/kromgo)&nbsp;
[![Pod](https://img.shields.io/endpoint?url=https%3A%2F%2Fkromgo.noirprime.com%2Fcluster_pod_count&style=flat-square&label=Pods&color=green)](https://github.com/kashalls/kromgo)&nbsp;
[![CPU](https://img.shields.io/endpoint?url=https%3A%2F%2Fkromgo.noirprime.com%2Fcluster_cpu_usage&style=flat-square&label=CPU&color=green)](https://github.com/kashalls/kromgo)&nbsp;
[![Memory](https://img.shields.io/endpoint?url=https%3A%2F%2Fkromgo.noirprime.com%2Fcluster_memory_usage&style=flat-square&label=Memory&color=green)](https://github.com/kashalls/kromgo)&nbsp;
[![Alerts](https://img.shields.io/endpoint?url=https%3A%2F%2Fkromgo.noirprime.com%2Fcluster_alert_count&style=flat-square&label=Alerts&color=green)](https://github.com/kashalls/kromgo)

</div>

---

## <img src="https://fonts.gstatic.com/s/e/notoemoji/latest/1f4a1/512.gif" alt="💡" width="20" height="20"> Overview

This repository serves as a monorepository for the infrastructure and Kubernetes cluster powering my homelab. The project embraces **Infrastructure as Code (IaC)** and **GitOps** principles to ensure declarative, repeatable, and version-controlled infrastructure management. Leveraging tools such as [Ansible](https://www.ansible.com/), [Terraform](https://www.terraform.io/), [Kubernetes](https://kubernetes.io/), [Flux](https://github.com/fluxcd/flux2), [NixOS](https://nixos.org/), [Renovate](https://github.com/renovatebot/renovate), [Talos](https://www.talos.dev) and [GitHub Actions](https://github.com/features/actions), this repository is structured to maximize automation, consistency, and maintainability. All configurations are declared as code, promoting reproducibility and enabling seamless updates and scaling of my homelab environment.

---

{{#include ./infrastructure/kubernetes.md}}

---

{{#include ./infrastructure/networking.md}}

---

{{#include ./infrastructure/hardware.md}}
