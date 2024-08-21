# Create and Extend Logical Volumes

## Logical Volume Manager Overview

fiziksel device

```sh

```

Logical Volume Manager Workflow

• Determine the physical devices used for creating physical volumes, and initialize these devices
as LVM physical volumes.
• Create a volume group from multiple physical volumes.
• Create the logical volumes from the available space in the volume group.
• Format the logical volume with a file system and mount it, or activate it as swap space, or pass
the raw volume to a database or storage server for advanced structures.



![alt text](image-2.png)


## Build LVM Storage






Parted ile partition yaratıyoruz.

```sh
[root@host ~]# pvcreate /dev/vdb1 /dev/sdb1
[root@host ~]# vgcreate vg01 /dev/vdb1
[root@host ~]# lvcreate -l 100%FREE -n lv01 vg01
[root@host ~]# lvextend -r -L +100G /dev/ubuntu-vg/ubuntu-lv
[root@host ~]# lvextend -l +100%FREE /dev/hanadata/LV_hanadata
```


https://networklessons.com/uncategorized/extend-lvm-partition


LAB 177 --> 182