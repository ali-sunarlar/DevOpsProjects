# Control Access to Files

## Linux File-system Permissions

Effects of Permissions on Files and Directories

|Permission|  Effect on files      |   Effect on directories        |
|--|--|--|
| r (read) | File contents can be read. | Contents of the directory (the file names) can be listed. |
| w (write) | File contents can be changed. | Any file in the directory can be created or deleted. |
| x (execute) | Files can be executed as commands. | The directory can become the current working directory. You can run the cd command to it, but it also requires read permission to list files there.|


## View File and Directory Permissions and Ownership

r - read

w - write

x - execute

Kullanıcı bazlı - grup bazlı - diğer kullanicilar için uygulayabilirim

```sh
[root@rocky2 dev]# ls -l /dev
total 0
crw-r--r--. 1 root root     10, 235 Mar  8 19:19 autofs
drwxr-xr-x. 2 root root         160 Mar  8 19:19 block
drwxr-xr-x. 2 root root          60 Mar  8 19:18 bsg
drwxr-xr-x. 3 root root          60 Mar  8 19:18 bus
lrwxrwxrwx. 1 root root           3 Mar  8 19:19 cdrom -> sr0
drwxr-xr-x. 2 root root        3120 Mar  8 19:19 char
crw--w----. 1 root tty       5,   1 Mar  8 19:19 console
lrwxrwxrwx. 1 root root          11 Mar  8 19:18 core -> /proc/kcore
drwxr-xr-x. 4 root root          80 Mar  8 19:18 cpu
crw-------. 1 root root     10, 124 Mar  8 19:19 cpu_dma_latency
drwxr-xr-x. 8 root root         160 Mar  8 19:19 disk
brw-rw----. 1 root disk    253,   0 Mar  8 19:19 dm-0
brw-rw----. 1 root disk    253,   1 Mar  8 19:19 dm-1

```


|The first character of the long listing is the file type, and is interpreted as follows:|
|--|
| • - is a regular file. |
| • d is a directory. |
| • l is a symbolic link. |
| • c is a character device file. |
| • b is a block device file. |
| • p is a named pipe file. |
| • s is a local socket file. |



drwxr-xr--. 3 root root          60 Mar  8 19:18 bus

drwx(owner)  r-x(grup veya kullanıcı)  r--(owner ve gruba dahil olmayan herhangi bir kullanıcı) .(Nokta işareti ACL) 3 root root          60 Mar  8 19:18 bus

üçlü olarak ayrılır

rwx owner'ın yetkisi read write ve execute yetkisi var

r-x grup ve kullanıcın yetkisini tanımlar sadece read

r-- owner ve gruba dahil olmayan herhangi bir kullanıcı

. ACL belirtir (Access Control List) eğer (.) Nokta işareti değil + işareti varsa ACL tanımlanmıştır.

ACL

owner veya kullanıcı-grup yetkilendirmeleri değiştirilmeden yetkilendirme için

```sh
[root@rocky2 ~]# getfacl dosya1.txt
# file: dosya1.txt
# owner: root
# group: root
user::rw-
group::r--
other::r--
[root@rocky2 ~]# setfacl -m u:operator1:rwx dosya1.txt
[root@rocky2 ~]# getfacl dosya1.txt
# file: dosya1.txt
# owner: root
# group: root
user::rw-
user:operator1:rwx
group::r--
mask::rwx
other::r--
[root@rocky2 ~]# ls -l
total 24
-rw-------.  1 root root 1425 Feb 25 20:09 anaconda-ks.cfg
drwxr-xr-x. 10 root root 4096 Mar  9 01:37 Documents
-rw-rwxr--+  1 root root    0 Mar  8 23:17 dosya1.txt
-rw-r--r--.  1 root root    0 Mar  8 23:17 dosya2.txt
-rw-r--r--.  1 root root    0 Mar  8 23:17 dosya3.txt
-rw-r--r--.  1 root root    0 Mar  8 23:17 dosya4.txt
-rw-r--r--.  1 root root    0 Mar  8 23:17 dosya5.txt
drwxr-xr-x.  2 root root 4096 Mar  8 23:12 files
drwxr-xr-x.  2 root root    6 Mar  8 23:11 folders
-rw-r--r--.  1 root root   60 Mar  9 04:27 output.txt
drwxr-xr-x.  4 root root   34 Mar  8 23:07 parentfolder
drwxr-xr-x.  2 root root    6 Mar  6 21:27 serverbackup
-rw-r--r--.  1 root root 5811 Mar  9 04:29 users.txt
drwxr-xr-x.  2 root root   54 Mar  8 23:15 Videos
```


## Manage File System Permissions from the Command Line


### Change Permissions with the Symbolic Method(Sembolik Metot)


chmod Who/What/Which file|directory

| Who | Set | Description|
|--|--|--|
| u | user | The file owner. |
| g | group | Member of the file's group. |
| o | other | Users who are not the file owner nor members of the file's group. |
| a | all | All the three previous groups. |


Operators

| What | Operation | Description |
|--|--|--|
| + | add | Adds the permissions to the file. |
| - | remove | Removes the permissions to the file. |
| = | set exactly | Set exactly the provided permissions to the file. |


Permissions

| Which | Mode | Description |
|--|--|--|
| r | read | Read access to the file. Listing access to the directory. |
| w | write | Write permissions to the file or directory. |
| x | execute | Execute permissions to the file. Allows to enter the directory, and access files and subdirectories inside the directory. |
| X | special execute | Execute permissions for a directory, or execute permissions to a file if it has at least one of the execute bits set. |



chmod   u - user    +/-/=   dosyaismi/dizinisimi

        g - group   +/-/=   dosyaismi/dizinisimi     
        
        o - other   +/-/=   dosyaismi/dizinisimi

        a - all     +/-/=   dosyaismi/dizinisimi

chmod u+rwx dosyaismi

chmod ug+rwx

chmod og+rwx

chmod u=rw 

chmod u-x


bütün herkesin yetkisi alınır
```sh
[root@rocky2 ~]# chmod a-rwx dosya1.txt
[root@rocky2 ~]# ls -l dosya1.txt
----------+ 1 root root 0 Mar  8 23:17 dosya1.txt
[root@rocky2 ~]# chmod a-rwx dosya2.txt
[root@rocky2 ~]# ls -l dosya2.txt
----------. 1 root root 0 Mar  8 23:17 dosya2.txt
```

user'a read yetkisi verme

```sh
[root@rocky2 ~]# chmod u+r dosya2.txt
[root@rocky2 ~]# ls -l dosya2.txt
-r--------. 1 root root 0 Mar  8 23:17 dosya2.txt
```

group ve other için sadece execute yetkisi

```sh
[root@rocky2 ~]# chmod go+x dosya2.txt
[root@rocky2 ~]# ls -l dosya2.txt
-r----x--x. 1 root root 0 Mar  8 23:17 dosya2.txt
```

User'ı read write execute yetkisi ile eşitleme

```sh
[root@rocky2 ~]# chmod u=rwx dosya2.txt
[root@rocky2 ~]# ls -l dosya2.txt
-rwx--x--x. 1 root root 0 Mar  8 23:17 dosya2.txt
```

User'ı sadece read verme diğer yetkileri alma

```sh
[root@rocky2 ~]# chmod u=r dosya2.txt
[root@rocky2 ~]# ls -l dosya2.txt
-r----x--x. 1 root root 0 Mar  8 23:17 dosya2.txt
```

Dizin altında oluşturulan dosyalar dizinle aynı yetkide olmaz.(Umask diye bir kavram'dan dolayı böyledir )

```sh
[root@rocky2 ~]# ls -l
total 24
-rw-------.  1 root root 1425 Feb 25 20:09 anaconda-ks.cfg
drwxr-xr-x. 10 root root 4096 Mar  9 01:37 Documents
----------+  1 root root    0 Mar  8 23:17 dosya1.txt
-r----x--x.  1 root root    0 Mar  8 23:17 dosya2.txt
-rw-r--r--.  1 root root    0 Mar  8 23:17 dosya3.txt
-rw-r--r--.  1 root root    0 Mar  8 23:17 dosya4.txt
-rw-r--r--.  1 root root    0 Mar  8 23:17 dosya5.txt
drwxr-xr-x.  2 root root 4096 Mar  8 23:12 files
drwxr-xr-x.  2 root root    6 Mar  8 23:11 folders
-rw-r--r--.  1 root root   60 Mar  9 04:27 output.txt
dr--r-xr-x.  4 root root   34 Mar  8 23:07 parentfolder
drwxr-xr-x.  2 root root    6 Mar  6 21:27 serverbackup
[root@rocky2 ~]# touch parentfolder/test1.txt parentfolder/test2.txt
[root@rocky2 ~]# ls -l parentfolder/
total 0
drwxr-xr-x. 2 root root 6 Mar  8 23:07 child1
drwxr-xr-x. 2 root root 6 Mar  8 23:07 child2
-rw-r--r--. 1 root root 0 Mar 10 07:42 test1.txt
-rw-r--r--. 1 root root 0 Mar 10 07:42 test2.txt
```


Dizin ve  dizin altındaki dizin ve dosyalar aynı yetkilerin verilmesi için

```sh
#yetki alma
[root@rocky2 ~]# chmod -R ugo-rwx parentfolder
[root@rocky2 ~]# ls -l parentfolder/
total 0
d---------. 2 root root 6 Mar  8 23:07 child1
d---------. 2 root root 6 Mar  8 23:07 child2
----------. 1 root root 0 Mar 10 07:42 test1.txt
----------. 1 root root 0 Mar 10 07:42 test2.txt
#yetki verme
[root@rocky2 ~]# chmod -R ugo+rwx parentfolder
[root@rocky2 ~]# ls -l parentfolder/
total 0
drwxrwxrwx. 2 root root 6 Mar  8 23:07 child1
drwxrwxrwx. 2 root root 6 Mar  8 23:07 child2
-rwxrwxrwx. 1 root root 0 Mar 10 07:42 test1.txt
-rwxrwxrwx. 1 root root 0 Mar 10 07:42 test2.txt
```


## Change Permissions with the Octal Method(Numerik Metot)

chmod ### file|directory

• Start with 0.

• If you want to add read permissions for this access level, then add 4.

• If you want to add write permissions, then add 2.

• If you want to add execute permissions, then add 1.

| Binary Conversion |
|--|--|--|
| 1 | 1 | 1 |
| 4 | 2 | 1 |
|           |









