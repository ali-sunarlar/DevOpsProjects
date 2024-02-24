default olarak burda bulunur.
/etc/ansible/hosts

farkli bir dosya veya path asagidaki parametre ile belirlenir.
-i

Ayni anda birden fazla invertory dosyasi kullanilabilir.

Bir client birden fazla gruplandirmada kullanilabilir

[dbservers]
deneme1.local
deneme2.local
test.local

[webservers]
web1.local
we2.local
test.local

# Gruplandirma
# What
# Where
# When


[logserver]

[monitoring]

[mailservers]


deneme4 ansible_connection=ssh ansible_user=ansible
192.168.1.100 test2.local ansible_user=ansible


rose ansible_port=99 ansible_host=192.168.1.100 


:children

[testservers]
test3.local
test4.local

[prodservers]
prod3.local
prod4.local

[environments:children]
testservers
prodservers

[environments:vars]
timeout=60

[project:children]
environments
requirements




ansible-playbook log-playbook.yaml -i prodservers -i testservers

ansible_host
ansible_connection
ansible_port
ansible_user
ansible_password
ansible_ssh_private_key_file
ansible_become # sudo yetkisi


localhost
