# Archived

- This folder contains operational but deprecated configs;
- authelia/lldap [ref](https://github.com/search?q=repo%3Amchestr%2Fhome-cluster%20OAUTH_CLIENT&type=code), homepage [ref](https://github.com/search?q=repo%3Amchestr%2Fhome-cluster+gethomepage&type=code);

## Reasons

> database

- prefer cnpg to cpgo;
- emqx is deprecated, like home-assistant;

> media

- downloaders pair with starrs;
- manyfold is primitive for `Bambu Lab` printers;

> monitoring

- apprise API too old to use;
- external healthchecks like `cronitor/uptimekuma` is not needed;

> networking

- cilium gateway-api support better than envoy-gateway;
- envoy-gateway-api too big for bootstrap helmfile;

> security

- internal network dont need extra auth;

> storage

- rook-ceph has better support than openebs-replicated;
- fstrim is not needed with `storageClass.mountOptions: -discard`;
