ADMINID=`openstack project list | grep admin | awk '{print $2}'`
NORTH-SOUTH='north-south'
EXTERNALNET='external'
EXTERNALSUBNET='external-subnet0'

#Create tenant networks
neutron net-create --tenant-id ${ADMINID} --provider:network_type=vlan --provider:physical_network=${NORTH-SOUTH} --provider:segmentation_id=10 --router:external ${EXTERNALNET}

EXTERNALNETID=`neutron net-list | grep ${EXTERNALNET} | awk '{print $2}'`

# Create subnets -- Counting on external router to do dhcp and gateway since OAM and EXTERNAL data net are on the same subnet
neutron subnet-create --tenant-id ${ADMINID} --name ${EXTERNALSUBNET} --no-gateway --disable-dhcp ${EXTERNALNET} 10.10.10.0/24
 
