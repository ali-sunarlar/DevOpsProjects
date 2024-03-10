# Manage Local Users and Groups

## Describe User and Group Concepts

### User

Üç tip kullanıcı tipi

Regular user

System User--> service user(Service'ler için kullanilan user'lar)

Super User--> root


Her kullanıcının id aralığı vardır.

UID Ranges

Red Hat Enterprise Linux uses specific UID numbers and ranges of numbers for specific purposes.

• UID 0 : The superuser (root) account UID.

• UID 1-200 : System account UIDs statically assigned to system processes.

• UID 201-999 : UIDs assigned to system processes that do not own files on this system.

Software that requires an unprivileged UID is dynamically assigned UID from this available pool.

• UID 1000+ : The UID range to assign to regular, unprivileged users

Use the id command to show information about the currently logged-in user:

```sh
[root@rocky2 user]# id
uid=0(root) gid=0(root) groups=0(root) context=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023
```
To view basic information about another user, pass the username to the id command as an
argument:

```sh
[root@rocky2 user]# id operator1
uid=1001(operator1) gid=1001(operator1) groups=1001(operator1),30000(operators)
```

Use the ps command -a option to view all processes with a terminal. Use the ps
command -u option to view the user that is associated with a process.

```sh
[root@rocky2 user]#  ps -au
USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root         759  0.0  0.0   3044  1060 tty1     Ss+  Mar08   0:00 /sbin/agetty -o -p -- \u --noclear - linux
user        2496  0.0  0.2   7444  4208 pts/1    Ss   07:42   0:00 -bash
root        2522  0.0  0.4  19360  8696 pts/1    S    07:43   0:00 sudo -s
root        2526  0.0  0.2   7576  4432 pts/1    S    07:43   0:00 /bin/bash
root        2883  0.0  0.2  10140  3640 pts/1    R+   12:38   0:00 ps -au
```

Bütün kullanıcıların bilgileri yer alır
```sh
[root@rocky2 user]# cat /etc/passwd
root:x:0:0:root:/root:/bin/bash
bin:x:1:1:bin:/bin:/sbin/nologin
daemon:x:2:2:daemon:/sbin:/sbin/nologin
adm:x:3:4:adm:/var/adm:/sbin/nologin
.
.
.
tech1:x:1010:1010::/home/tech1:/bin/bash
tech2:x:1011:1011::/home/tech2:/bin/bash
database1:x:1012:35003::/home/database1:/bin/bash
student:x:1013:1013::/home/student:/bin/bash
production1:x:1014:1014::/home/production1:/bin/bash
```

Consider each part of the code block, separated by a colon:

• student : The username for this user.

• x : The user's encrypted password was historically stored here; this is now a placeholder.

• 1013 : The UID number for this user account.

• 1013 : The GID number for this user account's primary group. Groups are discussed later in this
section.

• User One : A brief comment, description, or the real name for this user.

• /home/student : The user's home directory, and the initial working directory when the login
shell starts.

• /bin/bash : The default shell program for this user that runs at login. Some accounts use the
/sbin/nologin shell to disallow interactive logins with that account.

User description

```sh
[root@rocky2 user]#  usermod --comment "operator admin" operator1
[root@rocky2 user]#  usermod -c "operator admin" operator2
[root@rocky2 user]# cat /etc/passwd
root:x:0:0:root:/root:/bin/bash
bin:x:1:1:bin:/bin:/sbin/nologin
.
.
.
operator1:x:1001:1001:operator admin:/home/operator1:/bin/bash
operator2:x:1002:1002:operator admin:/home/operator2:/bin/bash
```





### Group



```sh
[root@rocky2 user]# cat /etc/group
root:x:0:
bin:x:1:
daemon:x:2:
sys:x:3:
adm:x:4:
.
.
.
operators:x:30000:operator1,operator2,operator3
admin:x:30001:sysadmin1,sysadmin2,sysadmin3
operator3:x:1003:
sysadmin1:x:1004:
sysadmin2:x:1005:
sysadmin3:x:1006:
consultant1:x:1007:
consultant2:x:1008:
consultant3:x:1009:
consultants:x:35000:
contractor1:x:35001:
techdocs:x:35002:tech1,tech2
```


Consider each part of the code block, separated by a colon:

• operators : Name for this group.

• x : Obsolete group password field; this is now a placeholder.

• 30000 : The GID number for this group (10000).

• operator1,operator2,operator3 : A list of users that are members of this group as a secondary group.


#### Primary Groups and Secondary Groups

1001(operator1)--> primary (kullanıcı ile beraber oluşan gruplardır)
30000(operators) 30001(admin)--> secodary veya supplementary gruplar

```sh
[root@rocky2 user]# id operator1
uid=1001(operator1) gid=1001(operator1) groups=1001(operator1),30000(operators),30001(admin)
```





## Gain Superuser Access

The Superuser

root 

Switch User Accounts

sudo su --> runas admin 

kullanıcının yetkisi olsa dahi yetkili işlemlerde sudo kullanilir.

```sh
[root@rocky2 user]# su - operator1
Last login: Wed Feb 28 03:43:43 +03 2024 on pts/1
Last failed login: Sat Mar  2 15:16:15 +03 2024 from 192.168.2.133 on ssh:notty
There were 5 failed login attempts since the last successful login.
[root@rocky2 user]# sudo su - operator1
Last login: Sat Mar  9 15:02:13 +03 2024 on pts/1
[operator1@rocky2 ~]$ su -
Password:
Last login: Tue Feb 27 23:32:05 +03 2024 on pts/0
Last failed login: Wed Mar  6 21:28:20 +03 2024 from ::1 on ssh:notty
There were 3 failed login attempts since the last successful login.
[root@rocky2 ~]#
```

su - yeni bir session başlatır

Run Commands with Sudo

The next table summarizes the differences between the su, su -, and sudo commands:

|           | su    | su -    | sudo    |
|--|--|--|--|
| Become new user | Yes | Yes | Per escalated command |
| Environment | Current user's | New user's | Current user's |
| Password required | New user's | New user's | Current user's |
| Privileges | Same as new user | Same as new user | Defined by configuration |
| Activity logged | su command only | su command only | Per escalated command |


kullanıcılara belirli-spesifik yetkilendirme yapabilmek için Command Aliases - Cmnd_Alias kullanilir.

kullaniciya sudo ile çalıştırabileceği işlevler belirtilir

```sh
[root@rocky2 ~]# vi /etc/sudoers

## Command Aliases
## These are groups of related commands...

## Networking
# Cmnd_Alias NETWORKING = /sbin/route, /sbin/ifconfig, /bin/ping, /sbin/dhclient, /usr/bin/net, /sbin/iptables, /usr/bin/rfcomm, /usr/bin/wvdial, /sbin/iwconfig, /sbin/mii-tool

## Installation and management of software
# Cmnd_Alias SOFTWARE = /bin/rpm, /usr/bin/up2date, /usr/bin/yum

## Services
# Cmnd_Alias SERVICES = /sbin/service, /sbin/chkconfig, /usr/bin/systemctl start, /usr/bin/systemctl stop, /usr/bin/systemctl reload, /usr/bin/systemctl restart, /usr/bin/systemctl status, /usr/bin/systemctl enable, /usr/bin/systemctl disable

## Updating the locate database
# Cmnd_Alias LOCATE = /usr/bin/updatedb

## Storage
# Cmnd_Alias STORAGE = /sbin/fdisk, /sbin/sfdisk, /sbin/parted, /sbin/partprobe, /bin/mount, /bin/umount

## Delegating permissions
# Cmnd_Alias DELEGATING = /usr/sbin/visudo, /bin/chown, /bin/chmod, /bin/chgrp
.
.
.
## Allows members of the 'sys' group to run networking, software,
## service management apps and more.
# %sys ALL = NETWORKING, SOFTWARE, SERVICES, STORAGE, DELEGATING, PROCESSES, LOCATE, DRIVERS

```

sudoers.d altında custome sudoers dosyalarını oluşturup yetkilendirmeler yapılabilir.Group yetkilendirmeleri % ile başlar.

```sh
[root@rocky2 ~]# vi /etc/sudoers.d/
admin        consultants  operator1
[root@rocky2 ~]# vi /etc/sudoers.d/consultants
#grup yetkilendirmesi

%consultants ALL=(ALL) ALL
~
#kullanıcı yetkilendirmesi
[root@rocky2 ~]# vi /etc/sudoers.d/operator1

operator1 ALL=(ALL) ALL
~
#kullaniciya sadece kullanıcı ekleme yetkisi verme
[root@rocky2 ~]# vi /etc/sudoers.d/useradd

operator2 ALL=/sbin/useradd NOPASSWD:ALL
~
~
```



## Manage Local User Accounts

### Create Users from the Command Line





### Modify Existing Users from the Command Line


|usermod options:|   Usage        |
|--|--|
| -a, --append | Use it with the -G option to add the secondary groups to the user's current set of group memberships instead of replacing the set of secondary groups with a new set. |
| -c, --comment | COMMENT Add the COMMENT text to the comment field. |
| -d, --home HOME_DIR | Specify a home directory for the user account. |
| -g, --gid GROUP | Specify the primary group for the user account. |
| -G, --groups | GROUPS Specify a comma-separated list of secondary groups for the user account. |
|-L, --lock | Lock the user account. |
| -m, --move-home | Move the user's home directory to a new location. You must use it with the -d option. |
| -s, --shell | SHELL Specify a particular login shell for the user account. |
| -U, --unlock | Unlock the user account. |


















