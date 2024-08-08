The following ssh command logs you in on the hosta remote server using the same user name
as the current local user. The remote system prompts you to authenticate with the developer1
user's password in this example.
```sh
[developer1@host ~]$ ssh hosta
developer1@hosta's password: redhat
...output omitted...
[developer1@hosta ~]$
Use the exit command to log out of the remote system.
[developer1@hosta ~]$ exit
logout
Connection to hosta closed.
[developer1@host ~]$
The following ssh command logs you in on the hosta remote server with the developer2 user
name. The remote system prompts you to authenticate with the developer2 user's password.
[developer1@host ~]$ ssh developer2@hosta
developer2@hosta's password: shadowman
...output omitted...
[developer2@hosta ~]$
The following ssh command runs the hostname command on the hosta remote system as the
developer2 user without accessing the remote interactive shell.
304 RH124-RHEL9.0-en-2-20220609
Chapter 10 | Configure and Secure SSH
[developer1@host ~]$ ssh developer2@hosta hostname
developer2@hosta's password: shadowman
hosta.lab.example.com
[developer1@host ~]$
This command displays the output in the local system's terminal.
Identifying Remote Users
The w command displays a list of users that are currently logged in to the system. It also displays
the remote system location and commands that the user ran.
[developer1@host ~]$ ssh developer1@hosta
developer1@hosta's password: redhat
[developer1@hosta ~]$ w
 16:13:38 up 36 min, 1 user, load average: 0.00, 0.00, 0.00
USER TTY FROM LOGIN@ IDLE JCPU PCPU WHAT
developer2 pts/0 172.25.250.10 16:13 7:30 0.01s 0.01s -bash
developer1 pts/1 172.25.250.10 16:24 3.00s 0.01s 0.00s w
```
## SSH keygen ile sunuculara şifresiz bağlanma

```sh
Server A
[operator1@serverb ~]$ ssh-keygen
Generating public/private rsa key pair.
Enter file in which to save the key (/home/operator1/.ssh/id_rsa): Enter
Created directory '/home/operator1/.ssh'.
Enter passphrase (empty for no passphrase): Enter
Enter same passphrase again: Enter
Your identification has been saved in /home/operator1/.ssh/id_rsa.
Your public key has been saved in /home/operator1/.ssh/id_rsa.pub.
The key fingerprint is:
SHA256:JainiQdnRosC+xXh operator1@serverb.lab.example.com
The key's randomart image is:
+---[RSA 3072]----+
|E+*+ooo . |
|.= o.o o . |
|o.. = . . o |
|+. + * . o . |
|+ = X . S + |
| + @ + = . |
|. + = o |
|.o . . . . |
|o o.. |
+----[SHA256]-----+
```

```sh
SERVER B
[operator1@serverb ~]$ ssh-copy-id operator1@servera
/usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "/home/
operator1/.ssh/id_rsa.pub"
The authenticity of host 'servera (172.25.250.10)' can't be established.
ED25519 key fingerprint is SHA256:h/hEJa/anxp6AP7BmB5azIPVbPNqieh0oKi4KWOTK80.
This key is not known by any other names
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
/usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter
 out any that are already installed
/usr/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted
 now it is to install the new keys
operator1@servera's password: redhat
Number of key(s) added: 1
Now try logging into the machine, with: "ssh 'operator1@servera'"
and check to make sure that only the key(s) you wanted were added.
```
```sh
[operator1@serverb ~]$ ssh operator1@servera hostname
servera.lab.example.com
```

## Customize OpenSSH Service Configuration

```sh
[root@host ~]# vi /etc/ssh/sshd_config

PermitRootLogin yes

[root@host ~]# systemctl reload sshd

PasswordAuthentication yes

``` 
LAB 325 --> 327