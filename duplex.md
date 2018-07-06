Final Content for Intel IoT RFP Ready Kit ODM Deployment Guide
==============================================================
Deployment Guide

Deploy an Infrastructure to Build an Intel® IoT RFP Ready Kit for the
Healthcare Vertical

Summary
=======

Intel® IoT RFP Ready Kits are commercially hardened, ready-for-customer
solution kits built to be scalable for customer deployments and tested
in field deployments. Kits feature commercial-grade components of
bundled hardware, software, and support. Kits have an existing
distribution and pricing model and solve a class of specific vertical
industry challenges.

For customers, deploying an Intel IoT RFP Ready Kit can help minimize
testing and development costs, accelerate time to market, and grow
market share. For original design manufacturers (ODMs), developing an
Intel IoT RFP Ready Kit helps create awareness of a solution. All kits
are promoted in the [Intel IoT RFP Ready Kit Solutions
Playbook](https://www.intel.com/content/www/us/en/products/solutions/iot/playbook.html)
and on the Intel RFP Ready Kit web pages. And ODMs with available kits
have access to the Intel sales team, who sell the kits pre-bundled with
Intel® hardware.

This deployment guide covers foundational hardware and software for an
infrastructure that ODMs can use to build an Intel IoT RFP Ready Kit. It
also covers how to deploy that infrastructure. This guide is intended
for ODMs that are developing solutions for the healthcare vertical;
Intel, however, will accept submissions for kits built for a variety of
different verticals. Existing kits and verticals can be found in the
[Intel IoT RFP Ready Kit Solutions
Playbook](https://www.intel.com/content/www/us/en/products/solutions/iot/playbook.html).

Intel IoT RFP Ready Kit Requirements
------------------------------------

As ODMs prepare to build an Intel IoT RFP Ready Kit for the healthcare
vertical, Intel recommends that kits submitted for consideration:

-   Address a specific vertical industry need or challenge.

-   Solve one or more specific problems for the target vertical.

-   Are commercially tested in a customer pilot or are available for
    purchase at the time of submission.

-   Use commercial-grade components, including hardware powered by
    Intel® processors.

-   Use customizable APIs that are available for download from the ODM's
    website.

-   Include supporting documentation and marketing collateral hosted on
    the ODM's website or made available in print, such as a data sheet,
    a user guide, and a configuration guide.

Recommended Infrastructure for Building Intel IoT RFP Ready Kits for Healthcare 
================================================================================

The infrastructure recommended in this guide creates a single, common
platform for aggregating applications and services, including enterprise
AI, adaptive security, device data consolidation and routing, device
integration, workload consolidation, health IT patient monitoring,
workflow optimization, and asset tracking.

Hardware and Software Summary
-----------------------------

The following hardware and software, or comparable hardware and
software, can be used as a foundational infrastructure on which to build
an Intel IoT RFP Ready Kit.

-   Two servers, each powered by 2 x Intel® Xeon® Gold 5120 processors
    each with 14 cores/28 threads. See Table 1 for configuration
    details.

    -   Two servers are recommended to help ensure high availability.

    -   Dell PowerEdge R640\* servers were used in the deployment
        outlined in this guide.

-   Wind River® Titanium Control virtualization platform. See Table 2
    for version information.

[]{#_Hardware_and_Software .anchor}This foundational infrastructure can
be used as a base on which to add capabilities, such as applications,
Internet of Things (IoT) sensors, patient devices, and advanced clinical
AI, in order to create a compelling Intel IoT RFP Ready Kit. Deployment
of these additional differentiating capabilities is not covered in this
guide.

### Hardware Details

The infrastructure in this guide uses systems powered by Intel Xeon Gold
processors, as shown in Table 1.

Intel Xeon Scalable processors offer a variety of enhanced and all-new
technologies designed into the silicon to help maximize performance,
reliability, availability, serviceability, and manageability. They offer
more cores and threads than previous generation Intel processors, and
are architected with an all-new Intel mesh internal microarchitecture
that improves performance relative to the earlier "ring" architecture. A
uniform shape for all CPUs with the new microarchitecture enables any
CPU to fit into the same Intel Socket P socket type. This means systems
can scale from two sockets to four, and on to eight, without the
addition of external chipsets.

In addition to Intel Xeon Scalable processors, Intel SSD DC series and
Intel adapters help optimize performance and availability. The Intel SSD
DC S4600 series is optimized for read-intensive workloads and the Intel
SSD Data Center Family for SATA is optimized for mixed workloads. Using
a mix of both SSDs ensures performance and efficiency for all workloads
without bottlenecks or disruptions. It also provides endurance and data
protection. An Intel Ethernet Converged Network Adapter x710 enables the
deployment to quickly sense and migrate virtual machines (VMs) and
containers running on one system to the other system if either of the
servers goes down or is in a degraded state. And an Intel® Ethernet
Controller i350 QP network interface controller (NIC) offers innovative
power management features to reduce power consumption along with
flexible I/O virtualization of up to 32 virtual ports.

Table . Hardware configuration

+-----------------+-----------------+-----------------+-----------------+
| **Quantity**    | **Hardware**    | **Hardware      | **Component     |
|                 |                 | Component**     | Configuration** |
+=================+=================+=================+=================+
| 2               | Dell PowerEdge  | Trusted         | NA              |
|                 | R640\* server   | Platform Module |                 |
+-----------------+-----------------+-----------------+-----------------+
|                 |                 | Chassis         | Rackmount       |
+-----------------+-----------------+-----------------+-----------------+
|                 |                 | Processor       | 2 x Intel®      |
|                 |                 |                 | Xeon® Gold 5120 |
|                 |                 |                 | processor       |
+-----------------+-----------------+-----------------+-----------------+
|                 |                 | Memory          | RDIMM, 2,666    |
|                 |                 |                 | MT/s            |
+-----------------+-----------------+-----------------+-----------------+
|                 |                 | Hard drives     | A minimum of    |
|                 |                 |                 | three drives    |
|                 |                 |                 | are required    |
|                 |                 |                 | for full duplex |
|                 |                 |                 | operation:      |
|                 |                 |                 |                 |
|                 |                 |                 | -   1 x Intel®  |
|                 |                 |                 |     SSD S4600   |
|                 |                 |                 |     Series Read |
|                 |                 |                 |     Intensive   |
|                 |                 |                 |     with        |
|                 |                 |                 |     minimum     |
|                 |                 |                 |     capacity of |
|                 |                 |                 |     480 GB      |
|                 |                 |                 |                 |
|                 |                 |                 | -   2 x Intel   |
|                 |                 |                 |     SSD Data    |
|                 |                 |                 |     Center      |
|                 |                 |                 |     Family for  |
|                 |                 |                 |     SATA for    |
|                 |                 |                 |     mixed       |
|                 |                 |                 |     workloads,  |
|                 |                 |                 |     each with   |
|                 |                 |                 |     minimum     |
|                 |                 |                 |     capacity of |
|                 |                 |                 |     200 GB      |
+-----------------+-----------------+-----------------+-----------------+
|                 |                 | Network         | -   1 x 10      |
|                 |                 | connectivity    |     gigabit     |
|                 |                 |                 |     Intel®      |
|                 |                 |                 |     Ethernet    |
|                 |                 |                 |     Converged   |
|                 |                 |                 |     Network     |
|                 |                 |                 |     Adapter     |
|                 |                 |                 |     X710        |
|                 |                 |                 |                 |
|                 |                 |                 | -   1 x 4 Port  |
|                 |                 |                 |     1 GB Intel® |
|                 |                 |                 |     Ethernet    |
|                 |                 |                 |     Controller  |
|                 |                 |                 |     i350 QP     |
|                 |                 |                 |     network     |
|                 |                 |                 |     interface   |
|                 |                 |                 |     controller  |
|                 |                 |                 |     (NIC)       |
+-----------------+-----------------+-----------------+-----------------+
|                 |                 | Optics for      | 1 x Intel®      |
|                 |                 | network cards   | Ethernet SFP+   |
|                 |                 |                 | SR Optics, 10   |
|                 |                 |                 | gigabit         |
|                 |                 |                 | Ethernet (GbE)  |
|                 |                 |                 | for direct      |
|                 |                 |                 | connect between |
|                 |                 |                 | servers         |
|                 |                 |                 |                 |
|                 |                 |                 | or              |
|                 |                 |                 |                 |
|                 |                 |                 | 1 x 10 GB SFP+  |
|                 |                 |                 | copper cables   |
|                 |                 |                 | for direct      |
|                 |                 |                 | connect between |
|                 |                 |                 | servers         |
+-----------------+-----------------+-----------------+-----------------+
|                 |                 | Power supply    | Dual, hot-plug, |
|                 |                 |                 | redundant power |
|                 |                 |                 | supply (1+1),   |
|                 |                 |                 | 495 W           |
+-----------------+-----------------+-----------------+-----------------+

### Software Details

This deployment uses the Wind River Titanium Control virtualization
platform that:

-   Is based on the OpenStack\* platform, a leading open-source cloud
    platform.

-   Adds the reliability and availability extensions required to use
    OpenStack\* platform--based orchestration, which bring a cloud
    infrastructure for critical services and applications on-premises.

<!-- -->

-   Automatically scales to instantaneously normalize performance and
    balance workloads.

-   Meets the demands of critical infrastructure, such as healthcare.

-   Offers built-in redundancy and an automatic service-recovery
    capability.

The deployment also uses Docker, a container solution and Intel®
Computer Vision SDK.

Docker is a leading container solution. Containers are lightweight,
stand-alone, executable packages that encapsulate everything needed to
run Linux- or Windows-based applications, including code, runtime,
system tools, system libraries, and settings. Containerized software
always runs the same, regardless of the environment, and enables running
different software on the same infrastructure. Popular container
solutions and platforms include Docker, Kubernetes (for hosting and
managing Docker clusters), Red Hat OpenShift Container Platform (a
vendor distribution of Kubernetes), and Docker Swarm, used for Wind
River Titanium Control and that enables cluster management with the
Docker Engine. Hosted container platforms are also available.

The Intel® Computer Vision SDK is a toolkit for developing applications
and solutions that emulate human vision. It is based on convolutional
neural networks (CNN) and extends workloads across Intel hardware to
maximize performance. For more information, see
https://software.intel.com/en-us/computer-vision-sdk.

Table . Software versions

  **Component**                                          **Version**
  ------------------------------------------------------ -------------------------------------------
  Wind River® Titanium Control virtualization platform   18.03-b9
  CentOS 7                                               CentOS-7-x86\_64-GenericCloud-1802.qcow2c
  Docker for CentOS                                      1.12
  Intel® Computer Vision SDK                             Ubuntu 16.04 LTS

### 

#### More About the OpenStack Platform

The OpenStack platform includes components that comprise a modular
architecture. OpenStack platform components used in the Wind River
Titanium Control virtualization platform with this sample deployment
include:

-   **Nova,** the OpenStack component for compute. It is used to
    provision compute instances (or virtual servers), virtual machines,
    and bare metal servers. It also offers limited support for system
    containers.

-   **Glance,** the OpenStack image service that allows users to upload
    and discover data assets (images and metadata) and is meant to be
    used with other services.

-   **Cinder,** an OpenStack storage service that provides block storage
    as a service.

-   **Neutron,** an OpenStack project that provides
    networking-as-a-service capabilities between interface devices, such
    as virtual NICs, that are managed by other OpenStack services, such
    as Nova.

Infrastructure Deployment Instructions
======================================

Before deployment of the example infrastructure recommended in this
guide, ODMs will want to choose and procure the recommended hardware or
comparable hardware and the Wind River Titanium Control virtualization
platform. When procuring comparable hardware, refer to [Table
1](#_Hardware_and_Software) for component configuration details. Servers
can be purchased from
[Dell](http://www.dell.com/en-us/work/shop/dell-poweredge-servers/poweredge-r640-rack-server/spd/poweredge-r640/pe_r640_12232?selectionState=eyJGUHJpY2UiOjE1NjMzLjM3LCJPQyI6InBlX3I2NDBfMTIyMzIiLCJRdHkiOjEsIk1vZHMiOlt7IklkIjoxNTUwLCJPcHRzIjpbeyJJZCI6IjUxMDM0MTIiLCJQcmljZSI6MTUzNC42NX1dfSx7IklkIjoxNTYwLCJPcHRzIjpbeyJJZCI6IjUwOTg4OTAiLCJQcmljZSI6NzYyLjI4fV19LHsiSWQiOjE1NDAsIk9wdHMiOlt7IklkIjoiNTA5ODg2NiJ9XX0seyJJZCI6MTU0MSwiT3B0cyI6W3siSWQiOiJIMzMwIiwiUHJpY2UiOjE1Ny4wfV19LHsiSWQiOjE1NzAsIk9wdHMiOlt7IklkIjoiNTEwMzYyNiIsIlByaWNlIjoxODUuMzd9LHsiSWQiOiI1MTA2NjI2IiwiUHJpY2UiOjMwOC4zMn0seyJJZCI6IkdBR0U4MlUiLCJQcmljZSI6MTEzNC4yOH1dfSx7IklkIjoxNjUyLCJPcHRzIjpbeyJJZCI6Ik5PTUVEIn1dfSx7IklkIjoxNTIwLCJPcHRzIjpbeyJJZCI6IjUwOTk1NTcifV19LHsiSWQiOjE1MTQsIk9wdHMiOlt7IklkIjoiWDcxMExQIiwiUHJpY2UiOjc2MS4wMn1dfSx7IklkIjoxNTE5LCJPcHRzIjpbeyJJZCI6IjY0VFBISCIsIlByaWNlIjo4ODI2LjQ0fV19LHsiSWQiOjE2MjEsIk9wdHMiOlt7IklkIjoiMTI1VjEwIn1dfSx7IklkIjoxNTMzLCJPcHRzIjpbeyJJZCI6IkVTQklPUyJ9XX0seyJJZCI6MTYxMCwiT3B0cyI6W3siSWQiOiJSUkNNQSIsIlByaWNlIjoxMTkuMTd9XX1dfQ%253D%253D)
or a preferred hardware vendor. Wind River Titanium Control can be
purchased from [Wind
River](https://www.windriver.com/products/titanium-control/).

Set Up the Systems
------------------

Install the servers according to the manufacturer's instructions. For
the example infrastructure using Dell R640 servers, instructions can be
found in the guide or at
[dell.com/support/manuals/us/en/04/poweredge-r640/r640\_om/poweredge-r640-system-overview?guid=guid-94057d7c-b6f9-4003-a1e6-58bbd19de91c&lang=en-us](http://www.dell.com/support/manuals/us/en/04/poweredge-r640/r640_om/poweredge-r640-system-overview?guid=guid-94057d7c-b6f9-4003-a1e6-58bbd19de91c&lang=en-us).
Instructions for comparable hardware may vary.

1.  Unpack the systems.

2.  Install the systems into a rack.

> For more information about installing the system into a rack, see the
> "Rail Installation Guide" at
> [http://downloads.dell.com/manuals/all-products/esuprt\_ser\_stor\_net/esuprt\_poweredge/poweredge-r640\_user%27s%20guide3\_en-us.pdf](http://downloads.dell.com/manuals/all-products/esuprt_ser_stor_net/esuprt_poweredge/poweredge-r640_user%27s%20guide3_en-us.pdf%20%20)
> or visit
> [dell.com/poweredgemanuals.](http://www.dell.com/poweredgemanuals)

3.  Connect desired peripherals, such as a display and keyboard, to the
    systems.

4.  Connect the systems to an electrical outlet.

5.  Turn the systems on by pressing the power button or by using iDRAC.

6.  Connect each system to the network to obtain a Dynamic Host
    Configuration Protocol (DHCP) address for each iDRAC.

More information about setting up the systems is available in the
"Getting Started Guide" that should come with the systems. Manuals,
documentation, drivers, downloads, and more can also be found by
visiting
[dell.com/support/home/us/en/04/products/](http://www.dell.com/support/home/us/en/04/products/)
and entering the system's service tag, product ID, or serial number
where prompted.

### Define the Environment

Before deploying the infrastructure, it is advisable to define the
environment and how the ODM will implement it on the network with the
internal infrastructure team. Items needed for the recommended duplex
system include:

-   Floating IP

-   Static IP

-   Two nodes

-   Front-end network

-   Back-end network

-   Pool of IP to use for the virtual machines (VMs)

Figure 1 shows a recommended default network and system configuration.

![](DIR/media/image1.png){width="6.625in" height="4.4125in"}

Figure 1. The default recommended private network and system
configuration, which includes virtual machines than can house an app or
apps to customize the ODM's solution and create an Intel IoT RFP Ready
Kit implementation

### Set Up a Network between the Two Cluster Nodes

Set up a private network between the servers according to the default
system diagram Figure 1. The following are recommendations; it is
advisable to work with the internal infrastructure or network
engineering team to create a configuration that works for the
environment.

1.  Connect the four NIC ports on each system to the top-of-rack switch
    using Ethernet cables appropriate to the environment.

2.  Directly connect the systems to the back-end network host-to-host
    using Ethernet cables appropriate to the network bandwidth.

3.  

> Connect the iDRAC9 Enterprise port on each system in the same
> out-of-band management network as the operations administration and
> management (OAM) network. 4.

Provision the Physical Servers
------------------------------

Default settings are used for all items with the exception of:

1)  "Under System BIOS 'Boot Settings • UEFI Boot Settings,'" (step 6 in
    Appendix A), which is environment dependent

2)  Connecting to an iDRAC IP address (step 3. a. under "set the boot
    manager preferences" in Appendix A).

3)  Any environment-specific information, such as setting the system
    time and contact information.

You can skip any items that use default settings. For reference, the
full set of instructions, including all default setting, are included in
[Appendix A](#appendix-a-provision-the-physical-servers). Non-default
settings are included here.

The System Setup screen enables configuration of system BIOS settings,
iDRAC settings, and device settings. It can be viewed in a graphical
(default) or text browser. The System Setup Main Menu displays system
BIOS information, iDRAC settings, and device settings options.

> ![](DIR/media/image2.png){width="0.30972222222222223in"
> height="0.2798611111111111in"}**Note:** Any time a setting is changed,
> an alert will display asking if the users really wants to change the
> setting. Select **Yes**, and then click **OK** when the Success alert
> appears.

From the System Setup screen, select **System BIOS**.

1.  Under System BIOS **Boot Settings • UEFI Boot Settings**:

    a.  Enable or disable boot options depending on the environment.

    b.  Select **UEFI Boot Sequence** to reorder the boot sequence with
        the first preference of PXE Device 1 (PXE Device 1 is enabled by
        default) at the top of the list.

        1.  Use the arrow keys to select a boot device, and then use the
            plus (**+**) and minus (**-**) keys to move the device down
            or up in the order.

        2.  Click **Exit**, and then click **Yes** to save the settings
            on exit.

2.  Under System BIOS **Miscellaneous Settings**, change the system,
    time, date, and asset tag as follows and if desired. Otherwise all
    default settings are used and can be found in Appendix A.

    c.  **System Time**: *Change the system time if desired.*

    d.  **System Date**: *Update the system date if needed.*

    e.  **Asset Tag**: *Specifies the asset tag and enables the user to
        modify it for security and tracking purposes.*

Next, set the boot manager preferences.

1.  To enter Boot Manager, turn on or restart the system.

2.  Press F11 when the following message appears: F11 = Boot Manager.

3.  To begin, configure the initial network settings based on the
    internal network infrastructure to enable communication to and from
    iDRAC.

    ![](DIR/media/image2.png){width="0.30972222222222223in"
    height="0.2798611111111111in"}**Note:** The user can configure the
    initial network settings and set up the Dell Lifecycle Controller\*
    before or after setting up the system BIOS.

    a.  Get a DHCP IP address from the admin to use to configure the
        initial network settings.

    b.  Obtain a static IP for iDRAC from the admin.

    c.  Set up the static IP address using the Dell Lifecycle
        Controller.

4.  To optionally set up the Lifecycle Controller, use the five-step
    Setup Wizard:

    d.  On the **Step 1 of 5** screen, select the desired language and
        keyboard type if different than the default, and then select
        **Next**.

    e.  On the **Step 2 of 5** screen, review the product overview, and
        then select **Next**.

        1.  Wait for Network Settings to complete.

    <!-- -->

    c.  On the **Step 3 of 5** screen, simply select **Next**; no
        changes are needed, unless advanced settings are desired, such
        as setting up authentication.

        1.  Wait for Network Settings to complete.

    d.  On the **Step 4 of 5** screen, when prompted to save the
        configuration changes, select **Yes**.

        2.  Wait for the Initial Setup Wizard operation to complete.

    e.  The **Step 5 of 5** screen summarizes the settings.

Next, from the **System Setup** screen, select **iDRAC Settings**
**Network**.

For more information on iDRAC configuration, see
[dell.com/support/manuals/us/en/04/poweredge-r640/r640\_om/idrac-configuration?guid=guid-f6a0c7af-c3d1-430a-9c19-9cd1f42fd138&lang=en-us](http://www.dell.com/support/manuals/us/en/04/poweredge-r640/r640_om/idrac-configuration?guid=guid-f6a0c7af-c3d1-430a-9c19-9cd1f42fd138&lang=en-us).

1.  2.  3.  4.  5.  6.  7.  8.  Under **IPv4 Settings**, set Enable DHCP
    to "disabled," and enter the IP, gateway, and subnet addresses
    provided by the system administrator.

    a.  **Enable DHCP**: **Disabled**

    b.  **IP Address**: *Enter the IP address*

    c.  **Gateway**: *Enter the gateway address*

    d.  ![](DIR/media/image2.png){width="0.30972222222222223in"
        height="0.2798611111111111in"}**Subnet Mask**: *Enter the subnet
        mask address*

**Note:** For additional optional and default settings for provisioning
the systems, see [Appendix
A](#appendix-a-provision-the-physical-servers).

1.  2.  3.  

<!-- -->

a.  1.  2.  3.  

<!-- -->

2.  Under iDRAC Settings **System Location**, enter the data center
    name, aisle name, rack name, rack slot, and size management system
    in U for the local environment and provided by the data center
    manager.

    a.  **Data Center Name**: *Enter the data center name*

    b.  **Aisle Name**: *Enter the aisle name*

    c.  **Rack Name**: *Enter the rack name*

    d.  **Rack Slot**: *Enter the rack slot*

    e.  **Size Management System in U**: *Enter the size management
        system in U*

3.  Under iDRAC Settings **Communications Permissions**, enter the OS IP
    address provided by the system administrator.

    f.  **OS to IDRAC Pass Through**

        1.  **Pass-through Configuration**: **LOM**

    g.  **Network Settings**

        2.  **OS IP Address**: *Enter the OS IP Address*

<!-- -->

1.  a.  1.  

To finish the configuration:

1.  Select **Back** to return to the System BIOS screen.

2.  Select **Yes** when prompted to reboot.

Configure System 1 as Controller 0 and Install the Wind River® Titanium Control Operating System
------------------------------------------------------------------------------------------------

Copy the Wind River Titanium Control Release 5 server image from its
source location to a boot medium, such as a USB drive or DVD, or use
iDRAC to point to the ISO file on the network.

In the following steps, the image has been copied to a USB drive. For
instructions on using the image on a DVD or pointing to the ISO file on
the network, refer to the *Wind River Titanium Cloud Installation for
Duplex Systems* guide.

1.  To start, press F11 to power on the system intended to be used as
    controller 0.

2.  On the **Boot Manager** screen, select **One-shot UEFI Boot
    Manager**.

    a.  Under **Select UEFI Boot Option**, select **Disk Connected to
        front USB 2: Silicon Power64G**.

3.  Under **Select kernel options and boot kernel**, use the down arrow
    to select **UEFI All-in-one Controller Configuration**.

4.  Select **Graphical Console**.

5.  Select **STANDARD Security Profile**.

    b.  The system will install the Wind River Titanium Control
        operating system and reboot.

### Configure Controller 0

1.  Open the system console for controller 0 by entering its iDRAC IP
    address in a web brower; Firefox is recommended.

2.  Enter the iDRAC username.

3.  Enter the iDRAC password.

4.  Open the iDRAC dashboard.

5.  Launch the virtual console.

6.  When prompted to get the JAVA file, open it and click **Continue**.

7.  When prompted, run the .exe file; no certificate is required.

    a.  

8.  9.  10. b.  

11. 12. c.  

#### Install the Wind River Titanium Control Image and Apply Any Needed Patches

1.  Boot controller 0, if it is not already booted.

2.  Log in to controller 0 using "wrsroot" as the default username and
    password.

    a.  Select a unique password when prompted.

3.  Set the IP address of the OAM network:

sudo ifconfig eno1 *\[enter IP the address\]*/24 up
![](DIR/media/image2.png){width="0.30972222222222223in"
height="0.2798611111111111in"}

**Note:**

-   Obtain actual IP addresses from the administrator, substituting them
    for *\[enter IP the address\]* where appropriate.

-   "24" is the network size, which might be different is based on the
    internal network.

-   "gw" is the gateway address, which is a unique address based on the
    internal network. "eno1" is the internal network adapter, and may be
    called f0 or f1 or a name specific to the internal infrastructure.

> sudo route add default gw *\[enter IP the address\]* eno1

4.  Copy the patches, which might be found in the same location of the
    ISO image was located or can be downloaded from Wind River, to a
    unique host computer.

5.  Transfer the patches from the chosen host computer (likely the admin
    system) to controller 0:

> scp -r patches wrsroot@*\[enter IP the address\]*

6.  Open the Wind River Titanium Control license and .ini file (a sample
    is shown in [Appendix
    B](#appendix-b-sample-wind-river-titanium-control-license-and-.ini-file))
    in a text editor.

7.  Update the ini.file in the text editor to include a desired
    password, environment interfaces, and the IP addresses provided by
    the admin, and save the file as "license.lic."

8.  Copy the modified .ini file to controller 0, using:

> scp license.lic wrsroot@*\[enter IP the address\]*:license.lic
>
> scp Duplex-TiS5\_config.ini wrsroot@*\[enter IP the address\]*:.

9.  Upload and apply any needed patches to controller 0:

> sudo sw-patch upload-dir \~/patches
>
> sudo sw-patch apply \--all
>
> sudo sw-patch install-local

b.  Reboot when prompted:

> sudo reboot

10. Set the password expiration timeframe:

> sudo chage -M 90 wrsroot
> ![](DIR/media/image2.png){width="0.30972222222222223in"
> height="0.2798611111111111in"}

**Note:** "90" is the length of time between password resets and can be
set to 1 and any number above.

11. Configure the system, using the controller 0 console:

> sudo config\_controller \--config-file Duplex-TiS5\_config.ini
>
> source /etc/nova/openrc
>
> system license-install license.lic
> ![](DIR/media/image2.png){width="0.30972222222222223in"
> height="0.2798611111111111in"}

**Note:** Configuration can take some time; when it is complete reboot
the controller

12. Reboot the controller.

13. Open an SSH session to the floating IP:

> ssh wrsroot@*\[enter IP the address\]*
>
> source /etc/nova/openrc
>
> system modify \--name="*enter name*"
>
> system modify \--description=\"*enter description*\"
>
> system modify \--contact=\"*enter contact*\"

14. 

> system modify \--location=\"*enter location*\"

15. Find the correct /dev/disk/by-path for use in steps 15 and 16 by
    using:

> system host-disk-list controller-0

16. Create the local Nova instance:

> system host-lvg-add controller-0 nova-local
>
> dev\_uuid=\`system host-disk-list controller-0 \|grep -i
> /dev/disk/by-path/pci-0000:18:00.0-sas-0x4433221100000000-lun-0 \| awk
> \'{print \$2}\'\`
>
> system host-pv-add controller-0 nova-local \${dev\_uuid}

16\. Create the Cinder volume:

> system host-lvg-add controller-0 cinder-volumes
>
> system host-lvg-modify controller-0 cinder-volumes -l
> thin![](DIR/media/image2.png){width="0.30972222222222223in"
> height="0.2798611111111111in"}

**Note:** "thin" or "thick" can be used.

> dev\_uuid=\`system host-disk-list controller-0 \|grep -i
> /dev/disk/by-path/pci-0000:18:00.0-sas-0x4433221106000000-lun-0 \| awk
> \'{print \$2}\'\`
>
> disk\_size=\`system host-disk-list controller-0 \|grep -i
> /dev/disk/by-path/pci-0000:18:00.0-sas-0x4433221106000000-lun-0 \| awk
> \'{print \$12}\'\`
>
> idisk\_uuid=\`system host-disk-partition-add controller-0
> \${dev\_uuid} \${disk\_size} -t lvm\_phys\_vol \| grep -i idisk\_uuid
> \| awk \'{print \$4}\'\`
>
> system host-disk-partition-list controller-0 \--disk \$idisk\_uuid

c.  Wait until the following command is displayed, which will take some
    time. This command indicates the node is ready. The specific
    information displayed with be unique to the environment.

+\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--+\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--+\-\-\-\-\-\-\-\-\-\-\-\--+\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--+\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--+\-\-\-\-\-\-\-\-\--+\-\-\-\-\-\-\--+

\| uuid \| device\_path \| device\_node \| type\_guid \| type\_name \|
size\_mib \| status \|

+\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--+\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--+\-\-\-\-\-\-\-\-\-\-\-\--+\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--+\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--+\-\-\-\-\-\-\-\-\--+\-\-\-\-\-\-\--+

\| 8b003ad4-d308-4061-ad97-ce7423d52a33 \|
/dev/disk/by-path/pci-0000:3b:00.0-scsi-0:2:1:0-part1 \| /dev/sdb1 \|
ba5eba11-0000-1111-2222-000000000001 \| LVM Physical Volume \| 380925 \|
Ready \|

+\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--+\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--+\-\-\-\-\-\-\-\-\-\-\-\--+\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--+\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--+\-\-\-\-\-\-\-\-\--+\-\-\-\-\-\-\--+

+\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--+\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--+\-\-\-\-\-\-\-\-\-\-\-\--+\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--+\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--+\-\-\-\-\-\-\-\-\--+\-\-\-\-\-\-\--+

\| uuid \| device\_path \| device\_node \| type\_guid \| type\_name \|
size\_mib \| status \|

+\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--+\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--+\-\-\-\-\-\-\-\-\-\-\-\--+\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--+\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--+\-\-\-\-\-\-\-\-\--+\-\-\-\-\-\-\--+

\| 09c698e7-a984-4a5d-af6c-2fd6b540b423 \|
/dev/disk/by-path/pci-0000:18:00.0-sas- \| /dev/sda5 \|
ba5eba11-0000-1111-2222-000000000001 \| LVM Physical Volume \| 145818 \|
In-Use \|

\| \| 0x4433221104000000-lun-0-part5 \| \| \| \| \| \|

\| \| \| \| \| \| \| \|

\| afa89239-5893-49bc-b076-f8a2361e1f5c \|
/dev/disk/by-path/pci-0000:18:00.0-sas- \| /dev/sdd1 \|
ba5eba11-0000-1111-2222-000000000001 \| LVM Physical Volume \| 457860 \|
Ready \|

\| \| 0x4433221106000000-lun-0-part1 \| \| \| \| \| \|

\| \| \| \| \| \| \| \|

+\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--+\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--+\-\-\-\-\-\-\-\-\-\-\-\--+\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--+\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--+\-\-\-\-\-\-\-\-\--+\-\-\-\-\-\-\--+

17. When controller 0 is ready, add an extension partition:

> partition\_id=\`system host-disk-partition-list controller-0 \--disk
> \$idisk\_uuid \|grep -i
> /dev/disk/by-path/pci-0000:18:00.0-sas-0x4433221106000000-lun-0\| awk
> \'{print \$2}\'\`
>
> system host-pv-add controller-0 cinder-volumes \$partition\_id
>
> system host-disk-partition-add controller-0
> /dev/disk/by-path/pci-0000:18:00.0-sas-0x4433221104000000-lun-0 145818
>
> system host-pv-add controller-0 cgts-vg
> /dev/disk/by-path/pci-0000:18:00.0-sas-0x4433221104000000-lun-0-part5

15. Create the provider networks using the default networks recommended
    by Wind River:

> neutron providernet-create north-south \--type flat
> \--vlan-transparent true
>
> neutron providernet-create data0 \--type vlan \--vlan-transparent true
>
> neutron providernet-range-create data0 \--shared \--range 100-200
> \--name data0-segment-100-200

16. Connect the provider networks.

> ![](DIR/media/image2.png){width="0.30972222222222223in"
> height="0.2798611111111111in"}**Note:** It's critical to specify the
> correct network ports when connecting the provider network. To
> identify the ports, use: system host-port-list controller-0.

a.  Identify the correct ports:

> system host-port-list controller-0

b.  Use the following, inserting your network ports where indicated:

    system host-if-modify -p north-south -nt data controller-0 \[*enter
    network port 1*\]

    system host-if-modify -p data0 -nt data controller-0 \[*enter
    network port 2*\]

> ![](DIR/media/image2.png){width="0.30972222222222223in"
> height="0.2798611111111111in"}**Note:** Ensure that the management
> network adapter (named enp59s0f0 in this sample deployment using the
> recommended hardware) is used for PXE booting. If during system setup,
> you didn't specify UEFI as the boot mode with PXE Device 1: Integrated
> NIC Port 1 Partition 1 as the preferred first item in the boot
> sequence, do so before proceeding. Note the particular partition will
> be unique to your environment.

17. Return to the console and unlock controller 0:

> system host-unlock controller-0

Controller 0 configuration is complete.

Install the Wind River Titanium Control virtualization platform on Controller 1
-------------------------------------------------------------------------------

1.  Press F11 to boot controller 1.

2.  Under **Boot Menu**, select **PXE Boot**.

3.  Open an SSH instance to the floating IP.

    ssh wrsroot@*\[enter IP the address\]*

4.  To use controller 0 to configure controller 1 as controller 1, from
    controller 0, use:

> source /etc/nova/openrc
>
> system host-list

a.  Wait for the system targeted to be used as controller 1 displays and
    enter:

> id=\`system host-list \|grep -i none \|awk \'{print \$2}\'\`
>
> system host-update \${id} personality=controller console=tty0

b.  Wait for the controller 1 install to complete, which can take some
    time

    i.  It is recommended to occassionally check to see if controller 1
        is online, using:

> system host-list

5.  6.  7.  

<!-- -->

6.  Open an SSH session on controller 0:

> source /etc/nova/openrc
>
> system host-if-modify -nt oam controller-1 eno1
>
> system host-if-modify -p north-south -nt data controller-1 eno2
>
> system host-if-modify -p data0 -nt data controller-1 eno3

**Note:** eno1, eno2 and eno3 are the ports for OAM, the north-south
network, and data0 in this example. If you are using different ports or
port names, substitute eno1, eno2, and eno3 with those ports/names.

7.  Find the correct /dev/disk/by-path for use in steps 8 and 10 by
    using:

> system host-disk-list controller-1

8.  Create the local Nova instance:

> system host-lvg-add controller-1 nova-local
>
> dev\_uuid=\`system host-disk-list controller-1 \|grep -i
> /dev/disk/by-path/pci-0000:18:00.0-sas-0x4433221100000000-lun-0 \| awk
> \'{print \$2}\'\`
>
> system host-pv-add controller-1 nova-local \${dev\_uuid}

9.  

> 1

10. Create the Cinder volume:

> system host-lvg-add controller-1 cinder-volumes
>
> system host-lvg-modify controller-1 cinder-volumes -l thin
>
> ("thin" or "thick" can be used)
>
> dev\_uuid=\`system host-disk-list controller-1 \|grep -i
> /dev/disk/by-path/pci-0000:18:00.0-sas-0x4433221100000000-lun-0 \| awk
> \'{print \$2}\'\`
>
> disk\_size=\`system host-disk-list controller-1 \|grep -i
> /dev/disk/by-path/pci-0000:18:00.0-sas-0x4433221100000000-lun-0 \| awk
> \'{print \$12}\'\`
>
> idisk\_uuid=\`system host-disk-partition-add controller-1
> \${dev\_uuid} \${disk\_size} -t lvm\_phys\_vol \| grep -i idisk\_uuid
> \| awk \'{print \$4}\'\`
>
> system host-disk-partition-list controller-0 \--disk \$idisk\_uuid

a.  Wait until the following command is displayed, which will take some
    time. This command indicates the node is ready. The specific
    information displayed with be unique to the environment.

+\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--+\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--+\-\-\-\-\-\-\-\-\-\-\-\--+\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--+\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--+\-\-\-\-\-\-\-\-\--+\-\-\-\-\-\-\--+

\| uuid \| device\_path \| device\_node \| type\_guid \| type\_name \|
size\_mib \| status \|

+\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--+\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--+\-\-\-\-\-\-\-\-\-\-\-\--+\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--+\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--+\-\-\-\-\-\-\-\-\--+\-\-\-\-\-\-\--+

\| 8b003ad4-d308-4061-ad97-ce7423d52a33 \|
/dev/disk/by-path/pci-0000:3b:00.0-scsi-0:2:1:0-part1 \| /dev/sdb1 \|
ba5eba11-0000-1111-2222-000000000001 \| LVM Physical Volume \| 380925 \|
Ready \|

+\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--+\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--+\-\-\-\-\-\-\-\-\-\-\-\--+\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--+\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--+\-\-\-\-\-\-\-\-\--+\-\-\-\-\-\-\--+

9.  When controller 1 is ready, unlock controller 1 using:

<!-- -->

11. 

> system host-unlock controller-1

12. When controller 1 is online, add an extension partition (use system
    host-disk-list controller-1 to find the correct /dev/disk/by-path if
    needed):

> partition\_id=\`system host-disk-partition-list controller-1 \--disk
> \$idisk\_uuid \|grep -i
> /dev/disk/by-path/pci-0000:18:00.0-sas-0x4433221106000000-lun-0 \| awk
> \'{print \$2}\'\`
>
> system host-disk-partition-add controller-1
> /dev/disk/by-path/pci-0000:18:00.0-sas-0x4433221104000000-lun-0 145818
>
> system host-pv-add controller-1 cgts-vg
> /dev/disk/by-path/pci-0000:18:00.0-sas-0x4433221104000000-lun-0-part5
>
> system host-pv-add controller-1 cinder-volumes \$partition\_id

Controller 1 configuration is complete.

Set Up and Join the Cluster 
----------------------------

1.  Open an SSH session on either controller and set up a floating IP:

> ssh wrsroot@*\[enter IP the address\]*

2.  3.  Return to the console to create a software-defined network with
    virtual routers and switches using Wind River Titanium Control.
    Obtain IP addresses for your public network CIDR, private network
    CIDR, start and end IP addresses, DNS resolver, and public network
    gateway from your network admin, and enter:

    source /etc/nov/openrc

    neutron net-create public \--shared \--provider:physical\_network
    public \--provider:network\_type flat

    neutron subnet-create public *\[enter PUBLIC\_NETWORK\_CIDR\]*
    \--name public \--allocation-pool start=*\[enter*
    START\_IP\_ADDRESS*\]*,end=*\[enter* END\_IP\_ADDRESS*\]*
    \--dns-nameserver DNS\_RESOLVER \--gateway *\[enter*
    PUBLIC\_NETWORK\_GATEWAY*\]*

    neutron net-create private

    neutron subnet-create private *\[enter* PRIVATE\_NETWORK\_CIDR*\]*
    \--name private \--dns-nameserver *\[enter* DNS\_RESOLVER*\]*
    \--gateway *\[enter* PRIVATE\_NETWORK\_GATEWAY*\]*

    neutron net-update public \--router:external

    neutron router-create router

    neutron router-interface-add router private

    neutron router-gateway-set router public

Set Up the Virtual Server Flavor 
---------------------------------

In OpenStack, and therefore Wind River Titanium Control, a flavor
defines the compute, memory, and storage capacity of a virtual server,
also known as an instance. An administrative user can create, edit, and
delete flavors.

1.  To begin, copy Appendix C to a text editor and save it as
    "m1-flavors.yaml" and copy it to the home directory of the floating
    IP:

> \$ scp /drives/\[location of m1-flavors.yaml file, such as
> c/Users/admin/Documents/scripts/heat-examples/16/m1-flavors.yaml\]
> wrsroot@*\[enter IP the address\]*:.
>
> \$ heat stack-create -f filename m1-flavors.yaml m1-flavors

a.  This deployment uses m1.small flavor, which can be copied from
    [Appendix C](#appendix-c-default-m1-flavors-for-openstack).

Load Virtual Server Cloud Instances
-----------------------------------

1.  Obtain the desired virtual server cloud images.

2.  Expand the ctgs file system, by entering:

> system controllerfs-modify cgcs=40 Image-conversion=40 backup=120

Multiple options are available for download. This deployment uses the
CentOS7 image available at <https://cloud.centos.org/centos/7/images/>.
(For this deployment,
[CentOS-7-x86\_64-GenericCloud.qcow2c](https://cloud.centos.org/centos/7/images/CentOS-7-x86_64-GenericCloud-1804_02.qcow2)
was used.)

3.  Once the ctgs file is expanded, copy the images to the local Glance
    storage, for example: /home/wrsroot/images.

4.  Create the images. The following are samples only and show different
    flavors of OSes running.

> \$ glance image-create \--container-format bare \--disk-format qcow2
> \--visibility public \--progress \--file
> /home/wrsroot/images/Base-Win2012-VM.qcow2 \--name Win2012
>
> \$ glance image-create \--container-format bare \--disk-format qcow2
> \--visibility public \--progress \--file
> /home/wrsroot/images/cirros-0.3.5-x86\_64-disk.img \--name
> cirros-0.3.5
>
> \$ glance image-create \--container-format bare \--disk-format qcow2
> \--visibility public \--progress \--file
> /home/wrsroot/images/ctowen-ubuntu.qcow2 \--name ctowen-VM
>
> ![](DIR/media/image2.png){width="0.30972222222222223in"
> height="0.2798611111111111in"}\$ glance image-create
> \--container-format bare \--disk-format qcow2 \--visibility public
> \--progress \--file /home/wrsroot/images/xenial-server.img \--name
> ubuntu-xenial-server

**Note:** A double hyphen "\--" indicates a variable. Any item after a
double hyphen will be specific to your environment.

Start Provisioning the Virtual Machines
---------------------------------------

To customize a solution, ODMs can add an app on the VMs along with other
needed components to create a customized Intel IoT RFP Ready Kit
implementation. Sample instructions for adding containers and the Intel
Computer Vision SDK are included here as examples.

### Install CentOS, Docker, and Deploy a Container

To take advantage of containers, install CentOS 7 on a virtual machine,
and then install Docker on the virtual machine and deploy one instance
of a sample container.

1.  Log in to the Wind Titanium Cloud console.

2.  Expand the **Compute** menu.

3.  Select **Key Pairs**.

4.  Select **Create Key Pair**.

5.  Enter a **Key Pair Name**, such as: ***AuthKey***.

6.  Click **Create Keypair**.

7.  Click **Copy Private Key to Clipboard**, to save the key pair
    information to a text file.

8.  Click **Done**.

> The new **Key Pair** has been created and is now available to the
> system.

9.  Select the new key pair you created.

    a.  If you used ***AuthKey*** as the name, select the ***AuthKey***
        key pair by checking the box next to ***AuthKey***. The **Key
        Pair Details** are shown.

> Next, create a .ppk file for SSH authentication.

1.  In the Wind Titanium Cloud console, expand the **Compute** menu, and
    click **Instances**.

2.  Click **Launch Instance.**

3.  Enter an **Instance Name**, ***Docker*** was used in this example,
    then click **Next**.

4.  Select Image as the boot source and select the CentOS7 image, then,
    click **Next**.

5.  Select the desired **Flavor**, ***m1.small*** was used in this
    example, then click **Next**.

6.  Select Key Pair.

7.  Select the **Key Pair** that was previously created key pair,
    ***AuthKey*** in this example.

8.  Click **Launch Instance**.

9.  Open an SSH session to the CentOS instance using the IP allocated to
    the instance and authenticate using the previously created private
    key.

10. Set up the Docker repository by entering:

> sudo yum-config-manager \--add-repo
> https://packages.docker.com/1.12/yum/repo/main/centos/7

11. Update the package repository by entering:

    sudo yum makecache fast

12. Install the Docker engine by entering:

> sudo yum -y install docker-engine

13. Verify that the Docker engine has installed by entering:

> yum list installed \| grep docker

14. Start the service by entering:

> sudo usermod -aG docker \$(whoami)
>
> sudo service docker start

15. Ensure that the Docker service is running by entering:

> sudo docker inf

16. Restart the Docker service by entering:

> sudo systemctl restart docker

17. Ensure that Docker is running by entering:

> sudo docker info

18. Download and run the ***Hello-World*** Docker container by entering:

    sudo docker run \--name hello-world -d -p 5432:5432 hello-world

19. View the output from the ***Hello-World*** container by entering:

> sudo docker logs hello-world

### Set Up Intel® Computer Vision SDK

1.  Log in to the Wind Titanium Cloud console.

2.  Expand the **Compute** menu.

3.  Select **Images.**

4.  Click **Create Image**.

5.  On the ***Create An Image*** screen:

    a.  Under **Name**, enter a name for the image, such as ***Computer
        Vision***.

    b.  Under **Image File**, browse to the image file, the location for
        which should be provided by the system administrator.

6.  Under **Format**, select ***QCOW2***.

7.  Check the **Public** check box.

8.  Click **Create Image**.

9.  Expand the **Compute** menu.

10. Select **Key Pairs. **

11. Select **Create Key Pair.**

12. Enter a **Key Pair Name**, such as: ***AuthKey.***

13. Click **Create Keypair.**

14. Click **Copy Private Key to Clipboard**, to save the key pair
    information to a text file.

15. Click **Done**

    The new **Key Pair** will have been created and is now available to
    the system.

16. Select the new key pair you created.

> If you used ***AuthKey*** as the name, select the ***AuthKey*** key
> pair by checking the box next to ***AuthKey***. The **Key Pair
> Details** will display.
>
> Next, create a .ppk file for SSH authentication.

1.  In the Wind Titanium Cloud console, go to Instances

2.  In the Wind Titanium Cloud console, expand the **Compute** menu, and
    click **Instances**.

3.  Click **Launch Instance.**

4.  Enter an **Instance Name**, ***Computer Vision*** was used in this
    example, then click **Next**.

5.  Select a **Source** image of the newly created Computer Vision
    image, click **Next**.

6.  Select the desired **Flavor**, ***m1.large*** was used for this
    example, then click **Next**.

7.  Selected the desired **Network**, click **Next^.^**

8.  Select **Key Pair**

9.  Select the **Key Pair** that was previously created, ***AuthKey***
    in this example.

10. Click **Launch
    Instance.**![](DIR/media/image2.png){width="0.30972222222222223in"
    height="0.2798611111111111in"}

**Note:** If interested in duplicating a system once setup is complete,
find instructions the *Wind River* *Titanium Cloud System Backup and
Restore* manual.

a.  i.  

Additional Resource for Kit Development
---------------------------------------

Intel and other providers offer a variety of software solutions that
ODMs can use in developing an Intel IoT RFP Ready Kit for the healthcare
edge, including, but not limited to:

-   **Intel® OpenVino™ Toolkit ---** Enables development of applications
    and solutions that emulate human vision with the Open Visual
    Inference & Neural Network Optimization (OpenVINO) toolkit. The
    toolkit is based on convolutional neural networks (CNN). It enables
    CNN-based deep learning inference on the edge. And it extends
    workloads across Intel® hardware to maximize performance. Learn more
    at <https://software.intel.com/en-us/openvino-toolkit>.

-   **Intel® Contex Sensing SDK** --- A library for Android\* and
    Windows\* that enables easily incorporating context-aware
    capabilities and services into applications. It offers several
    methods to use the services, either independently or in combination.
    Context APIs and built-in context type providers can be used to
    create context-aware applications. A rules engine enables the
    creation of rules based on the context and triggers actions once
    conditions are satisfied. Learn more at
    <https://software.intel.com/en-us/context-sensing-sdk>.

-   **Intel® Health Application Platform for Remote Healthcare** --- A
    software solution that, when coupled with an Intel
    architecture--based design specification implemented by a
    third-party hardware vendor, can help enable the secure and reliable
    delivery of distributed healthcare services across an
    always-connected and ever-expanding healthcare edge and to any
    cloud. The solution can help to gather and distribute data in a
    security-enabled form to any cloud. For more information, see
    [intel.com/content/www/us/en/healthcare-it/health-application-platform.html](https://www.intel.com/content/www/us/en/healthcare-it/health-application-platform.html).

-   

Intel IoT RFP Ready Kit Submission
==================================

Kits can be submitted by completing the submission form at
<https://intelcustomer.az1.qualtrics.com/jfe/form/SV_eet2pmpDqSAVXNj?MRO=KIT>.

For answers to questions or for more information, contact
<rfp.ready.kits@intel.com> or Robert Kamp, Director IOTG (Internet of
Things Group) MCA (Channels), <robert.kamp@intel.com> or (404) 915-5058.

RFP Ready Kit Checklist
-----------------------

ODMs submitting kits for consideration will want to have the following
information on hand when filling out the submission form:

-   If you have deployed your kit in a commercial pilot, any available
    videos, photos, reports, and other documentation of the pilot

-   A list of hardware and software components that are available in
    your kit package; for example, include information on sensors,
    sensor hubs, the gateway, the cloud, the application layer, and so
    on with your submission, including a list of included Intel software
    and hardware

-   Details on the device management and over-the-air (OTA) upgrade
    capabilities of the kit

-   A list of any security specifications or third-party security-module
    integration, if available

-   API details and a URL to relevant documentation, if available

-   Information on where the kit can be purchased, including geographic
    availability, if applicable

-   Pricing details

-   Support details

-   Enclosure details, including the standard used, if any

-   Temperature and power requirements

-   Regulatory and emissions certifications, if any

-   Identification of whether the kit is supported by documentation and
    or an introduction video, in addition to links to those materials if
    applicable

-   Technical specifications, such as hardware, software, radios,
    sensors, and so on

-   Soft copies or links to online copies of any solution briefs, white
    papers, or other relevant documentation

-   Willingness to allow Intel to use your copyrighted materials,
    imagery, and so on in promotional materials and any other related
    documents or products

Learn More
==========

Intel IoT RFP Ready Kits:
[www.intel.com/content/www/us/en/products/solutions/iot.html](http://www.intel.com/content/www/us/en/products/solutions/iot.html)

Intel IoT RFP Ready Kits playbook with all Intel IoT RFP Ready Kits
available today:
[intel.com/content/www/us/en/products/solutions/iot/playbook.html](http://www.intel.com/content/www/us/en/products/solutions/iot/playbook.html)

Smart healthcare IoT solutions from Intel:
[intel.com/content/www/us/en/healthcare-it/transforming-healthcare.html](http://www.intel.com/content/www/us/en/healthcare-it/transforming-healthcare.html)

Appendix A: Provision the Physical Servers
==========================================

The System Setup screen enables configuration of system BIOS settings,
iDRAC settings, and device settings. It can be viewed in a graphical
(default) or text browser. The System Setup Main Menu displays system
BIOS information, iDRAC settings, and device settings options.

Configure System BIOS Settings
------------------------------

To begin, from the System Setup screen, select **System BIOS**.

1.  Under System BIOS **Memory Settings**, the default configuration
    settings are as follows:

    a.  **System Memory Testing**: **Disabled**

    b.  **Memory Operating Mode**: **Optimizer Mode**

    c.  **Node Interleaving**: **Disabled**

    d.  **Opportunistic Self-Fresh**: **Disabled**

> ![](DIR/media/image2.png){width="0.30972222222222223in"
> height="0.2798611111111111in"}**Note:** Any time a setting is changed,
> an alert will display asking if the users really wants to change the
> setting. Select **Yes**, and then click **OK** when the Success alert
> appears.

2.  Under System BIOS **Processor Settings**, the default configuration
    settings are as follows:

    a.  **Logical Processor**: **Enabled**

    b.  **CPU Interconnect Speed**: **Maximum data rate**

    c.  **Virtualization Technology**: **Enabled**

    d.  **Adjacent Cache Line Prefetch**: **Enabled**

    e.  **Hardware Prefetcher**: **Enabled**

    f.  **DC Streamer Prefetcher**: **Enabled**

    g.  **DCU IP Prefetcher**: **Enabled**

    h.  **Sub NUMA Cluster**: **Disabled**

    i.  **UPI Prefetch**: **Enabled**

    j.  **Logical Processor Idling**: **Disabled**

    k.  **X2APIC Mode**: **Disabled**

    l.  **Dell Controller Turbo**: **Disabled**

    m.  **Number of Cores Per Processor**: **All**

3.  Under System BIOS **SATA Settings**, the default configuration
    settings are as follows:

    n.  **Embedded SATA**: **AHCI** 

    o.  **Security Freeze Lock**: **Enabled**

    p.  **Sends Security Freeze Lock**: **Enabled**

    q.  **Write Cache**: **Disabled**

4.  Under System BIOS **NVMe Settings**, **NVMe Mode** is set to **Non
    RAID** by default.

5.  Under System BIOS **Boot Settings**, the default configuration
    settings are as follows:

    r.  **Boot Mode**: **UEFI**

    s.  **Boot Sequence Retry**: **Enabled**

    t.  **Hard-Disk Failover**: **Disabled**

6.  Under System BIOS **Boot Settings • UEFI Boot Settings**:

    u.  Enable or disable boot options depending on the environment.

    v.  Select **UEFI Boot Sequence** to reorder the boot sequence with
        the first preference of PXE Device 1 (PXE Device 1 is enabled by
        default) at the top of the list.

        1.  Use the arrow keys to select a boot device, and then use the
            plus (**+**) or minus (**-**) key to move the selection up
            or down in the order.

        2.  Click **Exit**, and then click **Yes** to save the settings.

7.  Under System BIOS **Network Settings**, the default configuration
    settings are as follows:

    w.  **UEFI PXE Settings**:

        3.  **PXE Device 1**: **Enabled**

        4.  **PXE Device 1**: **Disabled**

        5.  **PXE Device 1**: **Disabled**

        6.  **PXE Device 1**: **Disabled**

    x.  **UEFI HTTP Settings**:

        7.  **HTTP Device1**: **Disabled**

8.  Under System BIOS **Integrated Devices**, the default configuration
    settings are as follows:

    y.  **User Accessible USB Ports**: **All Ports On**

    z.  **Internal USB Port**: **On**

    a.  **iDRAC Direct USB Port**: **On**

    b.  **Integrated RAID Controller**: **Enabled**

    c.  **Integrated Network Card 1**: **Enabled**

    d.  **IOAT/DMA Engine**: **Disabled**

    e.  **Embedded Video Controller**: **Enabled**

    f.  **Current State of Embedded Controller**: **Enabled**

    g.  **SR-IOV Global Enable**: **Disabled**

    h.  **OS Watchdog Timer**: **Disabled**

    i.  **Memory Mapped I/O Above 4GB**: **Enabled**

    j.  **Memory Mapped I/O Base**: **56 TB**

    k.  Under **Slot Disablement**, the default configuration settings
        are as follows:

        8.  **Slot 1**: **Enabled**

        9.  **Slot 2**: **Enabled**

    l.  Under **Slot Bifurcation**, the default configuration setting is
        as follows:

        10. **Auto Discovery Bifurcation**: **Platform Default
            Bifurcation**

9.  Under System BIOS **Serial Communications**, the default
    configuration settings are as follows:

    m.  **Serial Communications**: **Auto** 

    n.  **Serial Port Address**: **Serial Device1=COM2, Serial Device
        2=COM1**

    o.  **External Serial Connector**: **Serial Device 1**

    p.  **Failsafe Baud Rate**: **115200**

    q.  **Remote Terminal Type**: **VT 100/VT 220** 

    r.  **Redirection After Boot**: **Enabled**

10. Under System BIOS **System Profile Setting**, the default
    configuration settings are as follows:

    s.  **System Profile**: **Performance Per Watt Optimized (DAPC) **

    t.  **CPU Power Management**: **System DBPM (DAPC)** by default.
        DBPM is demand-based power management.

    u.  **Memory Frequency**: **Maximum Performance**

    v.  **Turbo Boost**: **Enabled**

    w.  **C1E**: **Enabled**

    x.  **C States**: **Enabled**

    y.  **Write Data CRC**: **Enabled**

    z.  Enable or disable the **Write Data CRC**. This option is set
        to **Enabled** by default.

    a.  **Memory Patrol Scrub**: **Standard**

    b.  **Memory Refresh Rate**: **1x**

    c.  **Uncore Frequency**: **Maximum**

    d.  **Energy Efficient Policy**: **Performance**

    e.  **Number of Turbo Boot Enabled Cores for Processor 1**: **All**

11. Under System BIOS **System Security**, the default configuration
    settings are as follows:

    f.  **In-Band Manageability Interface**: **Enabled** 

    g.  **Intel AES-NI**: **Enabled**

    h.  **System Password**: Sets the system password. This option is
        set to **Enabled** by default, and it is read-only if the
        password jumper is not installed in the system.

    i.  **Setup Password**: Sets the setup password. This option is
        read-only if the password jumper is not installed in the system.

    j.  **Password Status**: **Unlocked** 

    k.  **Power Button**: **Enabled**

    l.  **AC Power Recovery**: **Last**

    m.  **AC Power Recovery Delay**: **Immediate**

    n.  **User Defined Delay (60 s to 240 s)**: **60**

    o.  **UEFI Variable Access**: **Standard**

    p.  **Secure Boot**: **Enabled**

    q.  **Secure Boot Policy**: **Standard**

12. Under System BIOS **Redundant OS Control**, the default
    configuration setting is as follows:

    r.  **Redundant OS Locations**: **None**

13. Under System BIOS Miscellaneous Settings, change the system time,
    system date, and asset tag if desired. Otherwise, the default
    configuration settings are as follows:

    s.  **System Time**: *Change the system time if desired.*

    t.  **System Date**: *Update the system date if needed.*

    u.  **Asset Tag**: *Specifies the asset tag and enables the user to
        modify it for security and tracking purposes.*

    v.  **Keyboard NumLock**: **On**

    w.  **F1/F2 Prompt on Error**: **Enabled**

    x.  **Load Legacy Video Option ROM**: **Disabled**

    y.  **Dell Wyse P25/P45 BIOS Access**: **Enabled**

    z.  **Power Cycle Request**: **None**

Configure Boot Manager Settings
-------------------------------

Next, set the boot manager preferences.

1.  To enter Boot Manager, turn on or restart the system.

2.  Press F11 when the following message appears: F11 = Boot Manager.

3.  To begin, configure the initial network settings based on the
    internal network infrastructure to enable communication to and from
    iDRAC.

    ![](DIR/media/image2.png){width="0.30972222222222223in"
    height="0.2798611111111111in"}**Note:** The user can configure the
    initial network settings and set up the Dell Lifecycle Controller\*
    before or after setting up the system BIOS.

    a.  Get a DHCP IP address from the admin to use to configure the
        initial network settings.

    b.  c.  Obtain a static IP for iDRAC from the admin.

    d.  Set up the static IP address using the Dell Lifecycle
        Controller.

    e.  

4.  To optionally set up the Lifecycle Controller, use the five-step
    Setup Wizard:

    a.  On the **Step 1 of 5** screen, select the desired language and
        keyboard type if different than the default, and then select
        **Next**.

    b.  On the **Step 2 of 5** screen, review the product overview, and
        then select **Next**. Wait for Network Settings to complete.

    <!-- -->

    c.  On the **Step 3 of 5** screen, select **Next**; no changes are
        needed, unless advanced settings are desired, such as setting up
        authentication. Wait for Network Settings to complete.

    d.  On the **Step 4 of 5** screen, when prompted to save the
        configuration changes, select **Yes**. Wait for the Initial
        Setup Wizard operation to complete.

    e.  The **Step 5 of 5** screen summarizes the settings.

Configure iDRAC Settings
------------------------

Next, from the **System Setup** screen, select **iDRAC Settings**.

For more information on iDRAC configuration, see
[dell.com/support/manuals/us/en/04/poweredge-r640/r640\_om/idrac-configuration?guid=guid-f6a0c7af-c3d1-430a-9c19-9cd1f42fd138&lang=en-us](http://www.dell.com/support/manuals/us/en/04/poweredge-r640/r640_om/idrac-configuration?guid=guid-f6a0c7af-c3d1-430a-9c19-9cd1f42fd138&lang=en-us).

1.  Under iDRAC Settings Network, the default configuration settings are
    as follows:

    a.  **Network Settings**

        1.  **Enable NIC**: **Enabled**

        2.  **NIC Selection: Dedicated**

        3.  **Failover Network: None**

        4.  **MAC Address:** *As listed*

        5.  **Auto Negotiation: On**

        6.  **Auto Dedicated NIC: Disabled**

        7.  **Network Speed: 1000 Mbps**

        8.  **Active Nice Interface: Dedicated**

        9.  **Duplex Mode: Full Duplex**

    b.  **Common Settings**

        1.  **Regulatory DRAC on DNS**: **Enabled**

        2.  **Auto Negotiation**: **On**

        3.  **DNS DRAC Name**: *Enter* "*iDRAC" followed by the system
            serial number*

        4.  **Auto Config Domain Name**: **Disabled**

        5.  **Static DNS Domain Name**: *Enter the chosen domain
            obtained from the internal network administrator*

    c.  **IPv4 Settings**

        1.  **Enable IPv4**: **Enabled**

        2.  **Enable DHCP**: **Disabled**

        3.  **IP Address**: *Enter the IP address*

        4.  **Gateway**: *Enter the gateway address*

        5.  **Subnet Mask**: *Enter the subnet mask address*

        6.  **Use DHCP to obtain DNS service address**: **Enabled**

        7.  **Preferred DNS**: *The optional preferred IP Address*

        8.  **Alternate DNS**: *The optional alternate IP Address*

    d.  **IPv6 Settings**

        1.  **Enable IPv6**: **Disabled**

    e.  **IPMI Settings**

        4.  **Enable IPMI Over LAN**: **Disabled**

        5.  **Channel Privilege Level Limit**: **Administrator**

        6.  **Encryption Key**: *The encryption key provided by the
            system administrator*

    f.  **VLAN Settings**

        1.  **Enable VLAN ID**: **Disabled**

<!-- -->

4.  Under iDRAC Settings **Alerts**, the default configuration settings
    are as follows:

    h.  **Platform Events**

        3.  **Enable Platform Events Filter Alerts**: **Disabled**

    i.  **Trap Settings IP Destinations List**

        4.  **Enable Alert Destination 1**: **Disabled**

        5.  **Enable Alert Destination 2**: **Disabled**

        6.  **Enable Alert Destination 3**: **Disabled**

        7.  **Enable Alert Destination 4**: **Disabled**

        8.  **Enable Alert Destination 5**: **Disabled**

5.  Under iDRAC Settings **Front Panel Security**, the default
    configuration settings are as follows:

    j.  **Disable Power Button**: **No**

    k.  **iDRAC Quick Sync**

        9.  **Quick Sync Hardware**: **Absent**

        10. **Quick Sync Access**: **Read-Write**

        11. **Inactivity Timeout**: **Enabled**

        12. **Timeout Limit**: **120**

        13. **Quick Sync Read Authentication**: **Enabled**

    l.  **Quick Sync WiFi**: **Enabled**

6.  Under iDRAC Settings **Media and USB Port Settings**, the default
    configuration settings are as follows:

    m.  **Virtual Media**

        14. **Virtual Media Status**: **Auto attach**

    n.  **VFlash Media**

        15. **Enable vFlash**: **Disabled**

    o.  **USB Management Port**

        16. **USB Management Port Mode**: **iDRAC Direct Only**

        17. **iDRAC Direct: USB Configuration XML**: **Enabled while
            server has default credential settings only**

7.  Under iDRAC Settings **Lifecycle Controller**, the default
    configuration settings are as follows:

    p.  **Lifecycle Controller**: **Enabled**

    q.  **Collect System Inventory on Restart**: **Enable**

    r.  **Cancel Lifecycle Controller Action**: **No**

8.  Under iDRAC Settings **Power Configuration**, the default
    configuration settings are as follows:

    s.  **Power Cap Policy**

        18. **Power Cap Policy**: **Disabled**

        19. **Power Supply Capacity Alert**: **Disabled**

    t.  **Power Supply Options**

        20. **Redundancy Policy**: **Input Power Redundant**

    u.  **Hot Spare**

        21. **Enable Hot Spare**: **Enabled**

        22. **Primary Power Supply Unit**: **PSU 1**

    v.  **Power Factor Correction (PFC)**

        23. **Enable Power Factor Correction**: **Enabled**

9.  Under iDRAC Settings **Thermal**, the default configuration settings
    are as follows:

    w.  **System Thermal Profile**

        24. **Thermal Profile**: **Default Thermal Profile Settings**

    x.  **User Cooling Options**

        25. **Maximum Exhaust Temperature Limit**: **70C (158F
            Default)**

        26. **Fan Speed Offset**: **Off**

        27. **Minimum Fan Speed**: **Default**

10. Under iDRAC Settings **System Location** enter the data center name,
    aisle name, rack name, rack slot, and size management system in U
    for the local environment and as provided by your data center
    manager.

    y.  **Data Center Name**: *Enter the data center name*

    z.  **Aisle Name**: *Enter the aisle name*

    a.  **Rack Name**: *Enter the rack name*

    b.  **Rack Slot**: *Enter the rack* *slot*

    c.  **Size Management System in U**: *Enter the size management
        system in U*

11. Under iDRAC Settings **User Configuration**, the default
    configuration settings are as follows:

    d.  **User ID**: Leave as is.

    e.  **Enable User**: **Enabled**

    f.  **User Name**: **Root**

    g.  **LAN User Privilege**: **Administrator**

    h.  **Serial Port User Privilege**: **Administrator**

12. Under iDRAC Settings **Smart Card**, the default configuration
    setting is as follows:

    i.  **Configure Smart Card Logon**: **Enabled with Remote RADADM**

13. Under iDRAC Settings **Communications Permissions**, enter the OS IP
    address provided by the system administrator. All other settings are
    the default configuration settings:

    j.  **OS to IDRAC Pass Through**

        28. **Pass-through Configuration**: **LOM**

    k.  **Network Settings**

        29. **OS IP Address**: *The OS IP Address*

14. Under iDRAC Settings **Remote Enablement**, the default
    configuration settings are as follows:

    l.  **Enable Auto Discovery**: **Disabled**

    m.  **Provisioning Server**: Leave blank.

15. Under iDRAC Settings **System Lockdown Mode**, the default
    configuration settings are as follows:

    n.  **System Lockdown Mode**: **Disabled**

    o.  Select **Back** to return to the System BIOS screen.

        30. Select **Yes** when prompted to save changes.

Configure Device Settings
-------------------------

Next, from the **System Setup** screen, select **Device Setting**.

1.  Under Device Settings **Integrated Storage Controller 1: Dell HBA
    330 Mini (PCISlot:0x0), Dell HBA330 Mini Version 13.17.03.05,
    Physical Disk Management, View Physical Disk and Select Physical
    Disk Operations**, the default configuration setting is as follows:

    a.  **Select Physical Disk**: **0:10**

2.  Under Device Settings **Integrated NIC Port 1: Intel® Gigabit 4P
    i350-t rNDC -- 26:6E96:A0:21:84**, and under **ISCSI Initiator
    Parameters**, enter the **ISCI Name** provided by the system
    administrator. All other settings are the default configuration
    settings as follows:

    b.  **Blink LEDs**: **0**

    c.  **NIC Configuration**

        1.  **Legacy Boot Protocol: PXE**

        2.  **Link Speed**: **Auto Negotiated**

        3.  **Wake On LAN**: **Disabled**

        4.  **Virtual LAN ID**: **0**

        5.  **PCI Virtual Functions Advertised**: **8**

    <!-- -->

    b.  **ISCSI Configuration**

        6.  **ISCSI General Parameters**

            i.  **TCP/IP Parameters via DHCP**: **Enabled**

            ii. **ISCSI Parameters via DHCP: Enabled**

            iii. **CHAP Authentication: Disabled**

    c.  **ISCSI Initiator Parameters**

        7.  **ISCSI Name**: *Enter the ISCSI name*

    d.  **Device Level Configuration**

        8.  **Virtualization Mode**: **SR-IOV**

To finish the configuration:

3.  Select **Back** to return to the System BIOS screen.

4.  Select **Yes** when prompted to reboot.

Appendix B: Sample Wind River Titanium Control License and .ini File
====================================================================

\[SYSTEM\]

SYSTEM\_MODE = duplex-direct

SYSTEM\_TYPE = All-in-one

\[MGMT\_NETWORK\]

CIDR = *\[enter IP the address\]*/24

MULTICAST\_CIDR = *\[enter IP the address\]*/28

DYNAMIC\_ALLOCATION = Y

LOGICAL\_INTERFACE = LOGICAL\_INTERFACE\_1

\[LOGICAL\_INTERFACE\_1\]

LAG\_INTERFACE = N

INTERFACE\_MTU = 1500

INTERFACE\_LINK\_CAPACITY = 10000

INTERFACE\_PORTS = enp59s0f0

\[OAM\_NETWORK\]

CIDR = *\[enter IP the address\]*/24

GATEWAY = *\[enter IP the address\]*

IP\_FLOATING\_ADDRESS = *\[enter IP the address\]*

IP\_UNIT\_0\_ADDRESS = *\[enter IP the address\]*

IP\_UNIT\_1\_ADDRESS = *\[enter IP the address\]*

LOGICAL\_INTERFACE = LOGICAL\_INTERFACE\_2

\[LOGICAL\_INTERFACE\_2\]

LAG\_INTERFACE = N

INTERFACE\_MTU = 1500

INTERFACE\_PORTS = eno1

\[AUTHENTICATION\]

ADMIN\_PASSWORD = *Enter your admin password*

\[VERSION\]

RELEASE = 18.03

Appendix C: Default M1 Flavors for OpenStack
============================================

The following default m1 flavors usually come with OpenStack.

**Note:** The lines commented as extra\_specs might be needed for some
tests, but are not used by default.

heat\_template\_version: 2015-04-30

parameters:

resources:

m1.tiny.Flavor:

type: OS::Nova::Flavor

properties:

name: m1.tiny

ram : 512

disk: 0

vcpus : 1

\# extra\_specs:

\# \'hw:cpu\_model\' : SandyBridge

\# \'hw:cpu\_policy\' : shared

\# \'hw:mem\_page\_size\' : 2048

\# \'aggregate\_instance\_extra\_specs:storage\' : local\_lvm

m1.small.Flavor:

type: OS::Nova::Flavor

properties:

name: m1.small

ram : 2048

disk: 0

vcpus : 1

\# extra\_specs:

\# \'hw:cpu\_model\' : SandyBridge

\# \'hw:cpu\_policy\' : shared

\# \'hw:mem\_page\_size\' : 2048

\# \'aggregate\_instance\_extra\_specs:storage\' : local\_lvm

m1.medium.Flavor:

type: OS::Nova::Flavor

properties:

name: m1.medium

ram : 4096

disk: 0

vcpus : 2

\# extra\_specs:

\# \'hw:cpu\_model\' : SandyBridge

\# \'hw:cpu\_policy\' : shared

\# \'hw:mem\_page\_size\' : 2048

\# \'aggregate\_instance\_extra\_specs:storage\' : local\_lvm

m1.large.Flavor:

type: OS::Nova::Flavor

properties:

name: m1.large

ram : 8192

disk: 0

vcpus : 4

\# extra\_specs:

\# \'hw:cpu\_model\' : SandyBridge

\# \'hw:cpu\_policy\' : shared

\# \'hw:mem\_page\_size\' : 2048

\# \'aggregate\_instance\_extra\_specs:storage\' : local\_lvm

Intel technologies' features and benefits depend on system configuration
and may require enabled hardware, software or service activation.
Performance varies depending on system configuration. No computer system
can be absolutely secure. Check with your system manufacturer or
retailer or learn more at intel.com.

Intel disclaims all express and implied warranties, including without
limitation, the implied warranties of merchantability, fitness for a
particular purpose, and non-infringement, as well as any warranty
arising from course of performance, course of dealing, or usage in
trade.

Intel, the Intel logo, and Xeon are trademarks of Intel Corporation in
the U.S. and/or other countries.

Wind River and the Wind River logo are trademarks of Wind River Systems,
Inc.

\*Other names and brands may be claimed as the property of others. 

© 2018 Intel Corporation.
