resource "proxmox_vm_qemu" "demo_node01" {
  target_node = "soc-pve-03"
  name = "ubuntu-pmx-01"
  desc = "Ubuntu Server Using Terraform Proxmox Provider"
  agent = 0

  clone = "debian12"
  cores = 1
  sockets = 1
  cpu = "host"
  memory = 2048

  network {
    bridge = "vmbr0"
    model = "virtio"
  }

  disk {
    storage = "HDD"
    type = "scsi"
    size = "15G"
  }

}