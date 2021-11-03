     3.5. Файловые системы
	 
1. Узнайте о sparse (разряженных) файлах.
   ``` 
       Прочитал, осознал.
   ```
2. Могут ли файлы, являющиеся жесткой ссылкой на один объект, иметь разные права доступа и владельца? Почему?
   ```   
   Жесткие ссылки не могут иметь различные права доступа т.к. по сути жесткая ссылка - псевдоним файла и права доступа к ссылке определяются правами доступа к файлу.
   ```
3. Сделайте vagrant destroy на имеющийся инстанс Ubuntu.
   ```
         lsblk
         NAME                 MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
         sda                    8:0    0   64G  0 disk 
         тФЬтФАsda1                 8:1    0  512M  0 part /boot/efi
         тФЬтФАsda2                 8:2    0    1K  0 part 
         тФФтФАsda5                 8:5    0 63.5G  0 part 
           тФЬтФАvgvagrant-root   253:0    0 62.6G  0 lvm  /
           тФФтФАvgvagrant-swap_1 253:1    0  980M  0 lvm  [SWAP]
         sdb                    8:16   0  2.5G  0 disk 
         sdc                    8:32   0  2.5G  0 disk
   ```
4. Используя fdisk, разбейте первый диск на 2 раздела: 2 Гб, оставшееся пространство.
    ````  
         fdisk /dev/sdb
         lsblk
         NAME                 MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
         sda                    8:0    0   64G  0 disk 
         тФЬтФАsda1                 8:1    0  512M  0 part /boot/efi
         тФЬтФАsda2                 8:2    0    1K  0 part 
         тФФтФАsda5                 8:5    0 63.5G  0 part 
           тФЬтФАvgvagrant-root   253:0    0 62.6G  0 lvm  /
           тФФтФАvgvagrant-swap_1 253:1    0  980M  0 lvm  [SWAP]
         sdb                    8:16   0  2.5G  0 disk 
         тФЬтФАsdb1                 8:17   0    2G  0 part 
         тФФтФАsdb2                 8:18   0  511M  0 part 
         sdc                    8:32   0  2.5G  0 disk 
    ````
5. Используя sfdisk, перенесите данную таблицу разделов на второй диск.
    ```    
         sfdisk -d /dev/sdb | sfdisk /dev/sdc
         lsblk
         NAME                 MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
         sda                    8:0    0   64G  0 disk 
         тФЬтФАsda1                 8:1    0  512M  0 part /boot/efi
         тФЬтФАsda2                 8:2    0    1K  0 part 
         тФФтФАsda5                 8:5    0 63.5G  0 part 
           тФЬтФАvgvagrant-root   253:0    0 62.6G  0 lvm  /
           тФФтФАvgvagrant-swap_1 253:1    0  980M  0 lvm  [SWAP]
         sdb                    8:16   0  2.5G  0 disk 
         тФЬтФАsdb1                 8:17   0    2G  0 part 
         тФФтФАsdb2                 8:18   0  511M  0 part 
         sdc                    8:32   0  2.5G  0 disk 
         тФЬтФАsdc1                 8:33   0    2G  0 part 
         тФФтФАsdc2                 8:34   0  511M  0 part 
	```
6. Соберите mdadm RAID1 на паре разделов 2 Гб.
    ```     
         mdadm --create --verbose /dev/md0 --level=1 --raid-devices=2 /dev/sdb1 /dev/sdc1
         cat /proc/mdstat
         Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10] 
         md0 : active raid1 sdc1[1] sdb1[0]
               2094080 blocks super 1.2 [2/2] [UU]
	```
7. Соберите mdadm RAID0 на второй паре маленьких разделов.
    ```     
         mdadm --create --verbose /dev/md1 --level=0 --raid-devices=2 /dev/sdb2 /dev/sdc2
         cat /proc/mdstat
         Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10] 
         md1 : active raid0 sdc2[1] sdb2[0]
               1042432 blocks super 1.2 512k chunks
      
         md0 : active raid1 sdc1[1] sdb1[0]
               2094080 blocks super 1.2 [2/2] [UU]
      
         unused devices: <none>
	```
8. Создайте 2 независимых PV на получившихся md-устройствах.
    ```   
         pvcreate /dev/md0
         pvcreate /dev/md1
         pvdisplay
         --- Physical volume ---
         PV Name               /dev/sda5
         VG Name               vgvagrant
         PV Size               <63.50 GiB / not usable 0   
         Allocatable           yes (but full)
         PE Size               4.00 MiB
         Total PE              16255
         Free PE               0
         Allocated PE          16255
         PV UUID               Mx3LcA-uMnN-h9yB-gC2w-qm7w-skx0-OsTz9z
   
         "/dev/md0" is a new physical volume of "<2.00 GiB"
         --- NEW Physical volume ---
         PV Name               /dev/md0
         VG Name               
         PV Size               <2.00 GiB
         Allocatable           NO
         PE Size               0   
         Total PE              0
         Free PE               0
         Allocated PE          0
         PV UUID               OCqVcq-89zb-taPA-io5u-mraB-3zot-8XZEsU
   
         "/dev/md1" is a new physical volume of "1018.00 MiB"
         --- NEW Physical volume ---
         PV Name               /dev/md1
         VG Name               
         PV Size               1018.00 MiB
         Allocatable           NO
         PE Size               0   
         Total PE              0
         Free PE               0
         Allocated PE          0
         PV UUID               VNecoA-YEnI-vE2v-XeTC-qgQQ-7uMM-dcBQzy
	 ``` 
9. Создайте общую volume-group на этих двух PV.
    ```
         vgcreate VG --addtag TEST_VG /dev/md0 /dev/md1
		 
         vgdisplay
         --- Volume group ---
         VG Name               VG
         System ID             
         Format                lvm2
         Metadata Areas        2
         Metadata Sequence No  1
         VG Access             read/write
         VG Status             resizable
         MAX LV                0
         Cur LV                0
         Open LV               0
         Max PV                0
         Cur PV                2
         Act PV                2
         VG Size               <2.99 GiB
         PE Size               4.00 MiB
         Total PE              765
         Alloc PE / Size       0 / 0   
         Free  PE / Size       765 / <2.99 GiB
         VG UUID               jDGUAE-iT64-CftR-Eevc-fJP2-wihe-n04mcE
    ```
10. Создайте LV размером 100 Мб, указав его расположение на PV с RAID0.
    ```
         lvcreate -L 100M VG /dev/md1
         Logical volume "lvol0" created.
         lvs
         LV     VG        Attr       LSize   Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
         lvol0  TEST_VG   -wi-a----- 100.00m                                                    
         root   vgvagrant -wi-ao---- <62.54g                                                    
         swap_1 vgvagrant -wi-ao---- 980.00m
	```
11. Создайте mkfs.ext4 ФС на получившемся LV
     ```
         mkfs.ext4 /dev/VG/lvol0
         blkid /dev/VG/lvol0
         /dev/VG/lvol0: UUID="feabbdd2-658e-4ef2-8d82-f23e56ccd0eb" TYPE="ext4"
	```
12. Смонтируйте этот раздел в любую директорию, например, /tmp/new
    ```
         mkdir /tmp/new
         mount /dev/VG/lvol0 /tmp/new/
         df -h
         Filesystem                  Size  Used Avail Use% Mounted on
         udev                        447M     0  447M   0% /dev
         tmpfs                        99M  700K   98M   1% /run
         /dev/mapper/vgvagrant-root   62G  1.5G   57G   3% /
         tmpfs                       491M     0  491M   0% /dev/shm
         tmpfs                       5.0M     0  5.0M   0% /run/lock
         tmpfs                       491M     0  491M   0% /sys/fs/cgroup
         /dev/sda1                   511M  4.0K  511M   1% /boot/efi
         vagrant                     112G   77G   36G  69% /vagrant
         tmpfs                        99M     0   99M   0% /run/user/1000
         /dev/mapper/VG-lvol0         93M   72K   86M   1% /tmp/new
	```
13. Поместите туда тестовый файл, например wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz.
    ```
         ls /tmp/new
         lost+found
         test.gz
	```
14. Прикрепите вывод lsblk
    ```
         lsblk
         NAME                 MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
         sda                    8:0    0   64G  0 disk  
         тФЬтФАsda1                 8:1    0  512M  0 part  /boot/efi
         тФЬтФАsda2                 8:2    0    1K  0 part  
         тФФтФАsda5                 8:5    0 63.5G  0 part  
           тФЬтФАvgvagrant-root   253:0    0 62.6G  0 lvm   /
           тФФтФАvgvagrant-swap_1 253:1    0  980M  0 lvm   [SWAP]
         sdb                    8:16   0  2.5G  0 disk  
         тФЬтФАsdb1                 8:17   0    2G  0 part  
         тФВ тФФтФАmd0                9:0    0    2G  0 raid1 
         тФФтФАsdb2                 8:18   0  511M  0 part  
           тФФтФАmd1                9:1    0 1018M  0 raid0 
             тФФтФАVG-lvol0       253:2    0  100M  0 lvm   /tmp/new
         sdc                    8:32   0  2.5G  0 disk  
         тФЬтФАsdc1                 8:33   0    2G  0 part  
         тФВ тФФтФАmd0                9:0    0    2G  0 raid1 
         тФФтФАsdc2                 8:34   0  511M  0 part  
           тФФтФАmd1                9:1    0 1018M  0 raid0 
             тФФтФАVG-lvol0       253:2    0  100M  0 lvm   /tmp/new
	``` 
15. Протестируйте целостность файла:
    ```  
         gzip -t /tmp/new/test.gz
         echo $?
         0
	```
16. Используя pvmove, переместите содержимое PV с RAID0 на RAID1
    ```
         pvmove /dev/md1
         lsblk
         NAME                 MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
         sda                    8:0    0   64G  0 disk  
         тФЬтФАsda1                 8:1    0  512M  0 part  /boot/efi
         тФЬтФАsda2                 8:2    0    1K  0 part  
         тФФтФАsda5                 8:5    0 63.5G  0 part  
         тФЬтФАvgvagrant-root   253:0    0 62.6G  0 lvm   /
         тФФтФАvgvagrant-swap_1 253:1    0  980M  0 lvm   [SWAP]
         sdb                    8:16   0  2.5G  0 disk  
         тФЬтФАsdb1                 8:17   0    2G  0 part  
         тФВ тФФтФАmd0                9:0    0    2G  0 raid1 
         тФВ   тФФтФАVG-lvol0       253:2    0  100M  0 lvm   /tmp/new
         тФФтФАsdb2                 8:18   0  511M  0 part  
           тФФтФАmd1                9:1    0 1018M  0 raid0 
         sdc                    8:32   0  2.5G  0 disk  
         тФЬтФАsdc1                 8:33   0    2G  0 part  
         тФВ тФФтФАmd0                9:0    0    2G  0 raid1 
         тФВ   тФФтФАVG-lvol0       253:2    0  100M  0 lvm   /tmp/new
         тФФтФАsdc2                 8:34   0  511M  0 part  
           тФФтФАmd1                9:1    0 1018M  0 raid0 
	```
17. Сделайте --fail на устройство в вашем RAID1 md.
    ```
         mdadm --manage /dev/md0 --fail /dev/sdc1
         mdadm: set /dev/sdc1 faulty in /dev/md0
         cat /proc/mdstat
         Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10] 
         md1 : active raid0 sdc2[1] sdb2[0]
               1042432 blocks super 1.2 512k chunks
      
         md0 : active raid1 sdc1[1](F) sdb1[0]
               2094080 blocks super 1.2 [2/1] [U_]
      
         unused devices: <none>
	```
18. Подтвердите выводом dmesg, что RAID1 работает в деградированном состоянии.
    ```    
         dmesg | grep raid	
         [    3.458877] raid6: sse2x4   gen()  6873 MB/s
         [    3.506816] raid6: sse2x4   xor()  3728 MB/s
         [    3.554824] raid6: sse2x2   gen()  4061 MB/s
         [    3.602831] raid6: sse2x2   xor()  2659 MB/s
         [    3.650820] raid6: sse2x1   gen()  1886 MB/s
         [    3.698864] raid6: sse2x1   xor()  1623 MB/s
         [    3.698866] raid6: using algorithm sse2x4 gen() 6873 MB/s
         [    3.698868] raid6: .... xor() 3728 MB/s, rmw enabled
         [    3.698870] raid6: using ssse3x2 recovery algorithm
         [  295.894943] md/raid1:md0: not clean -- starting background reconstruction
         [  295.894946] md/raid1:md0: active with 2 out of 2 mirrors
         [ 3979.638618] md/raid1:md0: Disk failure on sdc1, disabling device.
                        md/raid1:md0: Operation continuing on 1 devices
	```
19. Протестируйте целостность файла, несмотря на "сбойный" диск он должен продолжать быть доступен:	
	```     
         gzip -t /tmp/new/test.gz
         echo $?
         0
	```
20. Погасите тестовый хост, vagrant destroy.
    ```    
         [E:\vm\vagrant]$ vagrant halt
         ==> default: Attempting graceful shutdown of VM...

         [E:\vm\vagrant]$ vagrant destroy
             default: Are you sure you want to destroy the 'default' VM? [y/N] y
         ==> default: Destroying VM and associated drives...
    ```

