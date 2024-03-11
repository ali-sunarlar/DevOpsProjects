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

|The first character of the long listing is the file type, and is interpreted as follows:|
|--|
| • - is a regular file. |
| • d is a directory. |
| • l is a symbolic link. |
| • c is a character device file. |
| • b is a block device file. |
| • p is a named pipe file. |
| • s is a local socket file. |








