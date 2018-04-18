export CONTROLLER=controller-0
export LOCAL_STORAGE_DEV=nvme

# Add local volume group
system host-lvg-add ${CONTROLLER} nova-local

# Assign a physical volume to nova-local
dev_uuid=`system host-disk-list ${CONTROLLER} | grep -i ${LOCAL_STORAGE_DEV} | awk '{print $2}'`
system host-pv-add ${CONTROLLER} nova-local ${dev_uuid}
