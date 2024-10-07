<div align="center">

<img src="https://github.com/soulwhisper/home-ops/blob/main/_assets/logo.jpg?raw=true" width="144px" height="144px"/>

## My Home Operations repository

_... managed by Flux, Renovate and GitHub Actions_ :robot:

[![Renovate](https://img.shields.io/github/actions/workflow/status/soulwhisper/.github/schedule-renovate.yaml?branch=main&label=&logo=renovatebot&style=for-the-badge&color=blue)](https://github.com/soulwhisper/home-ops/actions/workflows/schedule-renovate.yaml)

Main k8s cluster stats:

[![Kubernetes](https://img.shields.io/badge/dynamic/yaml?url=https%3A%2F%2Fraw.githubusercontent.com%2Fsoulwhisper%2Fhome-ops%2Fmain%2Fkubernetes%2Fmain%2Fbootstrap%2Ftalos%2Ftalconfig.yaml&query=%24.kubernetesVersion&flat-square&logo=kubernetes&logoColor=white&label=k8s)
](https://www.talos.dev/)&nbsp;
[![Talos](https://img.shields.io/badge/dynamic/yaml?url=https%3A%2F%2Fraw.githubusercontent.com%2Fsoulwhisper%2Fhome-ops%2Fmain%2Fkubernetes%2Fmain%2Fbootstrap%2Ftalos%2Ftalconfig.yaml&query=%24.talosVersion&flat-square&logo=kubernetes&logoColor=white&color=orange&label=talos)
](https://www.talos.dev/)&nbsp;
[![Age-Days](https://kromgo.noirprime.com/cluster_age_days?format=badge)](https://github.com/kashalls/kromgo/)&nbsp;
[![Node-Count](https://kromgo.noirprime.com/cluster_node_count?format=badge)](https://github.com/kashalls/kromgo/)&nbsp;
[![Pod-Count](https://kromgo.noirprime.com/cluster_pod_count?format=badge)](https://github.com/kashalls/kromgo/)&nbsp;
[![CPU-Usage](https://kromgo.noirprime.com/cluster_cpu_usage?format=badge)](https://github.com/kashalls/kromgo/)&nbsp;
[![Memory-Usage](https://kromgo.noirprime.com/cluster_memory_usage?format=badge)](https://github.com/kashalls/kromgo/)&nbsp;

</div>
<br><br>

👋 Welcome to my Home Operations repository. This is a mono repository for my home infrastructure and Kubernetes cluster. I try to adhere to Infrastructure as Code (IaC) and GitOps practices using the tools like [Kubernetes](https://kubernetes.io/), [Flux](https://github.com/fluxcd/flux2), [Renovate](https://github.com/renovatebot/renovate) and [GitHub Actions](https://github.com/features/actions). Inspired by [bjw-s/home-ops](https://github.com/bjw-s/home-ops).

---

### 📖 Docs

The documentation that goes along with this repo can be found [over here]().

---

### :handshake: Thanks

Thanks to all the people who donate their time to the [Kubernetes @Home](https://discord.gg/k8s-at-home) Discord community. A lot of inspiration for my cluster comes from the people that have shared their clusters using the [k8s-at-home](https://github.com/topics/k8s-at-home) GitHub topic. Be sure to check out the [Kubernetes @Home search](https://nanne.dev/k8s-at-home-search/) for ideas on how to deploy applications or get ideas on what you can deploy.

---

### 🔏 License

See [LICENSE](https://github.com/soulwhisper/home-ops/blob/main/LICENSE)
