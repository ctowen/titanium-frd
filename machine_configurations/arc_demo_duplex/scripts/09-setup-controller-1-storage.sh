export CONTROLLER=controller-1
export CINDER_STORAGE_DEV=sdb
export LOCAL_STORAGE_DEV=nvme

# Create Cinder device
dev_uuid=`system host-disk-list ${CONTROLLER} | grep -i ${CINDER_STORAGE_DEV} | awk '{print $2}'`
system host-stor-add controller-1 cinder ${dev_uuid}

# Add local volume group
system host-lvg-add ${CONTROLLER} nova-local

# Assign a physical volume to nova-local
dev_uuid=`system host-disk-list ${CONTROLLER} | grep -i ${LOCAL_STORAGE_DEV} | awk '{print $2}'`
system host-pv-add ${CONTROLLER} nova-local ${dev_uuid}

# ??
system host-lvg-modify -b image ${CONTROLLER} nova-local
