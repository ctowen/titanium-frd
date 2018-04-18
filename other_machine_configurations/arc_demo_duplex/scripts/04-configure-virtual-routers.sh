echo "I'd really rather do this for each project than in admin"
#EXTERNALNET0='external-net0'
#PUBLICSUBNET0='internal-subnet0'
#PUBLICROUTER0='vrouter0'
#EXTERNALNETID0=`neutron net-list | grep ${EXTERNALNET0} | awk '{print $2}'`

# Create virtual router
#neutron router-create ${PUBLICROUTER0}
#PUBLICROUTERID0=`neutron router-list | grep ${PUBLICROUTER0} | awk '{print $2}'`
#neutron router-gateway-set --disable-snat ${PUBLICROUTERID0} ${EXTERNALNETID0}
#neutron router-interface-add ${PUBLICROUTER0} ${PUBLICSUBNET0}
