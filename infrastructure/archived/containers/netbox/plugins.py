# This is a custom configuration file for NetBox plugins.
# Ref:https://github.com/netbox-community/netbox-docker/blob/release/configuration/plugins.py

PLUGINS = [
  "netbox_attachments",
  "netbox_bgp",
  "netbox_dns",
  "netbox_floorplan",
  "netbox_interface_synchronization",
  # "netbox-napalm-plugin",
  "netbox_prometheus_sd",
  "netbox_qrcode",
  "netbox_reorder_rack",
  "netbox_topology_views"
]
# PLUGINS_CONFIG = {
#   "netbox_napalm_plugin": {
#      "NAPALM_USERNAME": "xxx",
#      "NAPALM_PASSWORD": "yyy",
#   },
# }
