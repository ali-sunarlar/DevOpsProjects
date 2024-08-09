# Configure and Secure SSH


## Access the Remote Command Line with SSH

Secure Shell Examples


The following ssh command logs you in on the hosta remote server using the same user name
as the current local user. The remote system prompts you to authenticate with the developer1
user's password in this example.

```sh
[developer1@host ~]$ ssh hosta
developer1@hosta's password: redhat
...output omitted...
[developer1@hosta ~]$
```

Use the exit command to log out of the remote system.
```sh
[developer1@hosta ~]$ exit
logout
Connection to hosta closed.
[developer1@host ~]$
```
The following ssh command logs you in on the hosta remote server with the developer2 user
name. The remote system prompts you to authenticate with the developer2 user's password.
```sh
[developer1@host ~]$ ssh developer2@hosta
developer2@hosta's password: shadowman
...output omitted...
[developer2@hosta ~]$
```

The following ssh command runs the hostname command on the hosta remote system as the
developer2 user without accessing the remote interactive shell.

```sh
[developer1@host ~]$ ssh developer2@hosta hostname
developer2@hosta's password: shadowman
hosta.lab.example.com
[developer1@host ~]$
```

This command displays the output in the local system's terminal.
Identifying Remote Users
The w command displays a list of users that are currently logged in to the system. It also displays
the remote system location and commands that the user ran.

```sh
[developer1@host ~]$ ssh developer1@hosta
developer1@hosta's password: redhat
[developer1@hosta ~]$ w
 16:13:38 up 36 min, 1 user, load average: 0.00, 0.00, 0.00
USER TTY FROM LOGIN@ IDLE JCPU PCPU WHAT
developer2 pts/0 172.25.250.10 16:13 7:30 0.01s 0.01s -bash
developer1 pts/1 172.25.250.10 16:24 3.00s 0.01s 0.00s w
```


## SSH Host Keys

The ssh command asks for confirmation to log in when the client does not have a copy of
the public key in its known hosts file. The copy of the public key is saved in the ~/.ssh/
known_hosts file to confirm the server's identity for the future automatically.

```sh
[developer1@host ~]$ ssh hostb
The authenticity of host 'hosta (172.25.250.12)' can't be established.
ECDSA key fingerprint is SHA256:qaS0PToLrqlCO2XGklA0iY7CaP7aPKimerDoaUkv720.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added 'hostb,172.25.250.12' (ECDSA) to the list of known
 hosts.
developer1@hostb's password: redhat
...output omitted...
[developer1@hostb ~]$
```


Verify the fingerprint of the server's SSH host key by using the following command.

```sh
[developer1@hostb ~]$ ssh-keygen -l -f /etc/ssh/ssh_host_ecdsa_key.pub
256 SHA256:qaS0PToLrqlCO2XGklA0iY7CaP7aPKimerDoaUkv720 root@server (ECDSA)
```


SSH Known Hosts Key Managemen

The /etc/ssh/ssh_known_hosts file stores the public key file for each user on the SSH client.
Each key consists of one line, where the first field is the list of hostnames and IP addresses that
share the public key. The second field is the encryption algorithm that is used for the key. The last
field is the key itself.

ilk defa ssh bağlantısı yapıldığında uyarı vermesinin sebebi known_hosts dosyasında key bulunmadığında verir. Bu key oluşturulduktan secure bir şekilde bağlantı sağlanmış olur.

[developer1@host ~]$ ssh hostb
The authenticity of host 'hosta (172.25.250.12)' can't be established.
ECDSA key fingerprint is SHA256:qaS0PToLrqlCO2XGklA0iY7CaP7aPKimerDoaUkv720.
Are you sure you want to continue connecting (yes/no)? yes

```sh
[developer1@host ~]$ cat ~/.ssh/known_hosts
hosta,172.25.250.11 ecdsa-sha2-nistp256
 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBOsEi0e+FlaNT6jul8Ag5Nj
+RViZl0yE2w6iYUr+1fPtOIF0EaOgFZ1LXM37VFTxdgFxHS3D5WhnIfb+68zf8+w=
```


```sh
[developer1@host ~]$ cat ~/.ssh/known_hosts
hosta,172.25.250.11 ecdsa-sha2-nistp256
 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBOsEi0e+FlaNT6jul8Ag5Nj
+RViZl0yE2w6iYUr+1fPtOIF0EaOgFZ1LXM37VFTxdgFxHS3D5WhnIfb+68zf8+w=
```

Each remote SSH server that you connect to stores its public key in a file with the .pub extension
in the /etc/ssh directory.

```sh
[developer1@hosta ~]$ ls /etc/ssh/*key.pub
/etc/ssh/ssh_host_ecdsa_key.pub /etc/ssh/ssh_host_ed25519_key.pub /etc/ssh/
ssh_host_rsa_key.pub
```

# Configure SSH Key-based Authentication

## SSH Key-based Authentication

SSH keygen ile sunuculara şifresiz bağlanma

Use the ssh-keygen command to create a key pair. By default, the ssh-keygen command saves
your private and public keys in the ~/.ssh/id_rsa and ~/.ssh/id_rsa.pub files, but you can
specify a different name.



```sh
#Server A
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
#SERVER B
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