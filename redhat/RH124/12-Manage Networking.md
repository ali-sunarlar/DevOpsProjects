# Validate Network Configuration


## Gather Network Interface Information


The ip link command lists all available network interfaces on your system. In the following
example, the server has three network interfaces: lo, which is the loopback device that is
connected to the server itself, and two Ethernet interfaces, ens3 and ens4.

```sh
[user@host ~]$ ip link show
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT
 group default qlen 1000
 link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: ens3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP mode DEFAULT
 group default qlen 1000
 link/ether 52:54:00:00:00:0a brd ff:ff:ff:ff:ff:ff
3: ens4: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP mode DEFAULT
 group default qlen 1000
 link/ether 52:54:00:00:00:1e brd ff:ff:ff:ff:ff:ff

 [root@rocky2 ~]# ip link show
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: ens160: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP mode DEFAULT group default qlen 1000
    link/ether 00:0c:29:47:d9:6a brd ff:ff:ff:ff:ff:ff
    altname enp3s0
```

Display IP Addresses

Use the ip command to view device and address information. A single network interface can have
multiple IPv4 or IPv6 addresses.

```sh
[user@host ~]$ ip addr show ens3
#An active interface is UP.
2: ens3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP qlen 1000
#The link/ether string specifies the hardware (MAC) address of the device.
 link/ether 52:54:00:00:00:0b brd ff:ff:ff:ff:ff:ff
 #The inet string shows an IPv4 address, its network prefix length, and scope.
 inet 192.0.2.2/24 brd 192.0.2.255 scope global ens3
 valid_lft forever preferred_lft forever
 #The inet6 string shows an IPv6 address, its network prefix length, and scope. This address is of global scope and is normally used.
 inet6 2001:db8:0:1:5054:ff:fe00:b/64 scope global
 valid_lft forever preferred_lft forever
 #This inet6 string shows that the interface has an IPv6 address of link scope that can be used only for communication on the local Ethernet link.
 inet6 fe80::5054:ff:fe00:b/64 scope link
 valid_lft forever preferred_lft forever
```

Display Performance Statistics

The ip command can also show statistics about network performance. Counters for each network
interface can identify the presence of network issues. The counters record statistics, such as for
the number of received (RX) and transmitted (TX) packets, packet errors, and dropped packets.

```sh
[root@rocky2 ~]# ip -s link show ens160
2: ens160: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP mode DEFAULT group default qlen 1000
    link/ether 00:0c:29:47:d9:6a brd ff:ff:ff:ff:ff:ff
    RX:  bytes packets errors dropped  missed   mcast
       9423717   10841      0       0       0       0
    TX:  bytes packets errors dropped carrier collsns
       2219746    6639      0       0       0       0
    altname enp3s0
```

## Verify Connectivity Between Hosts

The ping command tests connectivity.

```sh
[user@host ~]$ ping -c3 192.0.2.254
PING 192.0.2.1 (192.0.2.254) 56(84) bytes of data.
64 bytes from 192.0.2.254: icmp_seq=1 ttl=64 time=4.33 ms
64 bytes from 192.0.2.254: icmp_seq=2 ttl=64 time=3.48 ms
64 bytes from 192.0.2.254: icmp_seq=3 ttl=64 time=6.83 ms
--- 192.0.2.254 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2003ms
rtt min/avg/max/mdev = 3.485/4.885/6.837/1.424 ms
```

The ping6 command is the IPv6 version of the ping command in Red Hat Enterprise Linux. The
difference between these commands is that the ping6 command communicates over IPv6 and
takes IPv6 addresses.

```sh
[user@host ~]$ ping6 2001:db8:0:1::1
PING 2001:db8:0:1::1(2001:db8:0:1::1) 56 data bytes
64 bytes from 2001:db8:0:1::1: icmp_seq=1 ttl=64 time=18.4 ms
64 bytes from 2001:db8:0:1::1: icmp_seq=2 ttl=64 time=0.178 ms
64 bytes from 2001:db8:0:1::1: icmp_seq=3 ttl=64 time=0.180 ms
^C
--- 2001:db8:0:1::1 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2001ms
rtt min/avg/max/mdev = 0.178/6.272/18.458/8.616 ms
```

## Troubleshoot Router Issues

Describe the Routing Table

```sh
[root@rocky2 ~]# ip route
default via 192.168.100.2 dev ens160 proto dhcp src 192.168.100.132 metric 100
192.168.100.0/24 dev ens160 proto kernel scope link src 192.168.100.132 metric 100
```



```sh
[user@host ~]$ ip -6 route
unreachable ::/96 dev lo metric 1024 error -101
unreachable ::ffff:0.0.0.0/96 dev lo metric 1024 error -101
#network uses the ens3 interface (which presumably has an address on that network).
2001:db8:0:1::/64 dev ens3 proto kernel metric 256
unreachable 2002:a00::/24 dev lo metric 1024 error -101
unreachable 2002:7f00::/24 dev lo metric 1024 error -101
unreachable 2002:a9fe::/32 dev lo metric 1024 error -101
unreachable 2002:ac10::/28 dev lo metric 1024 error -101
unreachable 2002:c0a8::/32 dev lo metric 1024 error -101
unreachable 2002:e000::/19 dev lo metric 1024 error -101
unreachable 3ffe:ffff::/32 dev lo metric 1024 error -101
#The fe80::/64 network uses the ens3 interface, for the link-local address. On a system with multiple interfaces, a route to the fe80::/64 network exists in each interface for each link-local address.
fe80::/64 dev ens3 proto kernel metric 256
#The default route to all networks on the IPv6 Internet (the ::/0 network) uses the router at the 2001:db8:0:1::ffff network and it is reachable with the ens3 device
default via 2001:db8:0:1::ffff dev ens3 proto static metric 1024


[root@rocky2 ~]# ip -6 route
::1 dev lo proto kernel metric 256 pref medium
fe80::/64 dev ens160 proto kernel metric 1024 pref medium
```


Trace Traffic Routes

```sh
[user@host ~]$ tracepath access.redhat.com
...output omitted...
 4: 71-32-28-145.rcmt.qwest.net 48.853ms asymm 5
 5: dcp-brdr-04.inet.qwest.net 100.732ms asymm 7
 6: 206.111.0.153.ptr.us.xo.net 96.245ms asymm 7
 7: 207.88.14.162.ptr.us.xo.net 85.270ms asymm 8
 8: ae1d0.cir1.atlanta6-ga.us.xo.net 64.160ms asymm 7
 9: 216.156.108.98.ptr.us.xo.net 108.652ms
10: bu-ether13.atlngamq46w-bcr00.tbone.rr.com 107.286ms asymm 12
...output omitted...
```

The tracepath6 and traceroute -6 commands are the equivalent IPv6 commands to the
tracepath and traceroute commands.

```sh
[user@host ~]$ tracepath6 2001:db8:0:2::451
 1?: [LOCALHOST] 0.091ms pmtu 1500
 1: 2001:db8:0:1::ba 0.214ms
 2: 2001:db8:0:1::1 0.512ms
 3: 2001:db8:0:2::451 0.559ms reached
 Resume: pmtu 1500 hops 3 back 3
```


## Troubleshoot Port and Service Issues



The ss command is used to display socket statistics. The ss command replaces the older
netstat tool, from the net-tools package, which might be more familiar to some system
administrators but is not always installed.



```sh
[user@host ~]$ ss -ta
State Recv-Q Send-Q Local Address:Port Peer Address:Port
LISTEN 0 128 *:sunrpc *:*
#*:ssh : The port that is used for SSH is listening on all IPv4 addresses. The asterisk (*) character represents all when referencing IPv4 addresses or ports.
LISTEN 0 128 *:ssh *:*
#127.0.0.1:smtp : The port that is used for SMTP is listening on the 127.0.0.1 IPv4 loopback interface.
LISTEN 0 100 127.0.0.1:smtp :
LISTEN 0 128 *:36889 *:*
#172.25.250.10:ssh : The established SSH connection is on the 172.25.250.10 interface and originates from a system with an address of 172.25.254.254.
ESTAB 0 0 172.25.250.10:ssh 172.25.254.254:59392
LISTEN 0 128 :::sunrpc :::*
#:::ssh : The port that is used for SSH is listening on all IPv6 addresses. The double colon (::) syntax represents all IPv6 interfaces.
LISTEN 0 128 :::ssh :::*
#::1:smtp : The port that is used for SMTP is listening on the ::1 IPv6 loopback interface.
LISTEN 0 100 ::1:smtp :::*
LISTEN 0 128 :::34946 :::*

```

Options for ss and netstat

| Option | Description |
|--------|-------------|
| -n | Show numbers instead of names for interfaces and ports. |
| -t | Show TCP sockets. |
| -u | Show UDP sockets. |
| -l | Show only listening sockets. |
| -a | Show all (listening and established) sockets. |
| -p | Show the process that uses the sockets. |
| -A | inet Display active connections (but not listening sockets) for the inet address family. That is, ignore local UNIX domain sockets. For the ss command, both IPv4 and IPv6 connections are displayed. For the netstat command, only IPv4 connections are displayed. (The netstat -A inet6 command displays IPv6 connections, and the netstat -46 command displays IPv4 and IPv6 at the same time.) |





