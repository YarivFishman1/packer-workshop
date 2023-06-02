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

source "qemu" "custom_debian11_image" {
    vm_name     = "${var.vm_name}"

    # /home/yariv/Downloads/VMware-VMvisor-Installer-201704001-5310538.x86_64.iso
    iso_url      = "${var.iso_url}"
    iso_checksum = "${var.iso_checksum}"

    # Location of configuration file(custom.cfg).
    # Will be served via an HTTP Server from Packer
    http_directory = "http"

    boot_command = [
        "<esc><wait><wait><wait><wait>",
        "auto preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed-debian11.cfg ",
        "debian-installer=en_US.UTF-8 locale=en_US keymap=us ",
        "netcfg/get_hostname={{ .Name }} ",
        "fb=false debconf/frontend=noninteractive ",
        "passwd/user-fullname={{user `username`}} ",
        "passwd/user-password={{user `password`}} ",
        "passwd/user-password-again={{user `password`}} ",
        "passwd/username={{user `username`}} ",
        "<enter>"
    ]

    boot_wait = "2s"

    # QEMU specific configuration
    cpus             = 4
    memory           = 4096
    accelerator      = "kvm"
    disk_size        = "30G"

    # Final Image will be available in `output/packerubuntu-*/`
    output_directory = "${var.output_dir}"

    # SSH configuration so that Packer can log into the Image
    ssh_username     = "root"
    ssh_password     = "toor"
    ssh_timeout      = "20m"
    shutdown_command = "poweroff; while true; do sleep 10; done;"
    headless         = false # Opens a qemu window and watch the magic happens. In CI headless should be false.
}

build {
    name    = "config debian 11"
    sources = [ "source.qemu.custom_debian11_image" ]

    provisioner "shell" {
        script = "${var.shell_script}"
    }
}
