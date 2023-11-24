resource "proxmox_vm_qemu" "demo_node01" {
  target_node = "soc-pve-03"
  name = "ubuntu-pmx-01"
  desc = "Ubuntu Server Using Terraform Proxmox Provider"

  agent = 0 // Enables QEMU guest agent

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

  # os_type = "cloud-init"
  # ipconfig0 = "ip=172.16.205.200/24,gw=172.16.205.1"
  # ciuser = "demoadmin"

  # sshkeys = <<EOF
  # ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDSLZHwVu5EiUD3PdWST1RmFiKtM3lWyF/NZi8UEdajiAmW4MR48CwnhQTd66V6KSLDIPxkn0B2yFC06brMIV2+TR3wCMcSpiE7lSRnOr68KP4wnzrdjBPOZxnMbddqPqK+sl6J9p/+uia4/YVk7PnqrRLYv0ewYFXS9runuOdsLoBs5t8GaVDhFkRarjjRwiDRP+2qoMXrgChXJEGqraafGQtZccGfpsQo3ryPlzS8/Fc9oEiruPoOCnv9DfnQm4HpviLPv7sMkdPmemW4R0ubzEyw9wb/MqRcidHvCciVC/e6DnpSHx0j9eHKp9TGBJfiJngRDHWoULCEezGBBUHx akshay@akshay-pc
  # EOF

}