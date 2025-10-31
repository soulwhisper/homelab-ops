## Service Topology

```mermaid
graph TD
  Router -->|WAN| PPPoE
  Switch -->|LAN Trunk VLAN 100,200,210| Router
  Switch -->|MGMT Access VLAN 1| Router
  subgraph Internal Network
	MGMT -->|Access Port VLAN 1| Switch
	LAB -->|Access Port VLAN 100| Switch
	WIFI -->|Trunk Port VLAN 200| Switch
	IOT -->|Trunk Port VLAN 210| Switch
	K8S -->|iBGP 65510| LAB
  end
```

### Components

- Router / Firewall / DHCP / DNS / NTP / TProxy : `OpenWRT`;
- NAS / Infrastructure Services : `QNAP Qu805`;
- Gateway / DHCP Relay / iBGP / OSPF: `H3C L3 Core Switch`;
- Computing / Other Services : `Talos MS-01`;

### Notes

- All LACP devices using `layer 3+4` for better compatibility;
- Enable jumbo frame for `K8S`, `NAS`, `Router`;
