# Analyze and Store Logs


## Describe System Log Architecture


|  Logs             | Detail                                                                  |
| ----------------- | ----------------------------------------------------------------------- | 
| /var/log/messages | Sistem günlüğü mesajlarının çoğu burada günlüğe kaydedilir. |
| /var/log/secure | Güvenlik ve kimlik doğrulama olaylarıyla ilgili sistem günlüğü mesajları. |
| /var/log/maillog | Posta sunucusuyla ilgili sistem günlüğü mesajları. | 
| /var/log/cron | Görev zamanlayıcı ile ilgili logları tutar. |
| /var/log/boot.log | Sunucunun açılışındaki oluşan logları tutar | 

## Sample Rules of the rsyslog Service


Temel seviyede OS loglama için kullanılır. Toplamak, ayrıştırmak için kullanılır. 

1-Toplamak

2-Depolamak

3-(Kural setlerine göre)Analiz edilmesi için parse edilmesi

4-Gerekli aksiyonların alınması için log'ların yakalanması sağlanır

Overview of Syslog Priorities

|Code |  Facility | Facility description |
|-----|-----------|----------------------|
| 0  | kern | Kernel messages|
| 1  | user  | User-level messages |
| 2 | mail | Mail system messages |
| 3 | daemon | System daemons messages |
| 4 | auth | Authentication and security messages |
| 5 | syslog | Internal syslog messages |
| 6 | lpr | Printer messages |
| 7 | news | Network news messages |
| 8 | uucp | UUCP protocol messages |
| 9 | cron | Clock daemon messages |
| 10 | authpriv | Non-system authorization messages |
| 11 | ftp | FTP protocol messages |
| 16-23 | local0 to local7 | Custom local messages |





```ssh
[root@host ~]# vi /etc/rsyslog.conf

#### RULES ####
# Log all kernel messages to the console.
# Logging much else clutters up the screen.
#kern.* /dev/console
# Log anything (except mail) of level info or higher.
# Don't log private authentication messages!
*.info;mail.none;authpriv.none;cron.none /var/log/messages
# The authpriv file has restricted access.
authpriv.* /var/log/secure
# Log all the mail messages in one place.
mail.* -/var/log/maillog
# Log cron stuff
cron.* /var/log/cron
# Everybody gets emergency messages
.emerg :omusrmsg:
# Save news errors of level crit and higher in a special file.
uucp,news.crit /var/log/spooler
# Save boot messages also to boot.log
local7.* 
```

## Log File Rotation

```ssh
[root@host ~]# vi /etc/rsyslog.conf
Append 
*.*@@logforwardingip:port // Bu tüm configleri yönlendirir.
mail.*@@logforwardingip:port // sadece mail loglarını yönlendirir.
```

## Monitor Log Events
```ssh
[root@host ~]# tail -f /var/log/secure
```
# Review System Journal Entries

```ssh
[root@host ~]# journalctl
...output omitted...
Mar 15 04:42:16 host.lab.example.com systemd[2127]: Listening on PipeWire
 Multimedia System Socket.
Mar 15 04:42:16 host.lab.example.com systemd[2127]: Starting Create User's
 Volatile Files and Directories...
Mar 15 04:42:16 host.lab.example.com systemd[2127]: Listening on D-Bus User
 Message Bus Socket.
Mar 15 04:42:16 host.lab.example.com systemd[2127]: Reached target Sockets.
Mar 15 04:42:16 host.lab.example.com systemd[2127]: Finished Create User's
 Volatile Files and Directories.
Mar 15 04:42:16 host.lab.example.com systemd[2127]: Reached target Basic System.
Mar 15 04:42:16 host.lab.example.com systemd[1]: Started User Manager for UID 0.
Mar 15 04:42:16 host.lab.example.com systemd[2127]: Reached target Main User
 Target.

[root@host ~]# journalctl -n 5
Mar 15 04:42:17 host.lab.example.com systemd[1]: Started Hostname Service.
Mar 15 04:42:47 host.lab.example.com systemd[1]: systemd-hostnamed.service:
 Deactivated successfully.
Mar 15 04:47:33 host.lab.example.com systemd[2127]: Created slice User Background
 Tasks Slice.
Mar 15 04:47:33 host.lab.example.com systemd[2127]: Starting Cleanup of User's
 Temporary Files and Directories...
Mar 15 04:47:33 host.lab.example.com systemd[2127]: Finished Cleanup of User's
 Temporary Files and Directories.

Tail komutuna benzer şekilde, Journalctl komutu -f seçeneği sistem günlüğünün son 10 satırını çıktı olarak verir ve günlük girdilerini ekledikçe yeni günlük girişlerinin çıktısını almaya devam eder. Journalctl komutu -f seçeneğinden çıkmak için Ctrl+C tuş birleşimini kullanın.

[root@host ~]# journalctl -f
Mar 15 04:47:33 host.lab.example.com systemd[2127]: Finished Cleanup of User's
 Temporary Files and Directories.
Mar 15 05:01:01 host.lab.example.com CROND[2197]: (root) CMD (run-parts /etc/
cron.hourly)
Mar 15 05:01:01 host.lab.example.com run-parts[2200]: (/etc/cron.hourly) starting
 0anacron
Mar 15 05:01:01 host.lab.example.com anacron[2208]: Anacron started on 2022-03-15
Mar 15 05:01:01 host.lab.example.com anacron[2208]: Will run job `cron.daily' in
 29 min.
Mar 15 05:01:01 host.lab.example.com anacron[2208]: Will run job `cron.weekly' in
 49 min.
Mar 15 05:01:01 host.lab.example.com anacron[2208]: Will run job `cron.monthly' in
 69 min.

[root@host ~]# journalctl -p err
Mar 15 04:22:00 host.lab.example.com pipewire-pulse[1640]: pw.conf: execvp error
 'pactl': No such file or direct
Mar 15 04:22:17 host.lab.example.com kernel: Detected CPU family 6 model 13
 stepping 3
Mar 15 04:22:17 host.lab.example.com kernel: Warning: Intel Processor - this
 hardware has not undergone testing by Red Hat and might not be certif>
Mar 15 04:22:20 host.lab.example.com smartd[669]: DEVICESCAN failed: glob(3)
 aborted matching pattern /dev/discs/disc*

 [root@host ~]# journalctl -u sshd.service
May 15 04:30:18 host.lab.example.com systemd[1]: Starting OpenSSH server daemon...
May 15 04:30:18 host.lab.example.com sshd[1142]: Server listening on 0.0.0.0 port
 22.
May 15 04:30:18 host.lab.example.com sshd[1142]: Server listening on :: port 22.
May 15 04:30:18 host.lab.example.com systemd[1]: Started OpenSSH server daemon.
May 15 04:32:03 host.lab.example.com sshd[1796]: Accepted publickey for user1 from
 172.25.250.254 port 43876 ssh2: RSA SHA256:1UGy...>
May 15 04:32:03 host.lab.example.com sshd[1796]: pam_unix(sshd:session): session
 opened for user user1(uid=1000) by (uid=0)

[root@host ~]# journalctl --since today
...output omitted...
Mar 15 05:04:20 host.lab.example.com systemd[1]: Started Session 8 of User
 student.
Mar 15 05:04:20 host.lab.example.com sshd[2255]: pam_unix(sshd:session): session
 opened for user student(uid=1000) by (uid=0)
Mar 15 05:04:20 host.lab.example.com systemd[1]: Starting Hostname Service...

[root@host ~]# journalctl --since "2022-03-11 20:30" --until "2022-03-14 10:00"
...output omitted...

[root@host ~]# journalctl --since "-1 hour"

 ```

## Tarih Saat

```ssh
[user@host ~]$ timedatectl
 Local time: Wed 2022-03-16 05:53:05 EDT
 Universal time: Wed 2022-03-16 09:53:05 UTC
 RTC time: Wed 2022-03-16 09:53:05
 Time zone: America/New_York (EDT, -0400)
System clock synchronized: yes
 NTP service: active
 RTC in local TZ: no

[user@host ~]$ timedatectl list-timezones
Africa/Abidjan
Africa/Accra
Africa/Addis_Ababa
Africa/Algiers
Africa/Asmara
Africa/Bamako

[root@host ~]# timedatectl set-timezone America/Phoenix
[root@host ~]# timedatectl
 Local time: Wed 2022-03-16 03:05:55 MST
 Universal time: Wed 2022-03-16 10:05:55 UTC
 RTC time: Wed 2022-03-16 10:05:55
 Time zone: America/Phoenix (MST, -0700)
System clock synchronized: yes
 NTP service: active
 RTC in local TZ: no

[root@host ~]# timedatectl set-time 9:00:00
[root@host ~]# timedatectl
 Local time: Fri 2019-04-05 09:00:27 MST
 Universal time: Fri 2019-04-05 16:00:27 UTC
 RTC time: Fri 2019-04-05 16:00:27
 Time zone: America/Phoenix (MST, -0700)
System clock synchronized: yes
 NTP service: active
 RTC in local TZ: no

[root@host ~]# timedatectl set-ntp false


## Configure and Monitor the chronyd Service

/etc/chrony.conf içerisinden yapılır.


LAB 358 --> 360
LAB 371 --> 374