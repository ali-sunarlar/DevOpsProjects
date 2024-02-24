Ansible [pattern] -n  [module] -a  "[module options]"

ansible -m ping all

ansible all -a "/sbin{reboot}"

ansible -m ping dbservers

## f parametresi fork değeri 10'lu sunuculara bağlanir. Kaynak tuketimini artirir.
ansible -m ping all -f 10 -u ansible_user

## -u parametresi farkli kullanici ile calistirir.

## yetkili islemler icin root gecisi
ansible -m ping all -f 10 -u ansible_user --become -K -ask-become-pass

ansible all -m shell -a "echo Hello World"

## dosya kopyalama
ansible nodes -m ansible.builtin.copy -a "src=/etc/hosts dest=/tmp/hosts"
ansible nodes -m copy -a "dest=/tmp/devops.txt src=/tmp/devops.txt"

## absent silme icin kullanilir.
ansible all -m file -a "dest=/tmp/devops.txt state=absent"

## klasor kopyalama
ansible all -m copy -a "src=/tmp/devops dest=/opt/devops"

## farkli bir yetkilendirme kullanarak
ansible nodes -m file -a "dest=/opt/devops3 mode=777 state=directory"

## farkli bir grup ve owner vererek kopyalama
ansible nodes -m file -a "dest=/opt/devops3 owner=ansible mode=777 group=daemon state=directory"



## present yoksa kurar varsa hiçbir şey yapmaz
ansible all -m yum -a "name=nano state=present"
ansible all -m ansible.builtin.yum -a "name=nano state=present"

## state'ler
## present şuanki
## latest son versiyon
## absent silme
## installed yuklemek icin
## removed kaldirmak icin

ansible all -m ansible.builtin.yum -a "name=nano state=removed"
ansible all -m yum -a "name=nano state=removed"
ansible all -m yum -a "name=nano state=installed"



ansible nodes -m user -a "name=ansible_user state=present"
ansible nodes -m ansible.builtin.user -a "name=ansible_user state=present"

## home dizini farkli path veriliyor
ansible nodes -m ansible.builtin.user -a "name=devops state=present group=daemon home=/tmp/devops"

ansible all -m group -a "name=nodes state=present"
ansible nodes -m user -a "name=nodes10 group=node createhome=yes"


ansible nodes -m service -a "name=firewalld state=started"
ansible nodes -m ansible.builtin.services -a "name=firewalld state=stopped"

started
stopped
restarted
reloaded
enabled=yes
enabled=nodes
force=yes
force=no

ansible nodes -m service -a "name=firewalld state=stopped enabled=no"

ansible nodes -m yum -a "name=httpd state=installed"
ansible nodes -m yum -a "name=httpd state=removed"

ansible nodes -m yum -a "name=* state=latest"
ansible nodes -m yum -a "name='@Development tools' state=latest"

ansible [-i INVERTORY] [server] -m yum -a "name=<pkg> state=<present/latest/installed/absent/removed>"



ansible all -m shell -a "command"
ansible [server] -m shell -a "command"
ansible -m shell -a "command" all

ansible -m shell -a 'df -h' nodes
ansible -m shell -a 'free -m' nodes
ansible -m shell -a 'du -m *' nodes
ansible -m shell -a 'du -ms *' nodes
ansible -m shell -a 'echo $PATH' nodes
ANSİBLE nodes -m shell -a 'yum install httpd -y'
ansible -m shell -a 'echo $ROOT' nodes
ansible -m shell -a 'cat /proc/meminfo/head -2' nodes
ansible all -m shell -a "grep -in ServerName /etc/httpd/conf/httpd.conf"
ansible all -m shell -a uptime
ansible all -m shell -a "netstat -tnlp"
ansible all -m shell -a "uname -a"
ansible all -m shell -a "ls /opt"
ansible all -m shell -a "rm -f /opt/devops"
ansible all -m shell -a "touch /tmp/devops"
ansible all -m shell -a "/bin/hostnamectl --static"
ansible nodes a "mkdir -p /root/deneme"




