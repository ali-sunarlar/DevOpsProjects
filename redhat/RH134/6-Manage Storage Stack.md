# Create and Extend Logical Volumes

## Logical Volume Manager Overview

fiziksel device

```sh
[root@rocky1 ~]# lsblk
NAME        MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
sr0          11:0    1  1.6G  0 rom
nvme0n1     259:0    0   20G  0 disk
├─nvme0n1p1 259:1    0    1G  0 part /boot
└─nvme0n1p2 259:2    0   19G  0 part
  ├─rl-root 253:0    0   17G  0 lvm  /
  └─rl-swap 253:1    0    2G  0 lvm  [SWAP]
nvme0n2     259:3    0    5G  0 disk
nvme0n3     259:4    0    5G  0 disk
nvme0n4     259:5    0    5G  0 disk
nvme0n5     259:6    0    5G  0 disk
```

oluşturabilmek için öncellikle partition atamlarını yapıyoruz.

```sh
[root@rocky1 ~]# parted /dev/nvme0n2 mklabel gpt
Information: You may need to update /etc/fstab.
[root@rocky1 ~]# parted /dev/nvme0n3 mklabel gpt
Information: You may need to update /etc/fstab.
[root@rocky1 ~]# parted /dev/nvme0n4 mklabel gpt
Information: You may need to update /etc/fstab.
[root@rocky1 ~]# parted /dev/nvme0n5 mklabel gpt
Information: You may need to update /etc/fstab.
#tekrar atanırsa
[root@rocky1 ~]# parted /dev/nvme0n5 mklabel gpt
Warning: The existing disk label on /dev/nvme0n5 will be destroyed and all data on this disk will be lost. Do you want to continue?
Yes/No? Yes
Information: You may need to update /etc/fstab.
```

```sh

[root@rocky1 ~]# parted /dev/nvme0n2
GNU Parted 3.5
Using /dev/nvme0n2
Welcome to GNU Parted! Type 'help' to view a list of commands.
(parted) mkpart
Partition name?  []? primary
File system type?  [ext2]? xfs
Start? 0%
End? 100%
(parted) quit
Information: You may need to update /etc/fstab.

[root@rocky1 ~]# parted /dev/nvme0n3
GNU Parted 3.5
Using /dev/nvme0n3
Welcome to GNU Parted! Type 'help' to view a list of commands.
(parted) mkpart
Partition name?  []? primary
File system type?  [ext2]? xfs
Start? 0%
End? 100%
(parted) quit
Information: You may need to update /etc/fstab.

[root@rocky1 ~]# parted /dev/nvme0n4
GNU Parted 3.5
Using /dev/nvme0n4
Welcome to GNU Parted! Type 'help' to view a list of commands.
(parted) mkpart
Partition name?  []? primary
File system type?  [ext2]? xfs
Start? 0%
End? 100%
(parted) q
Information: You may need to update /etc/fstab.


[root@rocky1 ~]# parted /dev/nvme0n5
GNU Parted 3.5
Using /dev/nvme0n5
Welcome to GNU Parted! Type 'help' to view a list of commands.
(parted) mkpart
Partition name?  []? primary
File system type?  [ext2]? xfs
Start? 0%
End? 100%
(parted) q
Information: You may need to update /etc/fstab.

```

son lsblk çıktısı

```sh
[root@rocky1 ~]# lsblk
NAME        MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
sr0          11:0    1  1.6G  0 rom
nvme0n1     259:0    0   20G  0 disk
├─nvme0n1p1 259:1    0    1G  0 part /boot
└─nvme0n1p2 259:2    0   19G  0 part
  ├─rl-root 253:0    0   17G  0 lvm  /
  └─rl-swap 253:1    0    2G  0 lvm  [SWAP]
nvme0n2     259:3    0    5G  0 disk
└─nvme0n2p1 259:7    0    5G  0 part
nvme0n3     259:4    0    5G  0 disk
└─nvme0n3p1 259:8    0    5G  0 part
nvme0n4     259:5    0    5G  0 disk
└─nvme0n4p1 259:9    0    5G  0 part
nvme0n5     259:6    0    5G  0 disk
└─nvme0n5p1 259:10   0    5G  0 part
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