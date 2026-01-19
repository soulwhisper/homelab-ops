## DNS

- cloudflare action examples, check [ref](https://github.com/SukkaW/dnscontrol-gitops-template/tree/master);

```shell
brew install dnscontrol
dnscontrol [command]

docker run --rm -it -v "$(pwd):/dns" ghcr.io/stackexchange/dnscontrol [command]

pnpm install
pnpm run lint

dnscontrol write-types

dnscontrol check
dnscontrol preview
dnscontrol push
```
