## Service Topology

```mermaid
graph TD
  Router -->|WAN| PPPoE
  K8S -->|eBGP| LAB
  NAS --> LAB
  subgraph Physical Network
	Workstation -->|Access Port VLAN 1| AccessSwitch
	LAN -->|Access Port VLAN 10| AccessSwitch
	WIFI -->|Trunk Port VLAN 200| AccessSwitch
	IOT -->|Trunk Port VLAN 210| AccessSwitch
    WAN -->|Access Port VLAN 1000| AccessSwitch
	LAB -->|Access Port VLAN 100| CoreSwitch
	AccessSwitch -->|Trunk Port VLAN 1,10,200,210,1000| CoreSwitch
	CoreSwitch -->|Trunk Port VLAN 10,100,200,210,1000| Router
  end
  subgraph Management Network
	CoreSwitch -->|Access Port VLAN 1| MgmtSwitch
	Router -->|VLAN 1| MgmtSwitch
	K8S -->|VLAN 1| MgmtSwitch
	NAS -->|VLAN 1| MgmtSwitch
  end
```

### Components

- Router / Firewall / DHCP / DNS / NTP / TProxy : `OpenWRT`;
- NAS / Infrastructure Services : `TrueNAS Scale`;
- Gateway / DHCP Relay / iBGP / OSPF: `H3C L3 Core Switch`;
- Computing / Other Services : `Talos MS-01`;

### Notes

- All LACP devices using `layer 3+4` for better compatibility;
- Enable jumbo frame for `K8S`, `NAS`, `Router`;
