# Schedule a Deferred User Job



## Describe Deferred User Tasks

1-kullanıcının kendi yapacagi islemler

2-zamanlama planlama

3-arka planda aksiyonlar

4-kullanici hemen hemen butun islemi yapilabilir


OS kapanıp açıldığından bütün job'lar silinir


Uer job

```sh
[user@host ~]$ date
Wed May 18 21:01:18 CDT 2022
[user@host ~]$ at 21:03 < myscript
job 3 at Wed May 18 21:03:00 2022
[user@host ~]$ at 21:00 < myscript
job 4 at Thu May 19 21:00:00 2022

[user@host ~]$ atq
28 Mon May 16 05:13:00 2022 a user
29 Tue May 17 16:00:00 2022 h user
30 Wed May 18 12:00:00 2022 a user
```

The man pages for the at command and other documentation sources use lowercase to write
the natural time specifications, but you can use lowercase, sentence case, or uppercase. Here are
examples of time specifications you can use

• now +5min

• teatime tomorrow (teatime is 16:00)

• noon +4 days

• 5pm august 3 2021


```sh
[root@rocky2 ~]# at teatime tomorrow < myscript
warning: commands will be executed using /bin/sh
job 3 at Thu Aug 15 16:00:00 2024
[root@rocky2 ~]# atq
1       Wed Aug 14 21:03:00 2024 a root
3       Thu Aug 15 16:00:00 2024 a root
```

```sh
[root@rocky2 ~]# at noon +4 days < myscript
warning: commands will be executed using /bin/sh
job 4 at Sun Aug 18 12:00:00 2024
[root@rocky2 ~]# atq
1       Wed Aug 14 21:03:00 2024 a root
3       Thu Aug 15 16:00:00 2024 a root
4       Sun Aug 18 12:00:00 2024 a root
```

## Inspect and Manage Deferred User Jobs

For an overview of the pending jobs for the current user, use the atq or the at -l command

```sh
[user@host ~]$ atq
28 Mon May 16 05:13:00 2022 a user
29 Tue May 17 16:00:00 2022 h user
30 Wed May 18 12:00:00 2022 a user
```

In the preceding output, every line represents a different scheduled future job. The following
description applies to the first line of the output

• 28 is the unique job number.

• Mon May 16 05:13:00 2022 is the execution date and time for the scheduled job.

• a indicates that the job is scheduled with the default queue a.

• user is the owner of the job (and the user that the job runs as).


Use the at -c JOBNUMBER command to inspect the commands that run when the atd
daemon executes a job. This command shows the job's environment, which is set from the user's
environment when they created the job, and the command syntax to be run

job'ın ne işlem yapacağını ve config görüntülemek icin

```sh
[root@rocky2 ~]# at -c 3
#!/bin/sh
# atrun uid=0 gid=0
# mail root 0
umask 22
SHELL=/bin/bash; export SHELL
HISTCONTROL=ignoredups; export HISTCONTROL
HISTSIZE=1000; export HISTSIZE
HOSTNAME=rocky2; export HOSTNAME
PWD=/root; export PWD
LOGNAME=root; export LOGNAME
XDG_SESSION_TYPE=tty; export XDG_SESSION_TYPE
MOTD_SHOWN=pam; export MOTD_SHOWN
HOME=/root; export HOME
LANG=en_US.UTF-8; export LANG
LS_COLORS=rs=0:di=01\;34:ln=01\;36:mh=00:pi=40\;33:so=01\;35:do=01\;35:bd=40\;33\;01:cd=40\;33\;01:or=40\;31\;01:mi=01\;37\;41:su=37\;41:sg=30\;43:ca=30\;41:tw=30\;42:ow=34\;42:st=37\;44:ex=01\;32:\*.tar=01\;31:\*.tgz=01\;31:\*.arc=01\;31:\*.arj=01\;31:\*.taz=01\;31:\*.lha=01\;31:\*.lz4=01\;31:\*.lzh=01\;31:\*.lzma=01\;31:\*.tlz=01\;31:\*.txz=01\;31:\*.tzo=01\;31:\*.t7z=01\;31:\*.zip=01\;31:\*.z=01\;31:\*.dz=01\;31:\*.gz=01\;31:\*.lrz=01\;31:\*.lz=01\;31:\*.lzo=01\;31:\*.xz=01\;31:\*.zst=01\;31:\*.tzst=01\;31:\*.bz2=01\;31:\*.bz=01\;31:\*.tbz=01\;31:\*.tbz2=01\;31:\*.tz=01\;31:\*.deb=01\;31:\*.rpm=01\;31:\*.jar=01\;31:\*.war=01\;31:\*.ear=01\;31:\*.sar=01\;31:\*.rar=01\;31:\*.alz=01\;31:\*.ace=01\;31:\*.zoo=01\;31:\*.cpio=01\;31:\*.7z=01\;31:\*.rz=01\;31:\*.cab=01\;31:\*.wim=01\;31:\*.swm=01\;31:\*.dwm=01\;31:\*.esd=01\;31:\*.jpg=01\;35:\*.jpeg=01\;35:\*.mjpg=01\;35:\*.mjpeg=01\;35:\*.gif=01\;35:\*.bmp=01\;35:\*.pbm=01\;35:\*.pgm=01\;35:\*.ppm=01\;35:\*.tga=01\;35:\*.xbm=01\;35:\*.xpm=01\;35:\*.tif=01\;35:\*.tiff=01\;35:\*.png=01\;35:\*.svg=01\;35:\*.svgz=01\;35:\*.mng=01\;35:\*.pcx=01\;35:\*.mov=01\;35:\*.mpg=01\;35:\*.mpeg=01\;35:\*.m2v=01\;35:\*.mkv=01\;35:\*.webm=01\;35:\*.webp=01\;35:\*.ogm=01\;35:\*.mp4=01\;35:\*.m4v=01\;35:\*.mp4v=01\;35:\*.vob=01\;35:\*.qt=01\;35:\*.nuv=01\;35:\*.wmv=01\;35:\*.asf=01\;35:\*.rm=01\;35:\*.rmvb=01\;35:\*.flc=01\;35:\*.avi=01\;35:\*.fli=01\;35:\*.flv=01\;35:\*.gl=01\;35:\*.dl=01\;35:\*.xcf=01\;35:\*.xwd=01\;35:\*.yuv=01\;35:\*.cgm=01\;35:\*.emf=01\;35:\*.ogv=01\;35:\*.ogx=01\;35:\*.aac=01\;36:\*.au=01\;36:\*.flac=01\;36:\*.m4a=01\;36:\*.mid=01\;36:\*.midi=01\;36:\*.mka=01\;36:\*.mp3=01\;36:\*.mpc=01\;36:\*.ogg=01\;36:\*.ra=01\;36:\*.wav=01\;36:\*.oga=01\;36:\*.opus=01\;36:\*.spx=01\;36:\*.xspf=01\;36:; export LS_COLORS
SSH_CONNECTION=192.168.100.1\ 58056\ 192.168.100.132\ 22; export SSH_CONNECTION
XDG_SESSION_CLASS=user; export XDG_SESSION_CLASS
SELINUX_ROLE_REQUESTED=; export SELINUX_ROLE_REQUESTED
LESSOPEN=\|\|/usr/bin/lesspipe.sh\ %s; export LESSOPEN
USER=root; export USER
SELINUX_USE_CURRENT_RANGE=; export SELINUX_USE_CURRENT_RANGE
SHLVL=1; export SHLVL
XDG_SESSION_ID=3; export XDG_SESSION_ID
XDG_RUNTIME_DIR=/run/user/0; export XDG_RUNTIME_DIR
SSH_CLIENT=192.168.100.1\ 58056\ 22; export SSH_CLIENT
DEBUGINFOD_URLS=https://debuginfod.centos.org/\ ; export DEBUGINFOD_URLS
which_declare=declare\ -f; export which_declare
PATH=/root/.local/bin:/root/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin; export PATH
SELINUX_LEVEL_REQUESTED=; export SELINUX_LEVEL_REQUESTED
DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/0/bus; export DBUS_SESSION_BUS_ADDRESS
MAIL=/var/spool/mail/root; export MAIL
SSH_TTY=/dev/pts/1; export SSH_TTY
cd /root || {
         echo 'Execution directory inaccessible' >&2
         exit 1
}
${SHELL:-/bin/sh} << 'marcinDELIMITER638f1ec5'
#!/usr/bin/bash
#
USR='student'
OUT='/home/student/output'
#
for SRV in servera serverb
 do
ssh ${USR}@${SRV} "hostname -f" > ${OUT}-${SRV}
echo "#####" >> ${OUT}-${SRV}
ssh ${USR}@${SRV} "lscpu | grep '^CPU'" >> ${OUT}-${SRV}
echo "#####" >> ${OUT}-${SRV}
ssh ${USR}@${SRV} "grep -v '^$' /etc/selinux/config|grep -v '^#'" >> ${OUT}-${SRV}
echo "#####" >> ${OUT}-${SRV}
ssh ${USR}@${SRV} "sudo grep 'Failed password' /var/log/secure" >> ${OUT}-${SRV}
echo "#####" >> ${OUT}-${SRV}
done

marcinDELIMITER638f1ec5
```

Remove Jobs from Schedule

The atrm JOBNUMBER command removes a scheduled job. Remove the scheduled job when you
no longer need it, for example, when a remote firewall configuration succeeded, and you do not
need to reset it

```sh
[root@rocky2 ~]# atq
1       Wed Aug 14 21:03:00 2024 a root
2       Wed Aug 14 21:15:00 2024 a root

[root@rocky2 ~]# atrm 2
[root@rocky2 ~]# atq
1       Wed Aug 14 21:03:00 2024 a root
```

```sh
[student@servera ~]$ echo "date >> /home/student/myjob.txt" | at now +3min
warning: commands will be executed using /bin/sh
job 1 at Mon Apr 4 05:00:00 2022

[root@rocky2 ~]# echo "date >> /home/student/myjob.txt" | at now +3min
warning: commands will be executed using /bin/sh
job 5 at Wed Aug 14 01:53:00 2024
[root@rocky2 ~]# atq
1       Wed Aug 14 21:03:00 2024 a root
3       Thu Aug 15 16:00:00 2024 a root
4       Sun Aug 18 12:00:00 2024 a root
5       Wed Aug 14 01:53:00 2024 a root
```


Interactively schedule a job in the g queue that runs at teatime (16:00). The job should
print the It's teatime message to the /home/student/tea.txt file. Append the new
messages to the /home/student/tea.txt file

```sh
[student@servera ~]$ at -q g teatime
warning: commands will be executed using /bin/sh
at> echo "It's teatime" >> /home/student/tea.txt
at> Ctrl+d
job 2 at Mon Apr 4 16:00:00 2022
```


# Schedule Recurring User Jobs

tekrar eden, düzenlenmesi gereken aksiyonlarda otomatikleştirme ve belli bir plana göre zamanlanmış görev


## Describe Recurring User Jobs

Use the crontab command to manage scheduled jobs. The following list shows the commands
that a local user can use to manage their jobs

Examples of the crontab command

Temelde 4 flag mevcuttur.

| Command | Intended use |
|---------|--------------|
| crontab -l | List the jobs for the current user. |
| crontab -r | Remove all jobs for the current user. |
| crontab -e | Edit jobs for the current user. |
| crontab filename | Remove all jobs, and replace them with those read from filename. This command uses stdin input when no file is specified. |


A privileged user might use the crontab command -u option to manage jobs for another user.
The crontab command is never used to manage system jobs, and using the crontab commands
as the root user is not recommended due to the ability to exploit personal jobs configured to run
as root. Such privileged jobs should be configured as described in the later section describing
recurring system jobs





## Describe User Job Format


The crontab -e command invokes the vim editor by default unless the EDITOR environment
variable is set for another editor. Each job must use a unique line in the crontab file. Follow these
recommendations for valid entries when writing recurring jobs

• Empty lines for ease of reading.

• Comments on lines that start with the number sign (#).

• Environment variables with a NAME=value format, which affects all lines after the line where they are declared.


Standard variable settings include the SHELL variable to declare the shell that is used for
interpreting the remaining lines of the crontab file. The MAILTO variable determines who should
receive the emailed output

The fields in the crontab file appear in the following order:

• Minutes

• Hours

• Day of month

• Month

• Day of week

• Command


The command executes when the Day of the month or Day of the week fields use the same value
other than the * character. For example, to run a command on the 11th day of every month, and
every Friday at 12:15 (24-hour format), use the following job format

```sh
15 12 11 * Fri command
```

The first five fields all use the same syntax rules:

• Use the * character to execute in every possible instance of the field.

• A number to specify the number of minutes or hours, a date, or a day of the week. For days of
the week, 0 equals Sunday, 1 equals Monday, 2 equals Tuesday, and so on. 7 also equals Sunday.

• Use x-y for a range, which includes the x and y values.

• Use x,y for lists. Lists might include ranges as well, for example, 5,10-13,17 in the Minutes
column, for a job to run at 5, 10, 11, 12, 13, and 17 minutes past the hour.

• The */x indicates an interval of x; for example, */7 in the Minutes column runs a job every
seven minutes.



Examples of Recurring User Jobs


```sh
0 9 3 2 * /usr/local/bin/yearly_backup
```

The following job sends an email containing the Chime word to the owner of this job every five
minutes in between and including 9 a.m. and 16 p.m., but only on each Friday in July

```sh
*/5 9-16 * Jul 5 echo "Chime"
```

The following job runs the /usr/local/bin/daily_report command every working day
(Monday to Friday) two minutes before midnight

```sh
58 23 * * 1-5 /usr/local/bin/daily_report
```



The following job executes the mutt command to send the Checking in mail message to the
developer@example.com recipient every working day (Monday to Friday), at 9 AM


```sh
0 9 * * 1-5 mutt -s "Checking in" developer@example.com % Hi there, just checking in.
```

```sh
[student@servera ~]$ crontab -e

# Insert the following line
*/2 * * * Mon-Fri /usr/bin/date >> /home/student/my_first_cron_job.txt



...output omitted...
crontab: installing new crontab
[student@servera ~]$
```


```sh
[student@servera ~]$ crontab -l
*/2 * * * Mon-Fri /usr/bin/date >> /home/student/my_first_cron_job.txt
```


Remove all the scheduled recurring jobs for the student user

```sh
[student@servera ~]$ crontab -r
```

 Verify that no recurring jobs exist for the student user

```sh
[student@servera ~]$ crontab -l
no crontab for student
```


##Crontab

![alt text](image.png)



https://crontab.guru/
![alt text](image-1.png)


Lab 44 --> 45