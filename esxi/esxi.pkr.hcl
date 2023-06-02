variable "vm_name" {
    type = string
    default = "custom-esxi"
}

variable "iso_url" {
    type = string
}

variable "iso_checksum" {
    type = string
}

variable "output_dir" {
    type = string
    default = "output"
}

variable "shell_script" {
    type = string
    default = "setup.sh"
}

source "qemu" "custom_esxi_image" {
    vm_name     = "${var.vm_name}"

    # /home/yariv/Downloads/VMware-VMvisor-Installer-201704001-5310538.x86_64.iso
    iso_url      = "${var.iso_url}"
    iso_checksum = "${var.iso_checksum}"

    # Location of configuration file(custom.cfg).
    # Will be served via an HTTP Server from Packer
    http_directory = "http"

    boot_command = [
        "<enter><wait>",
        "<leftShift>O",
        "<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs>",
        "ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/custom.cfg",
        "<enter>",
    ]

    boot_wait = "2s"

    # QEMU specific configuration
    cpu_model        = "host"
    cpus             = 4
    memory           = 4096
    accelerator      = "kvm"
    disk_size        = "30G"
    disk_compression = true
    disk_interface   = "ide"
    net_device       = "vmxnet3"
    net_bridge       = "virbr0"

    # Final Image will be available in `output/packerubuntu-*/`
    output_directory = "${var.output_dir}"

    # SSH configuration so that Packer can log into the Image
    ssh_username     = "root"
    ssh_password     = "VMware1!" # We set the password in custom.cfg
    ssh_timeout      = "20m"
    shutdown_command = "poweroff; while true; do sleep 10; done;"
    headless         = false # Opens a qemu window and watch the magic happens. In CI headless should be false.
}

build {
    name    = "config esxi"
    sources = [ "source.qemu.custom_esxi_image" ]

    provisioner "shell" {
        script = "${var.shell_script}"
    }
}
