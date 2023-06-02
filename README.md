# Packer workshop

## Goal

Learn how to build custom images via code in packer.

## About Packer

Packer is an IaC(Infrastructure as code) utility from hashicorp which allows us to build custom images
via code and not manually.
The advantages using packer are:

- Documentation - Unlike in manual setup where there is no documentation and things can get lost, with packer our code is the documentation!
- Review - Because it's a code someone can review our code before deploying.
- Versioning - Just like other code like python we can version packer code and.

## How does Packer works?

Packer is build from two main components:
    - Builder - The infrastructure on which the image will be built.
    - Provisioner - Configures the image like installing packages. shell provisioner is one of the most popular provisioners.

The build process is composed of two stages:

1. The builder boots a vm with a given image. At this stage we can inject boot commands to let the vm use a proprietary config mechanism.
2. After boot is done, packer executes the provisioners. In the shell provisioner case, packer will wait until there is a connection to the vm.

**Note:** This workshop utilizes qemu for building images but it can be build on other infrastructures like aws, gcp, digital ocean, etc.

## Setup

1. Install packer from [here](https://www.packer.io/downloads).
2. Install qemu from [here](https://www.qemu.org/download/).

## Build an image

In each directory there is a README.md which explains how to build the image.
