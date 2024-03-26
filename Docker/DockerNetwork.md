Bridge Network --> Bu network modelinde Host sunucu ile container'lar arasinda ozel bir ag olusturulur

Host Network --> Host sunucunun networku dogrudan container'ların network'ü eşleştirilir.

None Network --> Network dahil edilmeden tekil olarak calisacak container'lara atanir.

Overlay --> Birden fazla hostlarin haberlesmesinde kullanilmaktadir.

MACVLAN --> Container icerisine MAC address atamasi yapilir. Docker MAC adreslerine göre yönlendirme yapmaktadir. Doğrudan fiziksel ağ bağlanması gereken durumlarda kullanilir.



--driver driver modeli secilir. Bridge tüm network birbirleriyle konuştuğu network modeldir.

```sh
root@ubuntu2:~# docker network create --driver bridge sw0-network
42c5437377a8a6a6ad666a586cf5c3f76290008a17b75a5a7f1b8dd2c200fb04
```
listeleme

```sh
root@ubuntu2:~# docker network ls
NETWORK ID     NAME              DRIVER    SCOPE
a0ae22b7047b   bridge            bridge    local
e2b81baf2605   host              host      local
0a7e832b304d   mybridgenetwork   bridge    local
64579b02f2e9   mynetwork         bridge    local
bde5689c3352   none              null      local
42c5437377a8   sw0-network       bridge    local
```

detaylarına bakma.  

```sh
root@ubuntu2:~# docker network inspect sw0-network
[
    {
        "Name": "sw0-network",
        "Id": "42c5437377a8a6a6ad666a586cf5c3f76290008a17b75a5a7f1b8dd2c200fb04",
        "Created": "2024-03-24T12:30:52.761997981Z",
        "Scope": "local",
        "Driver": "bridge",
        "EnableIPv6": false,
        "IPAM": {
            "Driver": "default",
            "Options": {},
            "Config": [
                {
                    #default olarak subnet atanmış durumda
                    "Subnet": "172.19.0.0/16",
                    "Gateway": "172.19.0.1"
                }
            ]
        },
        "Internal": false,
        "Attachable": false,
        "Ingress": false,
        "ConfigFrom": {
            "Network": ""
        },
        "ConfigOnly": false,
        #herhangi bir container bağlanmamış durumdadır
        "Containers": {},
        "Options": {},
        "Labels": {}
    }
]
```

oluşturulan network'e container oluşturma.30 dakika boyunca ayakta tutmak icin sleep 30m parametresi verilmistir.

```sh
root@ubuntu2:~# docker container run -d --name cont-test-1 --network sw0-network alpine sleep 30m
Unable to find image 'alpine:latest' locally
latest: Pulling from library/alpine
4abcf2066143: Pull complete
Digest: sha256:c5b1261d6d3e43071626931fc004f70149baeba2c8ec672bd4f27761f8e1ad6b
Status: Downloaded newer image for alpine:latest
03400de4a399f4ac953f32b415dd0460ee557aaefe1b5f9954248ba0f9ead8ee
```

inspect ile kontrol ettiğimizde cont-test-1 container'ın network'üne bağlandığını görebiliriz.

```sh
root@ubuntu2:~# docker network inspect sw0-network
[
    {
        "Name": "sw0-network",
        "Id": "42c5437377a8a6a6ad666a586cf5c3f76290008a17b75a5a7f1b8dd2c200fb04",
.
.
.
        "ConfigOnly": false,
        "Containers": {
            "03400de4a399f4ac953f32b415dd0460ee557aaefe1b5f9954248ba0f9ead8ee": {
                "Name": "cont-test-1",
                "EndpointID": "61a92430cbe7ea2ae1e33b2d35e06f5107db55ebcfff48aa0f37c7c6f05d535a",
                "MacAddress": "02:42:ac:13:00:02",
                "IPv4Address": "172.19.0.2/16",
                "IPv6Address": ""
            }
        },
        "Options": {},
        "Labels": {}
    }
]
```

yeni bir docker networkü oluşturduk

```sh
root@ubuntu2:~# docker network create --driver bridge sw1-network
bc9297a0e34fb969830d6f570830861cf49e0ab28978fef01d615ef8c6b187e5
root@ubuntu2:~# docker network ls
NETWORK ID     NAME              DRIVER    SCOPE
a0ae22b7047b   bridge            bridge    local
e2b81baf2605   host              host      local
0a7e832b304d   mybridgenetwork   bridge    local
64579b02f2e9   mynetwork         bridge    local
bde5689c3352   none              null      local
42c5437377a8   sw0-network       bridge    local
bc9297a0e34f   sw1-network       bridge    local
```

yeni oluşturduğumuz network container eklediğimiz hem sw1-network hem de sw0-network networkünde ip aldığını görebiliriz.

```sh
root@ubuntu2:~# docker network connect sw1-network cont-test-1
root@ubuntu2:~# docker container inspect cont-test-1
[
    {
        "Id": "03400de4a399f4ac953f32b415dd0460ee557aaefe1b5f9954248ba0f9ead8ee",
        "Created": "2024-03-24T12:37:41.296456567Z",
        "Path": "sleep",
        "Args": [
            "30m"
        ],
        "State": {
            "Status": "running",
.
.
.
            "Networks": {
                "sw0-network": {
                    "IPAMConfig": null,
                    "Links": null,
                    "Aliases": [
                        "03400de4a399"
                    ],
                    "NetworkID": "42c5437377a8a6a6ad666a586cf5c3f76290008a17b75a5a7f1b8dd2c200fb04",
                    "EndpointID": "61a92430cbe7ea2ae1e33b2d35e06f5107db55ebcfff48aa0f37c7c6f05d535a",
                    "Gateway": "172.19.0.1",
                    "IPAddress": "172.19.0.2",
                    "IPPrefixLen": 16,
                    "IPv6Gateway": "",
                    "GlobalIPv6Address": "",
                    "GlobalIPv6PrefixLen": 0,
                    "MacAddress": "02:42:ac:13:00:02",
                    "DriverOpts": null
                },
                "sw1-network": {
                    "IPAMConfig": {},
                    "Links": null,
                    "Aliases": [
                        "03400de4a399"
                    ],
                    "NetworkID": "bc9297a0e34fb969830d6f570830861cf49e0ab28978fef01d615ef8c6b187e5",
                    "EndpointID": "9adcf41b3688d89fb22d1338a4338eece648a2542d52cbefd18ed05a6e153254",
                    "Gateway": "172.20.0.1",
                    "IPAddress": "172.20.0.2",
                    "IPPrefixLen": 16,
                    "IPv6Gateway": "",
                    "GlobalIPv6Address": "",
                    "GlobalIPv6PrefixLen": 0,
                    "MacAddress": "02:42:ac:14:00:02",
                    "DriverOpts": {}
                }
            }
        }
    }
]
```

bağlı container varsa networkü silemeyiz. disconnect yapıp silebiliriz
```sh
root@ubuntu2:~# docker network rm sw0-network
Error response from daemon: error while removing network: network sw0-network id 42c5437377a8a6a6ad666a586cf5c3f76290008a17b75a5a7f1b8dd2c200fb04 has active endpoints
root@ubuntu2:~# docker network disconnect sw0-network cont-test-1
root@ubuntu2:~# docker network rm sw0-network
sw0-network
root@ubuntu2:~# docker network ls
NETWORK ID     NAME              DRIVER    SCOPE
a0ae22b7047b   bridge            bridge    local
e2b81baf2605   host              host      local
0a7e832b304d   mybridgenetwork   bridge    local
64579b02f2e9   mynetwork         bridge    local
bde5689c3352   none              null      local
bc9297a0e34f   sw1-network       bridge    local
```
