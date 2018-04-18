NORTH-SOUTH='north-south'
EAST-WEST='east-west'
neutron providernet-create ${NORTH-SOUTH} --type vlan
neutron providernet-range-create ${EAST-WEST} --name ${EAST-WEST} --range 400-409
neutron providernet-range-create ${NORTH-SOUTH} --name ${NORTH-SOUTH} --range 10-10 --shared
