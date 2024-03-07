
## Introduction to the Bash Shell

The shell displays a string when it is waiting for user input, called the shell prompt. When a regular
user starts a shell, the prompt includes an ending dollar ($) character:

```sh
[user@host ~]$
```

A hash (#) character replaces the dollar ($) character when the shell is running as the superuser,
root. This character indicates that it is a superuser shell, which helps to avoid mistakes that can
affect the whole system.

```sh
[root@host ~]#
```


In this example, a user with a shell prompt on the machine host uses ssh to log in to the remote
Linux system remotehost as the user remoteuser:

```sh
[user@host ~]$ ssh remoteuser@remotehost
remoteuser@remotehost's password: password
[remoteuser@remotehost ~]$
```

option is used to specify the user's private key file, which is mylab.pem. The matching public key
is already set up as an authorized key in the remoteuser account.

```sh
[user@host ~]$ ssh -i mylab.pem remoteuser@remotehost
[remoteuser@remotehost ~]$
```

When you first log in to a new machine, you are prompted with a warning from ssh
that it cannot establish the authenticity of the host:

```sh
[user@host ~]$ ssh -i mylab.pem remoteuser@remotehost
The authenticity of host 'remotehost (192.0.2.42)' can't be established.
ECDSA key fingerprint is 47:bf:82:cd:fa:68:06:ee:d8:83:03:1a:bb:29:14:a3.
Are you sure you want to continue connecting (yes/no)? yes
[remoteuser@remotehost ~]$
```


