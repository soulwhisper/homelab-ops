## <img src="https://fonts.gstatic.com/s/e/notoemoji/latest/1f308/512.gif" alt="🌈" width="20" height="20"> Networking

The homelab network is anchored by a datacenter-grade access switch, primarily operating in Layer 2 mode with BGP for routing. Outside the cluster, a dedicated industrial PC configured with [nix-config](https://github.com/soulwhisper/nix-config/tree/main/hosts/nix-infra) provides essential Kubernetes infrastructure services, including NTP, external-dns, HTTP proxy, and discovery services.

While most of my infrastructure and workloads are self-hosted I do rely upon the cloud for certain key parts of my setup. This saves me from having to worry about three things. (1) Dealing with chicken/egg scenarios, (2) services I critically need whether my cluster is online or not and (3) The "hit by a bus factor" - what happens to critical apps (e.g. Email, Password Manager, Photos) that my family relies on when I no longer around.

Alternative solutions to the first two of these problems would be to host a Kubernetes cluster in the cloud and deploy applications like [HCVault](https://www.vaultproject.io/), [Vaultwarden](https://github.com/dani-garcia/vaultwarden), [ntfy](https://ntfy.sh/), and [Gatus](https://gatus.io/); however, maintaining another cluster and monitoring another group of workloads would be more work and probably be more or equal out to the same costs as described below.

| Service                                   | Use                                                            | Cost          |
| ----------------------------------------- | -------------------------------------------------------------- | ------------- |
| [1Password](https://1password.com/)       | Secrets with [External Secrets](https://external-secrets.io/)  | ~$36/yr       |
| [Cloudflare](https://www.cloudflare.com/) | Domain and S3                                                  | Free          |
| [GitHub](https://github.com/)             | Hosting this repository and continuous integration/deployments | Free          |
|                                           |                                                                | Total: ~$3/mo |
