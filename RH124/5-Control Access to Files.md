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








