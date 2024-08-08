 # Access Network-Attached Storage


 https://www.digitalocean.com/community/tutorials/how-to-set-up-an-nfs-mount-on-ubuntu-20-04

 
[root@host ~]# dnf install nfs-utils
[root@host ~]# showmount --exports serverip

[root@host ~]# mkdir /mountpoint
[root@host ~]# mount server:/ /mountpoint
[root@host ~]# ls /mountpoint
[root@host ~]# mount -t nfs -o rw,sync server:/export /mountpoint
[root@host ~]# vi /etc/fstab
server:/export /mountpoint nfs rw,soft 0 0
[root@host ~]# umount /mountpoint
