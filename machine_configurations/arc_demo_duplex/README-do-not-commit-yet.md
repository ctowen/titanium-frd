# This is a Work in PROGRESS!!

# Intel Fog Reference Platform setup for Titanium R4 Duplex, ARC Demo
__Richard Moore, richard.moore@windriver.com, Feb, 2018__

This document contains the configuration details for the Intel FRPs used in the ARC demo, February 2018.

## Network and Switch Setup
This is the Network and switch configuration used and referred. Please adjust for your own network situation.
Note that a small router has been used to allow connection to various WAN networks without needing to reconfigure the Titanium OAM and Data networks.

The router used here is a Ubiquiti Edgemax ER-X, but almost any router would do. The TOR (top-of-rack) Switch is an 8-port GBE VLAN switch (such as Netgear,etc) configured like this:

![](images/2018-02-21-13-39-42.png)

The overall network looks like this:

![](images/2018-02-21-13-48-18.png)


[TODO] Finish documenting the installation 

## Intel Fog Reference Server Setup

BIOS Settings
- SATA
- PXE Boot
- Boot Order
 

## Controller-0 Installation

- Power On
- Boot from prepared USB Titanium image
- allow installer to complete (login prompt appears)
- Copy license.lic file, scripts, config_file and patches from USB
- Patch Installation

Upload the patches into the patching system:
```   
$ sudo sw-patch upload-dir /home/wrsroot
```
Verify status of patches
```
$ sudo sw-patch query
```
Apply the patches
```
$ sudo sw-patch apply --all
```
Install the patches
```
$ sudo sw-patch install-local
```
Reboot the server when prompted
```
$ sudo reboot
```

## Execute config_controller:
```
$ sudo config_controller --config_file config.ini
```

     Database storage: 20
     Image Storage: 70
     Image Conversion: 30
     Backup Storage: 110

     Management Network
     device: eno2
     Multicast subnet: 239.1.1.16/28

     Infrastructure Network
     device: eno3
     VLAN: 6
     Link Capacity: 1000

     OAM Network
     device: eno1
     VLAN: 5
     OAM subnet: 172.25.42.0/24
     OAM gateway: 172.25.42.33
     OAM floating IP: 172.25.42.47
     OAM controller-0 IP: 172.25.42.48
     OAM controller-1 IP: 172.25.42.49
     OAM Multicast subnet: 239.1.1.16/28

   Alternatively, use the pre-configured TiS_config.ini file:

   $ sudo config_controller --config-file TiS_config.ini

   Expected Results:
   - Execution of 'sudo ifconfig' verifies that OAM and MGMT interfaces
     have valid IPs assigned to them (e.g., MGMT: 192.168.202.3,
     OAM : 172.25.42.48)
   - Ability to log into Horizon via 172.25.42.47 or 48
   - Ability to SSH into controller-0 via wrsroot@172.25.42.47 or 48

6) Open a SSH session to controller-0 and setup the OpenStack environment:

   $ source /etc/nova/openrc

7) Execute the following scripts to setup the provider and tentant
   networks, and associated virtual router:

   $ ./01-configure-provider-network.sh
   $ ./02-configure-data-interface.sh
   $ ./03-configure-tenant-networks.sh
   $ ./04-configure-virtual-routers.sh

   Expected Results:
   - "Horizon -> Admin -> Platform -> Provider Networks" shows "physnet0" provider network.
   - "Horizon -> Admin -> Platform -> Host Inventory -> controller-0 ->
     Interfaces tab" shows "data0" assigned as a data network.
   - "Horizon -> Admin -> System -> Networks" shows external/internal networks.
   - "Horizon -> Admin -> System -> Routers" shows "vrouter0" virtual router.

8) Execute "05-setup-nova-local-storage.sh script. This will setup the
   'nova-local' storage on on /dev/sdc of controller-0.

   $ ./05-setup-nova-local-storage.sh
  
   Expected Results:
   - Horizon -> Platform -> Host Inventory -> controller-0 -> Storage tab
     shows nova-local storage state as "adding (on unlock)"

9) Add basic flavors to the system:

   $ ./06-create-basic-flavors.sh

   Expected Results:
   - Flavors can be seen under "Horizon -> Admin -> System -> Flavors"

10) Complete configuration of controller-0:

   $ system compute-config-complete

   Expected Results: 
   - The command returns immediately
   - The VGA console (or iDRAC console) displays manifests being applied.  
   - The controller reboots after it completes applying the manifests.

Controller-1 Installation
=========================

1) Open VGA or iDRAC console to controller-1. Power up controller-1, and
   enter <F12> to PXE boot when presented with the F-key options.

   Expected Results: 
   - controller-1 successfully boots over PXE with the "waiting for
     personality" message.

2) Start a SSH session to controller-0 and assign controller-1
   its personality:

   $ source /etc/nova/openrc
   $ ./07-assign-controller-1-personality.sh

   Expected Results:
   - controller-1 displays "CPE install" on its console and begins
     installing Titanium Server software.
   - controller-1 eventually reboots after software installation completes,
     and the login prompt is seen on the VGA or iDRAC console.
   - Ability to ping controller-1 from controller-0 via the MGMT interface,
     and vice versa.

     From controller-0 console:

     $ ping controller-1 -c 1
     PING controller-1 (192.168.204.4) 56(84) bytes of data
     64 bytes from controller-1 (192.168.204.4): icmp_seq=1 ttl=64 time=0.122 ms

     From controller-1 console (you will have to log in as wrsroot/wrsroot
     and change the password first):

     $ ping controller-0 -c 1
     PING controller-0 (192.168.204.3) 56(84) bytes of data
     64 bytes from controller-0 (192.168.204.3): icmp_seq=1 ttl=64 time=0.122 ms


3) From the controller-0 SSH session, setup the network interfaces on
   controller-1 with the following script:

   $ ./08-setup-controller-1-interfaces.sh

   Expected Results: 
   - "Horizon -> Platform -> Host Inventory -> controller-1 -> Interfaces
     tab" shows interface settings identical to those shown for controller-0

4) From the controller-0 SSH session, setup the cinder and nova-local
   storage on controller-1 with the following script:

   $ ./09-setup-controller-1-storage.sh

   Expected Results:
   - Horizon -> Platform -> Host Inventory -> controller-1 -> Storage
     tab shows row with cinder UUID and nova-local storage status
     "adding (on unlock)".

5) Unlock controller-1, via the controller-0 SSH session:

   $ system host-unlock controller-1

   Expected Results:
   - On the controller-1 console, you should see the server reboot
   - Upon reboot, you should see manifests being applied (will take
     several minutes)
   - controller-1 console eventually gets to its login prompt.

6) Confirm status of both controllers. From the controller-0 SSH session:

   $ system host-list

   Expected Results:
   - Both controllers show "Unlocked / Enabled / Available"..
   - Use the 'drbd-overview' command to confirm DRBD sync is in progress.
   - When DRBD sync completes, verify no critical alarms are shown under
     "Horizon -> Platform -> Fault Management"

# Intel Fog Reference Platform setup for Titanium R4 Duplex, ARC Demo
__Richard Moore, richard.moore@windriver.com, Feb, 2018__

This document contains the configuration details for the Intel FRPs used in the ARC demo, February 2018.

## Network and Switch Setup
This is the Network and switch configuration used and referred. Please adjust for your own network situation.
Note that a small router has been used to allow connection to various WAN networks without needing to reconfigure the Titanium OAM and Data networks.

The router used here is a Ubiquiti Edgemax ER-X, but almost any router would do. The TOR (top-of-rack) Switch is an 8-port GBE VLAN switch (such as Netgear,etc) configured like this:

![](images/2018-02-21-13-39-42.png)

The overall network looks like this:

![](images/2018-02-21-13-48-18.png)


[TODO] Finish documenting the installation 
Intel Fog Reference Server Setup
=================

- Power-up the server, then use <F2> to enter BIOS setup:

  * Processor Settings: Enable hyperthreading and virtualization
  * Boot Settings -> Boot Mode: UEFI
  * Integrated Devices -> Embedded Gb NIC 2: Enabled with PXE
  * Embedded Server Management -> User Defined LCD String
  * <Esc> -> "Save Changes and Exit"

- At reboot, use <F10> to enter Unified Server Configurator:

  * Hardware Configuration -> Configuration Wizards -> iDRAC Configuration:
    - LAN Configuration: IPMI Over LAN: Enabled, NIC Selection: Dedicated
    - IPV4 Configuration: Enter static IP address
    - LAN User Configuration: Enter user and password (root/davedell)

  * Hardware Configuration -> Configuration Wizards -> RAID Configuration:
    - Clear Foreign Configuration (if found)
    - Advanced Wizard
    - RAID Level: 0
    - Select first two physical disks in list
    - Click through and "Finish"

  * Exit and Reboot

- At reboot, use <Ctrl>-R to enter RAID setup

  * Create virtual partition #2:
    - Highlight "Controller 0" using up/down arrows -> F2 -> Create New VD
    - Tab to physical disks table and use space bar to select first disk
    - Tab to "OK", then <Enter>

  * Create virtual partition #3:
    - Repeat steps above

  * You should end up with three Disk Groups under "Controller 0"
  * <Esc> -> "OK"
  * Ctrl-Alt-Delete to reboot.
 

Controller-0 Installation
=========================

1) Open VGA or iDRAC console to controller-0. Power up controller-0, and
   enter <F11> to PXE boot when presented with the F-key options to open 
   the UEFI Boot Manager.  Select front USB flash disk to boot from.

2) Install ISO from USB on controller-0
   - Select "UEFI Graphics Text CPE Install"
   - Remove the USB thumb drive when the server reboots

   Expected Results: 
   - Titanium Server software successfully installs and server reboots.

3) Copy license.lic file, scripts and patches. This can be done either via 
   temporary setup of the OAM interface, or via a USB thumb drive formatted 
   to either ext3/4 or FAT32 (NTFS won't work)

   Expected Results:
   - license.lic, setup scripts, and patch files located at /home/wrsroot directory

4) Install patches:

   - Upload the patches into the patching system:
   
   $ sudo sw-patch upload-dir /home/wrsroot

   - Verify status of patches

   $ sudo sw-patch query

   - Apply the patches

   $ sudo sw-patch apply --all

   - Install the patches

   $ sudo sw-patch install-local

   - Reboot the server when prompted

   $ sudo reboot

5) Execute config_controller:

   $ sudo config_controller

     Database storage: 20
     Image Storage: 70
     Image Conversion: 30
     Backup Storage: 110

     Management Network
     device: eno2
     Multicast subnet: 239.1.1.16/28

     Infrastructure Network
     device: eno3
     VLAN: 6
     Link Capacity: 1000

     OAM Network
     device: eno1
     VLAN: 5
     OAM subnet: 172.25.42.0/24
     OAM gateway: 172.25.42.33
     OAM floating IP: 172.25.42.47
     OAM controller-0 IP: 172.25.42.48
     OAM controller-1 IP: 172.25.42.49
     OAM Multicast subnet: 239.1.1.16/28

   Alternatively, use the pre-configured TiS_config.ini file:

   $ sudo config_controller --config-file TiS_config.ini

   Expected Results:
   - Execution of 'sudo ifconfig' verifies that OAM and MGMT interfaces
     have valid IPs assigned to them (e.g., MGMT: 192.168.202.3,
     OAM : 172.25.42.48)
   - Ability to log into Horizon via 172.25.42.47 or 48
   - Ability to SSH into controller-0 via wrsroot@172.25.42.47 or 48

6) Open a SSH session to controller-0 and setup the OpenStack environment:

   $ source /etc/nova/openrc

7) Execute the following scripts to setup the provider and tentant
   networks, and associated virtual router:

   $ ./01-configure-provider-network.sh
   $ ./02-configure-data-interface.sh
   $ ./03-configure-tenant-networks.sh
   $ ./04-configure-virtual-routers.sh

   Expected Results:
   - "Horizon -> Admin -> Platform -> Provider Networks" shows "physnet0" provider network.
   - "Horizon -> Admin -> Platform -> Host Inventory -> controller-0 ->
     Interfaces tab" shows "data0" assigned as a data network.
   - "Horizon -> Admin -> System -> Networks" shows external/internal networks.
   - "Horizon -> Admin -> System -> Routers" shows "vrouter0" virtual router.

8) Execute "05-setup-nova-local-storage.sh script. This will setup the
   'nova-local' storage on on /dev/sdc of controller-0.

   $ ./05-setup-nova-local-storage.sh
  
   Expected Results:
   - Horizon -> Platform -> Host Inventory -> controller-0 -> Storage tab
     shows nova-local storage state as "adding (on unlock)"

9) Add basic flavors to the system:

   $ ./06-create-basic-flavors.sh

   Expected Results:
   - Flavors can be seen under "Horizon -> Admin -> System -> Flavors"

10) Complete configuration of controller-0:

   $ system compute-config-complete

   Expected Results: 
   - The command returns immediately
   - The VGA console (or iDRAC console) displays manifests being applied.  
   - The controller reboots after it completes applying the manifests.

Controller-1 Installation
=========================

1) Open VGA or iDRAC console to controller-1. Power up controller-1, and
   enter <F12> to PXE boot when presented with the F-key options.

   Expected Results: 
   - controller-1 successfully boots over PXE with the "waiting for
     personality" message.

2) Start a SSH session to controller-0 and assign controller-1
   its personality:

   $ source /etc/nova/openrc
   $ ./07-assign-controller-1-personality.sh

   Expected Results:
   - controller-1 displays "CPE install" on its console and begins
     installing Titanium Server software.
   - controller-1 eventually reboots after software installation completes,
     and the login prompt is seen on the VGA or iDRAC console.
   - Ability to ping controller-1 from controller-0 via the MGMT interface,
     and vice versa.

     From controller-0 console:

     $ ping controller-1 -c 1
     PING controller-1 (192.168.204.4) 56(84) bytes of data
     64 bytes from controller-1 (192.168.204.4): icmp_seq=1 ttl=64 time=0.122 ms

     From controller-1 console (you will have to log in as wrsroot/wrsroot
     and change the password first):

     $ ping controller-0 -c 1
     PING controller-0 (192.168.204.3) 56(84) bytes of data
     64 bytes from controller-0 (192.168.204.3): icmp_seq=1 ttl=64 time=0.122 ms


3) From the controller-0 SSH session, setup the network interfaces on
   controller-1 with the following script:

   $ ./08-setup-controller-1-interfaces.sh

   Expected Results: 
   - "Horizon -> Platform -> Host Inventory -> controller-1 -> Interfaces
     tab" shows interface settings identical to those shown for controller-0

4) From the controller-0 SSH session, setup the cinder and nova-local
   storage on controller-1 with the following script:

   $ ./09-setup-controller-1-storage.sh

   Expected Results:
   - Horizon -> Platform -> Host Inventory -> controller-1 -> Storage
     tab shows row with cinder UUID and nova-local storage status
     "adding (on unlock)".

5) Unlock controller-1, via the controller-0 SSH session:

   $ system host-unlock controller-1

   Expected Results:
   - On the controller-1 console, you should see the server reboot
   - Upon reboot, you should see manifests being applied (will take
     several minutes)
   - controller-1 console eventually gets to its login prompt.

6) Confirm status of both controllers. From the controller-0 SSH session:

   $ system host-list

   Expected Results:
   - Both controllers show "Unlocked / Enabled / Available"..
   - Use the 'drbd-overview' command to confirm DRBD sync is in progress.
   - When DRBD sync completes, verify no critical alarms are shown under
     "Horizon -> Platform -> Fault Management"