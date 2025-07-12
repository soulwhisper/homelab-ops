## Cloudflare

### DNS-01

- Create a Cloudflare API Token with `ZONE:READ, DNS:EDIT`;

### Pages

> hosting Kubernetes CRD schemas with k8s-cronjobs integration

- Create a Cloudflare Pages Project, choose `Direct Upload`, name to `kubernetes-schemas`, deploy;
- Create a Cloudflare API Token with `Account:CloudflarePages:Edit`;
- Redirect your project link to your domain, like `kubernetes-schemas.noirprime.com`;

### Tunnel

> routing internal domains to Cloudflare network

- http/s based proxy has a negative impact on quic;
- create a local-managed tunnel, record credential json;

```shell
cloudflared tunnel login
cloudflared tunnel create --credentials-file cloudflare-tunnel.json kubernetes
```
