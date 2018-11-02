# Clearlinux Aliyun

- [ECS setup](#ECS-setup)
- [Welcome Message setup](#Welcome-message-setup)
- [Qemu setup](#Qemu-setup)

## ECS setup
Clearlinux can be installed from Aliyun marketplace. A typical clearlinux instance can be created as below example.

**IMPORTANT: clearlinux does not support passwd login by default. And it cannot supported to change passwd and key-pair after instance created. It MUST set the key-pair during instance creating.**

Please notice the hightlights with red circles!!!
![](img/create_instance_1.png?raw=true)
![](img/create_instance_2.png?raw=true)
![](img/create_instance_3.png?raw=true)
![](img/create_instance_4.png?raw=true)
![](img/create_instance_5.png?raw=true)

## Welcome message setup
```
echo "Welcome to Clear Linux OS !" >  /etc/motd
```

## Qemu setup
For clearlinux mixer image test, it needs to run Qemu inside ECS instance. The official clearlinux release includes a [qemu start script](https://download.clearlinux.org/image/start_qemu.sh) to launch clearlinux image with KVM enabled. 

Unfortunately, Aliyun ECS does not support nested virtualization. It needs to modify this script to disable KVM. Here is [the example of modified script](../examples/start_qemu_nokvm.sh?raw=true).
```
qemu-system-x86_64 \
    ${UEFI_BIOS} \
    -smp sockets=1,cpus=2,cores=2 -cpu Haswell \
    -m 1024 \
    -vga none -nographic \
    -drive file="$IMAGE",if=virtio,aio=threads,format=raw \
    -netdev user,id=mynet0,hostfwd=tcp::${VMN}0022-:22,hostfwd=tcp::${VMN}2375-:2375 \
    -device virtio-net-pci,netdev=mynet0 \
    -device virtio-rng-pci \
    -debugcon file:debug.log -global isa-debugcon.iobase=0x402 $@
```
