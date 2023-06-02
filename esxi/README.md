# ESXi template

## How to build?

```bash
packer build -var-file=variables.pkrvars.hcl .
```

## How to run output image?

```bash
qemu-system-x86_64 \
  -name 'Custom ESXi image' \ # You can change this value.
  -machine pc,accel=kvm \
  -cpu host \
  -m 4G \ # You can change this value.
  -smp cores=4 \ # You can change this value.
  -k pt \
  -qmp unix:test.socket,server,nowait \
  -netdev bridge,id=net0,br=virbr0 \
  -device vmxnet3,id=nic0,netdev=net0,mac=52:54:00:12:34:56 \
  -drive if=ide,media=disk,discard=unmap,format=qcow2,cache=unsafe,file=<OUTPUT_IMAGE_PATH> # Set path.
```
