## <img src="https://fonts.gstatic.com/s/e/notoemoji/latest/1f308/512.gif" alt="🌈" width="20" height="20"> Networking

The homelab network is anchored by a datacenter-grade access switch, primarily operating in Layer 2 mode with BGP for routing. Outside the cluster, a dedicated industrial PC configured with [nix-config](https://github.com/soulwhisper/nix-config/tree/main/hosts/nix-infra) provides essential Kubernetes infrastructure services, including NTP, external-dns, HTTP proxy, and discovery services.

While the majority of my infrastructure and workloads are self-hosted, I rely on the cloud for certain critical components of my setup, as this approach is essential for mitigating several key risks. By offloading these applications to the cloud, I significantly reduce the complexity of maintenance. Specifically, this approach addresses three critical concerns: (1) avoiding chicken-and-egg scenarios, (2) ensuring the availability of mission-critical services regardless of the status of my Kubernetes cluster, and (3) addressing the "hit by a bus" factor—ensuring that vital applications such as email, password managers, and photo storage remain accessible and functional even in the event of an unexpected absence.

While one could theoretically resolve the first two issues by hosting a Kubernetes cluster in the cloud and deploying critical services like [HCVault](https://www.vaultproject.io/), [Keycloak](https://www.keycloak.org/), and [Ntfy](https://ntfy.sh/). The practicality of maintaining another cluster and monitoring a separate set of workloads would incur additional overhead. Moreover, the effort and cost of managing a cloud-based Kubernetes cluster would likely equate to, if not exceed, the savings gained from delegating these responsibilities to the cloud, as described below.

| Service                                   | Use                                                            | Cost          |
| ----------------------------------------- | -------------------------------------------------------------- | ------------- |
| [1Password](https://1password.com/)       | Secrets with [External Secrets](https://external-secrets.io/)  | ~$36/yr       |
| [Cloudflare](https://www.cloudflare.com/)   | Domain, S3 and ZeroTrust                                       | Free          |
| [GitHub](https://github.com/)             | Hosting this repository and continuous integration/deployments | Free          |
| [Pushover](https://pushover.net/)         | Notify app                                                     | One-time $5   |
|                                           |                                                                | Total: ~$3/mo |
