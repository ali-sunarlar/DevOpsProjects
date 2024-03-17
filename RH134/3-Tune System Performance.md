# Tune System Performance

## Adjust Tuning Profiles


Tuning profile Tune Performance

Optimizasyon yapmak için ön ayarlarda aksiyon almamızı sağlar. Sistem performansı artırılmak istenebilir. Bir uygulamanın veya bir kullanım senaryosuna göre bazı aksiyonların alınması gerekirse tune performance profilleri devreye girer.

Değiştirmemiz ve düzenlememiz gerektirdiği durumlar olabilir.

Yapının çalışmanın altyapıya göre değişiklik yapılması gerekebilir(VM veya Fiziksel sunucularda)

Genellikle fiziksel katmanda güncelleme yapılabilir. Sanal katmanda çok kullanılmaz

Statik tuning -->Sistemin veya uygulamanın performance optimize edebilmek için sabit tanımlamalar. Stabil şekilde yönetimi kolaylaştırır. Sistem gereksinimine göre değişmez(Sistem gereksinimlerine göre belirlenir.) dezavantajı sistem performans değiştiğinde uyumlu hale gelmez

Dinamik tuning --> CPU, Memory, Disk IO, network yük artıkca ve azaldıkça otomatik belirlenir. 


• disk: Monitors the disk load based on the number of IO operations for every disk device.

• net: Monitors the network load based on the number of transferred packets per network card.

• load: Monitors the CPU load for every CPU.


• disk: Sets different disk parameters, for example, the disk scheduler, the spin-down timeout, or
the advanced power management.
• net: Configures the interface speed and the Wake-on-LAN (WoL) functionality.
• cpu: Sets different CPU parameters, for example, the CPU governor or the latency

Dynamic tuning default'da disable durumdadır. /etc/tuned/tuned-main.conf dosyasindaki dynamic_tuning değeri 1 yapılır.

tune yapılandırma dosyasi
```
[root@rocky2 user]# cat /etc/tuned/tuned-main.conf
cat: /etc/tuned/tuned-main.conf: No such file or directory
[root@rocky2 user]# yum -y install tuned
#kurulması gerekmektedir.
[root@rocky2 user]# cat /etc/tuned/tuned-main.conf
# Global tuned configuration file.

# Whether to use daemon. Without daemon it just applies tuning. It is
# not recommended, because many functions don't work without daemon,
# e.g. there will be no D-Bus, no rollback of settings, no hotplug,
# no dynamic tuning, ...
daemon = 1

# Dynamicaly tune devices, if disabled only static tuning will be used.
dynamic_tuning = 0

# How long to sleep before checking for events (in seconds)
# higher number means lower overhead but longer response time.
sleep_interval = 1

# Update interval for dynamic tunings (in seconds).
# It must be multiply of the sleep_interval.
update_interval = 10
.
.
.


```

## The tuned Utility

performance boosting, powersaving profilleri 

The tuned application provides profiles in the following categories:

• Power-saving profiles

• Performance-boosting profiles


The performance-boosting profiles include profiles that focus on the following aspects:

• Low latency for storage and network

• High throughput for storage and network

• Virtual machine performance

• Virtualization host performance


 tuning profiles distributed with Red Hat Enterprise Linux 9

| Tuned Profile | Purpose   |
|--|--|
| balanced | Ideal for systems that require a compromise between power saving and performance. |
| powersave | Tunes the system for maximum power saving. |
| throughput-performance | Tunes the system for maximum throughput. |
| accelerator-performance | Tunes the same as throughput-performance, and also reduces the latency to less than 100 μs. |
| latency-performance | Ideal for server systems that require low latency at the expense of power consumption. |
| network-throughput | Derived from the throughput-performance profile. Additional network tuning parameters are applied for maximum network throughput. |
| network-latency | Derived from the latency-performance profile. Enables additional network tuning parameters to provide low network latency. |
| desktop | Derived from the balanced profile. Provides faster response of interactive applications. |
| hpc-compute | Derived from the latency-performance profile. Ideal for high-performance computing. |
| virtual-guest | Tunes the system for maximum performance if it runs on a virtual machine. |
| virtual-host | Tunes the system for maximum performance if it acts as a host for virtual machines. |
| intel-sst  | Optimized for systems with Intel Speed Select Technology configurations. Use it as an overlay on other profiles. |
| optimize-serial-console | Increases responsiveness of the serial console. Use it as an overlay on other profiles. |