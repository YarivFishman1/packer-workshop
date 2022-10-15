# Packer workshop
## Goal
Learn how to build a custom debian image via packer from a clean debian 11 base image.

**Note:** This workshop builds the image via qemu but it can be build on other platforms like aws, gcp, digital ocean, etc.

## Setup
1. Install packer from [here](https://www.packer.io/downloads).
2. Install qemu from [here](https://www.qemu.org/download/).

## Build an image
```bash
$ packer build debian11.json
```
**Note:** The final image will be under `output/` directory.

## How packer works?(in a nutshell)
Packer has two key components:
- Builder - Runs a vm with the base image.
- Provisioner - Modifies the running machine. The most common provisioner is shell which executes arbitrary commands on the running machine.

**Note:** In our case the builder is qemu and we have the shell provisioner.

Building Steps:
* Qemu launchs a vm with the image.
* After boot, the shell provisioner will try to connect via ssh to machine.
Because I use a clean debian image, I need to do basic configuration and setup a ssh server. To do this I use a preseed configuration file(learn more [here](https://wiki.debian.org/DebianInstaller/Preseed)), which lets me to config things
like: time, keyboard, accounts and install packages like ssh-server.
* After the installation the machine will reboot and the shell provisioner will be able to connect the machine, upload our script and execute it.
* After the script execution, qemu will shutdown the machine and write the new image into disk.
