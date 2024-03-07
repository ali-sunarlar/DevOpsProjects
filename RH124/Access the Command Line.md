
## Introduction to the Bash Shell

shell regular user'da ($) karakteri bulunur

```sh
[user@host ~]$
```

super user'da ise (#) karakteri bulunur

```sh
[root@host ~]#
```


uzak bir sunucuya ssh baglantisinin yapilmasi

```sh
[user@host ~]$ ssh remoteuser@remotehost
remoteuser@remotehost's password: password
[remoteuser@remotehost ~]$
```

public key ile ssh baglantisinin yapilmasi

```sh
[user@host ~]$ ssh -i mylab.pem remoteuser@remotehost
[remoteuser@remotehost ~]$
```

public key ile ssh baglantisi ilk defa yapildiginda uyarı alinir

```sh
[user@host ~]$ ssh -i mylab.pem remoteuser@remotehost
The authenticity of host 'remotehost (192.0.2.42)' can't be established.
ECDSA key fingerprint is 47:bf:82:cd:fa:68:06:ee:d8:83:03:1a:bb:29:14:a3.
Are you sure you want to continue connecting (yes/no)? yes
[remoteuser@remotehost ~]$
```

## Execute Commands with the Bash Shell

### Basic Command Syntax



```sh
[user@host ~]$ whoami
user
[user@host ~]$
```

Tek satirda birden fazla komut yazmak icin, komutlar (;) isareti ile birleştirilerek yazilabilir.


```sh
[user@host ~]$ command1 ; command2
command1 output
command2 output
[user@host ~]$
```

#### Write Simple Commands

data ile tarih ve saat goruntulenir. (+) işareti ile argüman alinarak farkli ciktilar elde edilebilir.

```sh
[user@host ~]$ date
Sun Feb 27 08:32:42 PM EST 2022
[user@host ~]$ date +%R
20:33
[user@host ~]$ date +%x
02/27/2022
```

passwd seçenek almadan calistirilirsa varsayilan kullanicinin parolasini degistirir. Super kullanicilar diğer kullacilarin parolasini degistirebilir.

```sh
[user@host ~]$ passwd
Changing password for user user.
Current password: old_password
New password: new_password
Retype new password: new_password
passwd: all authentication tokens updated successfully.
```



