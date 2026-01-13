## Service Topology

```mermaid
graph TD
  UCG-Fiber -->|WAN| PPPoE
  subgraph HOME
	Workstation -->|VLAN 1| AccessSwitch
	LAN -->|VLAN 10| AccessSwitch
	WIFI -->|VLAN 200| AccessSwitch
	IOT -->|VLAN 210| AccessSwitch
	AccessSwitch -->|VLAN 1,10,200,210| UCG-Fiber
  end
  subgraph LAB
    Workstation -->|VLAN 100| CoreSwitch
    NAS -->|VLAN 100| CoreSwitch
    K8S -->|VLAN 100| CoreSwitch
    CoreSwitch -->|VLAN 100| UCG-Fiber
  end
  subgraph Management
	UCG-Fiber -->|VLAN 1| MgmtSwitch
	CoreSwitch -->|VLAN 1| MgmtSwitch
	K8S -->|VLAN 1| MgmtSwitch
	NAS -->|VLAN 1| MgmtSwitch
  end
```

### Components

- Router / Firewall / DHCP / NTP : `UCG-Fiber`;
- DNS / TProxy : `OpenWRT@Synology`;
- NAS / Infrastructure Services : `Synology DS1825+`;
- EBGP / OSPF : `H3C S6520-24S-SI`;
- Computing : `MS-01`;

### Notes

- All LACP devices using `layer 3+4` for better compatibility;
- Enable jumbo frame for `K8S`, `NAS`, `Router`;
