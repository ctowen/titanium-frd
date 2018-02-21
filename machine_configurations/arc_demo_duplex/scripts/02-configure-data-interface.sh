# Configure the data interfaces
export COMPUTE=controller-0
export NORTH-SOUTH=north-south
system host-if-modify -m 1500 -n data0 -p ${NORTH-SOUTH} -nt data ${COMPUTE} enp1s0f1
