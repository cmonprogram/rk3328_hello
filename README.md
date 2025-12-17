# rk3328_hello
### S1 Compile
```
aarch64-linux-gnu-as -o hello.o hello.S
aarch64-linux-gnu-ld -Ttext 0x00200000 -o hello.elf hello.o
aarch64-linux-gnu-objcopy -O binary hello.elf hello.bin
```
### S2 Format sd
```
sudo parted /dev/mmcblk0 mklabel gpt
sudo parted -s /dev/mmcblk0 mklabel gpt mkpart primary ext4 1000MiB 100%
sudo mkfs.ext4 /dev/mmcblk0p1
```

### S3 Copy to sd
```
#contains U-Boot TPL (Tiny Program Loader) and U-Boot SPL (Secondary Program Loader)
sudo dd if=idbloader.img of=/dev/mmcblk0 seek=64

#main U-Boot image for rk3328
sudo dd if=u-boot.img of=/dev/mmcblk0 seek=16384

#program
sudo mount /dev/mmcblk0p1 ~/mount && sudo cp hello.bin ~/mount && sudo umount ~/mount
```

### S4 Uboot load 
```
ext4ls mmc 1:1
ext4load mmc 1:1 0x00200000 hello.bin
go 0x00200000
```
