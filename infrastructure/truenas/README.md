## TrueNAS Scale

- Docker compose supported by `Apps:Dockge`;

### Apps

- Pool = `Arcanum`;
- Address Pools = `192.168.0.0/16`, `Size 24`;
- Registry Mirrors = `https://mirror.gcr.io`;

#### Dockge

- Below settings fix container redir bugs;
- WebPort = `9800/Expose`;
- HostNetwork = `true`;
