# Manage Storage Stack

![alt text](image-2.png)

Parted ile partition yaratıyoruz.

[root@host ~]# pvcreate /dev/vdb1 /dev/sdb1
[root@host ~]# vgcreate vg01 /dev/vdb1
[root@host ~]# lvcreate -l 100%FREE -n lv01 vg01
[root@host ~]# lvextend -r -L +100G /dev/ubuntu-vg/ubuntu-lv
[root@host ~]# lvextend -l +100%FREE /dev/hanadata/LV_hanadata

https://networklessons.com/uncategorized/extend-lvm-partition


LAB 177 --> 182