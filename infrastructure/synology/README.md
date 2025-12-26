## Synology DS1825+

- Docker compose supported by `Dockge`;

#### Dockge

- Below settings fix container redir bugs;
- WebPort = `9800/Expose`;
- HostNetwork = `true`;

### Garage

- set alias `garage` = `sudo docker exec -it garage /garage`;

```shell
garage status
garage layout assign -z main -c 200G "node-id"
garage layout apply --version 1

garage bucket create postgres
garage key import $access_key $secret_key -n postgres --yes
garage bucket allow --read --write postgres --key postgres
garage bucket info postgres

```
