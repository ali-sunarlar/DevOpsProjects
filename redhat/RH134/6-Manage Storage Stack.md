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



Prepare Physical Devices

Partitioning is optional when already present. Use the parted command to create a new partition
on the physical device. Set the physical device to the Linux LVM partition type. Use the
udevadm settle command to register the new partition with the kernel

```sh
[root@host ~]# parted /dev/vdb mklabel gpt mkpart primary 1MiB 769MiB
...output omitted...
[root@host ~]# parted /dev/vdb mkpart primary 770MiB 1026MiB
[root@host ~]# parted /dev/vdb set 1 lvm on
[root@host ~]# parted /dev/vdb set 2 lvm on
[root@host ~]# udevadm settle
```

Create Physical Volumes

Use the pvcreate command to label the physical partition as an LVM physical volume. Label
multiple devices simultaneously by using space-delimited device names as arguments to the
pvcreate command. This example labels the /dev/vdb1 and /dev/vdb2 devices as PVs that
are ready for creating volume groups


```sh
[root@host ~]# pvcreate /dev/vdb1 /dev/vdb2
 Physical volume "/dev/vdb1" successfully created.
 Physical volume "/dev/vdb2" successfully created.
 Creating devices file /etc/lvm/devices/system.devices
```


Create a Volume Group

The vgcreate command builds one or more physical volumes into a volume group. The first
argument is a volume group name, followed by one or more physical volumes to allocate to this
VG. This example creates the vg01 VG using the /dev/vdb1 and /dev/vdb2 PVs


```sh
[root@host ~]# vgcreate vg01 /dev/vdb1 /dev/vdb2
 Volume group "vg01" successfully created
```





Parted ile partition yaratıyoruz.

```sh
[root@host ~]# pvcreate /dev/vdb1 /dev/sdb1
[root@host ~]# vgcreate vg01 /dev/vdb1
[root@host ~]# lvcreate -l 100%FREE -n lv01 vg01
[root@host ~]# lvextend -r -L +100G /dev/ubuntu-vg/ubuntu-lv
[root@host ~]# lvextend -l +100%FREE /dev/hanadata/LV_hanadata
```


Create a Logical Volume

The lvcreate command creates a new logical volume from the available PEs in a volume group.
Use the lvcreate command to set the LV name and size and the VG name that will contain this
logical volume. This example creates lv01 LV with 700 MiB in size in the vg01 VG

```sh
[root@host ~]# lvcreate -n lv01 -L 300M vg01
 Logical volume "lv01" created.
```

The lvcreate command -L option requires sizes in bytes, mebibytes (binary megabytes,
1048576 bytes), and gibibytes (binary gigabytes), or similar. The lower case -l requires sizes
specified as a number of physical extents. The following commands are two choices for creating
the same LV with the same size

```sh
• lvcreate -n lv01 -L 128M vg01 : create an LV of size 128 MiB, rounded to the next PE.
• lvcreate -n lv01 -l 32 vg01 : create an LV of size 32 PEs at 4 MiB each is 128 MiB.
```

Create a Logical Volume with Deduplication and Compression








https://networklessons.com/uncategorized/extend-lvm-partition


LAB 177 --> 182