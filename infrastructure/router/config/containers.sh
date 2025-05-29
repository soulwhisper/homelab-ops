#!/bin/vbash

# container network
set container network containers prefix 192.168.10.0/24

# talos-api
set container name talos-api image 'ghcr.io/siderolabs/discovery-service:latest'
set container name talos-api network containers
set container name talos-api port http source 9200
set container name talos-api port http destination 3000
set container name talos-api port http protocol tcp

# http-proxy
set container name http-proxy image 'docker.io/metacubex/mihomo:Alpha'
set container name http-proxy network containers
set container name http-proxy port http source 1080
set container name http-proxy port http destination 1080
set container name http-proxy port http protocol tcp
set container name http-proxy port http source 9201
set container name http-proxy port http destination 9201
set container name http-proxy port http protocol tcp
set container name http-proxy volume config source '/config/containers/http-proxy/config.yaml'
set container name http-proxy volume config destination '/root/.config/mihomo/config.yaml'
set container name http-proxy volume config mode 'rw'
set container name http-proxy volume ui source '/config/containers/http-proxy/ui'
set container name http-proxy volume ui destination '/root/.config/mihomo/ui'
set container name http-proxy volume ui mode 'ro'
