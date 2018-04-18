#!/bin/bash -eu

VERBOSE_LEVEL=1
DEBUG_LEVEL=0
SCRIPTNAME=$(basename $0)
LOGFILENAME="${SCRIPTNAME%.*}.log"
LOG_FILE=${LOG_FILE:-"${HOME}/${LOGFILENAME}"}
SHARED_PCPU=0
IMAGE_DIR="/opt/backups/images"
OPENRC="/etc/nova/openrc"
CLI_NOWRAP=--nowrap
FORCE="no"
GROUPNO=0
STATUS_FILE=${STATUS_FILE:-"${HOME}/.lab_setup.done"}
GROUP_STATUS=${STATUS_FILE}.group${GROUPNO}
SMALL_SYSTEM="no"
CONFIG_FILE=""

TENANT1=tenant1
TENANT2=tenant2
TENANTS=("${TENANT1}" "${TENANT2}")

# Settings that can be overidden with with config file
EXTERNAL_NETWORK_CIDR=10.10.10.0/23
EXTERNAL_NETWORK_GATEWAY=10.10.10.1
EXTERNAL_NETWORK_ROUTER_IP=10.10.10.220
EXTERNAL_NETWORK_FLOAT_START=10.10.10.221
EXTERNAL_NETWORK_FLOAT_END=10.10.10.254
EXTERNAL_NETWORK_VLAN=10

EAST_WEST_VLAN_START=400
EAST_WEST_VLAN_END=449

LOCAL_STORAGE_DEV=nvme

LOAD_IMAGES="yes"
CREATE_VOLUMES="yes"

# PCI Address of second NIC port - used for data
DATA0PCIADDR='0000:02:00.1'

while getopts :f:av OPT; do
    case $OPT in
        f|+f)
            CONFIG_FILE="$OPTARG"
            ALL_TENANTS=0
            ;;
        a|+a)
            ALL_TENANTS_NO_PROMPT=1
            ;;
        v|+v)
            VERBOSE_LEVEL=$((VERBOSE_LEVEL + 1 ))
            ;;
        *)
            echo "usage: ${0##*/} [-f config_file] [-a] [-v] [--] ARGS..."
            exit 2
    esac
done

## Executes a command and logs the output
function log_command()
{
    local CMD=$1

    set +e
    if [ ${VERBOSE_LEVEL} -gt 0 ]; then
        echo "RUNNING: ${CMD}" 2>&1 | tee -a ${LOG_FILE}
    else
        echo "RUNNING: ${CMD}" &>> ${LOG_FILE}
    fi

    if [ ${VERBOSE_LEVEL} -gt 1 ]; then
        eval ${CMD} 2>&1 | tee -a ${LOG_FILE}
        RET=${PIPESTATUS[0]}
    else
        eval ${CMD} &>> ${LOG_FILE}
        RET=$?
    fi

    if [ ${RET} -ne 0 ]; then
        echo "FAILED (rc=${RET}): ${CMD}"
        exit 1
    fi
    set -e

    return ${RET}
}

## Log a message to screen if verbose enabled
function log()
{
    local MSG="$1"
    
    if [ ${VERBOSE_LEVEL} -gt 1 ]; then
        echo ${MSG} | tee -a ${LOG_FILE}
    else
        echo ${MSG} &>> ${LOG_FILE}
    fi
}

## Log a message to screen if debug enabled
function debug()
{
    local MSG="$1"
    
    if [ ${DEBUG_LEVEL} -ge 1 ]; then
        echo ${MSG} | tee -a ${LOG_FILE}
    else
        echo ${MSG} &>> ${LOG_FILE}
    fi
}

## Log a message to screen and file
function info()
{
    local MSG="$1"
    
    echo ${MSG} | tee -a ${LOG_FILE}
}

## Log a message to file and stdout
function log_warning()
{
    local MSG="$1"
    
    echo "WARNING: ${MSG}" | tee -a ${LOG_FILE}
}

if [ -n "$CONFIG_FILE" ]; then
    log "Using overrides in ${CONFIG_FILE}"
    source ${CONFIG_FILE}
fi

## Retrieve the image id for an image name
function get_glance_id()
{
    local NAME=$1
#    echo $(glance image-show ${NAME} 2>/dev/null | awk '{ if ($2 == "id") {print $4} }')
    echo $(glance image-list 2>/dev/null | grep " ${NAME} " | awk '{print $2}')
}

## Retrieve the image id for a volume name
function get_cinder_id()
{
    local NAME=$1
    echo $(cinder show ${NAME} 2>/dev/null | awk '{ if ($2 == "id") {print $4} }')
}

## Retrieve the status for a volume name
function get_cinder_status()
{
    local NAME=$1
    echo $(cinder show ${NAME} 2>/dev/null | awk '{ if ($2 == "status") {print $4} }')
}

## Retrieve the flavor id for a flavor name
function get_flavor_id()
{
    local NAME=$1
    echo $(nova flavor-show ${NAME} 2>/dev/null | grep "| id" | awk '{print $4}')
}
    
## Retrieve the tenant id for a tenant name
function get_tenant_id()
{
    local NAME=$1
    echo $(openstack project show ${NAME} 2>/dev/null | grep " id   " | awk '{print $4}')
}

## Retrieve the network id for a network name
function get_network_id()
{
    local NAME=$1
    echo $(neutron net-show ${NAME} -F id 2>/dev/null | grep id | awk '{print $4}')
}

## Retrieve the subnet id for a subnet name
function get_subnet_id()
{
    local NAME=$1
    echo $(neutron subnet-show ${NAME} -F id 2>/dev/null | grep id | awk '{print $4}')
}

## Retrieve the router id for a router name
function get_router_id()
{
    local NAME=$1
    echo $(neutron router-show ${NAME} -F id 2>/dev/null | grep id | awk '{print $4}')
}

## Retrieve the providernet id for a providernet name
function get_provider_network_id()
{
    local NAME=$1
    echo $(neutron providernet-show ${NAME} -F id 2>/dev/null | grep id | awk '{print $4}')
}

## Retrieve the providernet id for a providernet name
function get_provider_network_range_id()
{
    local NAME=$1
    echo $(neutron providernet-range-show ${NAME} -F id 2>/dev/null | grep id | awk '{print $4}')
}

## Determine whether one of the setup stages has already completed
function is_stage_complete()
{
    local STAGE=$1
    local NODE=${2:-""}
    local FILE=""

    if [ "${FORCE}" == "no" ]; then
        if [ -z "${NODE}" ]; then
            FILE=${GROUP_STATUS}.${STAGE}
        else
            FILE=${GROUP_STATUS}.${NODE}.${STAGE}
        fi
        if [ -f ${FILE} ]; then
            return 0
        fi
    fi

    return 1
}

## Mark a stage as complete
function stage_complete()
{
    local STAGE=$1
    local NODE=${2:-""}
    local FILE=""

    if [ -z "${NODE}" ]; then
        FILE=${GROUP_STATUS}.${STAGE}
    else
        FILE=${GROUP_STATUS}.${NODE}.${STAGE}
    fi

    touch ${FILE}

    return 0
}

DPDK_VCPUMODEL="SandyBridge"
DEDICATED_CPUS="hw:cpu_policy=dedicated"
SHARED_CPUS="hw:cpu_policy=shared"
DPDK_CPU="hw:cpu_model=${DPDK_VCPUMODEL}"

if [ ${SHARED_PCPU} -ne 0 ]; then
    SHARED_VCPU="hw:wrs:shared_vcpu=0"
else
    SHARED_VCPU=""
fi

function flavor_create()
{
    local NAME=$1
    local ID=$2
    local MEM=$3
    local DISK=$4
    local CPU=$5

    shift 5
    local USER_ARGS=$*
    local DEFAULT_ARGS="hw:mem_page_size=2048"

    local X=$(get_flavor_id ${NAME})
    if [ -z "${X}" ]; then
        log "Creating flavor ${NAME}"
        log_command "nova flavor-create ${NAME} ${ID} ${MEM} ${DISK} ${CPU}"
        RET=$?
        if [ ${RET} -ne 0 ]; then
            echo "Failed to create flavor: ${NAME}"
            exit ${RET}
        fi

        log_command "nova flavor-key ${NAME} set ${USER_ARGS} ${DEFAULT_ARGS}"
        RET=$?
        if [ ${RET} -ne 0 ]; then
            echo "Failed to set ${NAME} extra specs: ${USER_ARGS} ${DEFAULT_ARGS}"
            exit ${RET}
        fi
    fi

    return 0
}

function keypair_create()
{
    local KEYNAME=$1
    local PUBKEY=$2

    echo "${PUBKEY}" >/home/wrsroot/${KEYNAME}.pub

    ID=`nova keypair-list | grep -E " ${KEYNAME} " | awk '{print $2}'`
    if [ -z "${ID}" ]; then
        log "Creating keypair ${KEYNAME}"
        log_command "nova keypair-add --pub-key /home/wrsroot/${KEYNAME}.pub ${KEYNAME}"
    fi

    return 0
}

CINDER_TIMEOUT=7200

## Create a single cinder volume if it doesn't already exist
##
function create_cinder_volume()
{
    local IMAGE=$1
    local NAME=$2
    local SIZE=$3

    local GLANCE_ID=$(get_glance_id ${IMAGE})
    if [ -z "${GLANCE_ID}" ]; then
        echo "No glance image with name: ${IMAGE}"
        return 1
    fi

    ID=$(get_cinder_id "vol-${NAME}")
    if [ -z "${ID}" ]; then
        log "Creating volume vol-${NAME}"
        log_command "cinder create --image-id ${GLANCE_ID} --display-name=vol-${NAME} ${SIZE}"
        RET=$?
        if [ ${RET} -ne 0 ]; then
            echo "Failed to create cinder volume 'vol-${NAME}'"
            return ${RET}
        fi

        # Wait for the volume to be created
        DELAY=0
        sleep 2
        while [ $DELAY -lt ${CINDER_TIMEOUT} ]; do
            STATUS=$(get_cinder_status "vol-${NAME}")
            if [ ${STATUS} == "downloading" -o ${STATUS} == "creating" ]; then
                DELAY=$((DELAY + 5))
                sleep 5
            elif [ ${STATUS} == "available" ]; then
                log "Success"
                return 0
            else
                log "Failed"
                return 1
            fi
            echo "waiting for ${NAME} - ${DELAY}..."
        done

        log "Volume creation timed out: 'vol-${NAME}'"
        return 1
    fi

    return 0
}

## Create a single glance image if it doesn't already exist
##
function create_glance_image()
{
    local NAME=$1
    local FILENAME=$2
    local IMAGETYPE=$3

    ID=$(get_glance_id "${NAME}")
    if [ -z "${ID}" ]; then
        log "Creating image ${NAME}"
        log_command "glance image-create --name ${NAME} --visibility public \
--container-format bare --disk-format ${IMAGETYPE} \
--progress --file ${FILENAME}"

        RET=$?
        if [ ${RET} -ne 0 ]; then
            echo "Failed to create glance image '${NAME}'"
            return ${RET}
        fi
    fi

    return 0
}

## Create a single glance image if it doesn't already exist
##
function create_glance_image_windows()
{
    local NAME=$1
    local FILENAME=$2
    local IMAGETYPE=$3

    ID=$(get_glance_id "${NAME}")
    if [ -z "${ID}" ]; then
        log "Creating image ${NAME}"
        log_command "glance image-create --name ${NAME} --visibility public \
--container-format bare --disk-format ${IMAGETYPE} \
--property os_type=windows \
--progress --file ${FILENAME}"

        RET=$?
        if [ ${RET} -ne 0 ]; then
            echo "Failed to create glance image '${NAME}'"
            return ${RET}
        fi
    fi

    return 0
}

function get_user_id()
{
    local NAME=$1
    echo $(openstack user show ${NAME} -c id 2>/dev/null | grep id | awk '{print $4}')
}

## Retrieve the user roles for a tenant and user
function get_user_roles()
{
    local TENANT=$1
    local USERNAME=$2
    echo $(openstack role list --project ${TENANT} --user ${USERNAME} 2>/dev/null | grep ${USERNAME} | awk '{print $4}')
}

function create_tenant_user_role()
{
    local TENANT=$1

    ADMIN_USER="admin"
    MEMBER_ROLE="_member_"
    OPENSTACK_PROJECT_DOMAIN="Default"
    OPENSTACK_USER_DOMAIN="Default"

    ID=$(get_tenant_id "${TENANT}")
    if [ -z "${ID}" ]; then
        log "Creating project ${TENANT}"
        #log_command "openstack project create --domain default --description ${TENANT} ${TENANT}"
        #log_command "openstack user create --domain default --password-prompt ${TENANT}"
        #log_command "openstack role add --project ${TENANT} --user ${TENANT} user"

        ## Create the project if it does not exist
        TENANTID=$(get_tenant_id ${TENANT})
        if [ -z "${TENANTID}" ]; then
            log_command "openstack project create \
--domain ${OPENSTACK_PROJECT_DOMAIN} --description ${TENANT} ${TENANT}"
        fi

        ## Create the user if it does not exist
        USERID=$(get_user_id ${TENANT})
        if [ -z "${USERID}" ]; then
            log_command "openstack user create \
--password ${TENANT} --domain ${OPENSTACK_USER_DOMAIN} --project ${TENANT} \
--project-domain ${OPENSTACK_PROJECT_DOMAIN} \
--email ${TENANT}@noreply.com ${TENANT}"
        fi

        ## Ensure tenant user is a member of the project
        ROLES=$(get_user_roles ${TENANT} ${TENANT})
        if [[ ! $ROLES =~ ${MEMBER_ROLE} ]]; then
            log_command "openstack role add --project ${TENANT} \
--project-domain ${OPENSTACK_PROJECT_DOMAIN} --user ${TENANT} \
--user-domain ${OPENSTACK_USER_DOMAIN} ${MEMBER_ROLE}"
        fi

        ## Add the admin user to each group/project so that all projects can be
        ## accessed from Horizon without needing to logout/login again.
        ROLES=$(get_user_roles ${TENANT} ${ADMIN_USER})
        if [[ ! $ROLES =~ ${MEMBER_ROLE} ]]; then
            log_command "openstack role add --project ${TENANT} \
--project-domain ${OPENSTACK_PROJECT_DOMAIN} --user ${ADMIN_USER} \
--user-domain ${OPENSTACK_USER_DOMAIN} ${MEMBER_ROLE}"
        fi

        TENANTID=$(get_tenant_id ${TENANT})
        log_command "neutron quota-update --subnet 10 --network 5 --port 20 --floatingip 5 --security-group 20 --tenant-id ${TENANTID}"
        log_command "nova quota-update ${TENANTID} --instances 20 --cores 50"
        log_command "cinder quota-update ${TENANTID} --volumes 50 --snapshots 50"

	# NOTE:  THIS IS FOR SIMPLEX
        cat << EOF > openrc-${TENANT}
unset OS_SERVICE_TOKEN
export OS_AUTH_URL=http://127.168.204.3:5000/v3
export OS_ENDPOINT_TYPE=internalURL
export CINDER_ENDPOINT_TYPE=internalURL

export OS_USERNAME=${TENANT}
export OS_PASSWORD=${TENANT}
export PS1='[\u@\h \W(keystone_${TENANT})]\$ '

export OS_PROJECT_NAME=${TENANT}
export OS_USER_DOMAIN_NAME=Default
export OS_PROJECT_DOMAIN_NAME=Default
export OS_IDENTITY_API_VERSION=3
export OS_REGION_NAME=RegionOne
export OS_INTERFACE=internal
EOF

        RET=$?
        if [ ${RET} -ne 0 ]; then
            echo "Failed to create tenant '${TENANT}'"
            return ${RET}
        fi
    fi

    return 0
}

function create_providernet()
{
    local NAME=$1

    ID=$(get_provider_network_id "${NAME}")
    if [ -z "${ID}" ]; then
        log "Creating providernet ${NAME}"
        log_command "neutron providernet-create ${NAME} --type vlan --vlan-transparent=True"

        RET=$?
        if [ ${RET} -ne 0 ]; then
            echo "Failed to create providernet '${NAME}'"
            return ${RET}
        fi
    fi

    return 0
}

function create_providernet_range()
{
    local PNETNAME=$1
    local PNETRANGENAME=$2
    local PNETRANGE=$3
    local OWNER=$4

    OWNER_ARGS="--shared"
    if [ "${OWNER}" != "shared" ]; then
        OWNER_ARGS="--tenant-id $(get_tenant_id ${OWNER})"
    fi

    ID=$(get_provider_network_range_id "${PNETRANGENAME}")
    if [ -z "${ID}" ]; then
        log "Creating providernet range ${PNETNAME}"
        log_command "neutron providernet-range-create ${PNETNAME} --name ${PNETRANGENAME} --range ${PNETRANGE} ${OWNER_ARGS}"

        RET=$?
        if [ ${RET} -ne 0 ]; then
            echo "Failed to create providernet '${PNETNAME}'"
            return ${RET}
        fi
    fi

    return 0
}

function create_data_interface()
{
    local COMPUTE=$1
    local PNETNAME=$2
    local IFNAME=$3
    local PCIADDR=$4

    PORTNAME=`system host-port-list ${COMPUTE} | grep ${PCIADDR} | awk '{print $4}'`
    #IFUUID=`system host-if-list -a ${COMPUTE} | awk -v PORTNAME=[u\'$PORTNAME\'] '($12 ~ PORTNAME) {print $2}'`
    IFUUID=`system host-if-list -a ${COMPUTE} | grep ${PORTNAME} | awk '{print $2}'`

    if [ -n "${IFUUID}" ]; then
 	IFTEST=`system host-if-list -a ${COMPUTE} | grep ${IFNAME} | awk '{print $2}'`
        if [ -z "${IFTEST}" ]; then
            log "Creating data interface for ${COMPUTE} ${IFNAME} on ${PNETNAME} for ${PORTNAME} using ${PCIADDR}"
            log_command "system host-if-modify -n ${IFNAME} -p ${PNETNAME} -nt data ${COMPUTE} ${IFUUID}"

            RET=$?
            if [ ${RET} -ne 0 ]; then
                echo "Failed to create data interface '${PNETNAME}'"
                return ${RET}
            fi
        fi
    fi

    return 0
}

function create_passthrough_interface()
{
    local COMPUTE=$1
    local PNETNAME=$2
    local IFNAME=$3
    local PCIADDR=$4

    PORTNAME=`system host-port-list ${COMPUTE} | grep ${PCIADDR} | awk '{print $4}'`
    #IFUUID=`system host-if-list -a ${COMPUTE} | awk -v PORTNAME=[u\'$PORTNAME\'] '($12 ~ PORTNAME) {print $2}'`
    IFUUID=`system host-if-list -a ${COMPUTE} | grep ${PORTNAME} | awk '{print $2}'`

    if [ -n "${IFUUID}" ]; then
 	IFTEST=`system host-if-list -a ${COMPUTE} | grep ${IFNAME} | awk '{print $2}'`
        if [ -z "${IFTEST}" ]; then
            log "Creating data interface for ${COMPUTE} ${IFNAME} on ${PNETNAME} for ${PORTNAME} using ${PCIADDR}"
            log_command "system host-if-modify -n ${IFNAME} -p ${PNETNAME} -nt pci-passthrough ${COMPUTE} ${IFUUID}"

            RET=$?
            if [ ${RET} -ne 0 ]; then
                echo "Failed to create data interface '${PNETNAME}'"
                return ${RET}
            fi
        fi
    fi

    return 0
}

function create_infra_interface()
{
    local COMPUTE=$1
    local IFNAME=$2
    local PCIADDR=$3

    PORTNAME=`system host-port-list ${COMPUTE} | grep ${PCIADDR} | awk '{print $4}'`
    #IFUUID=`system host-if-list -a ${COMPUTE} | awk -v PORTNAME=[u\'$PORTNAME\'] '($12 ~ PORTNAME) {print $2}'`
    IFUUID=`system host-if-list -a ${COMPUTE} | grep ${PORTNAME} | awk '{print $2}'`

    if [ -n "${IFUUID}" ]; then
 	IFTEST=`system host-if-list -a ${COMPUTE} | grep ${IFNAME} | awk '{print $2}'`
        if [ -z "${IFTEST}" ]; then
            log "Creating infra interface for ${COMPUTE} ${IFNAME} for ${PORTNAME} using ${PCIADDR}"
            log_command "system host-if-modify -m 1500 -n ${IFNAME} -nt infra ${COMPUTE} ${IFUUID}"

            RET=$?
            if [ ${RET} -ne 0 ]; then
                echo "Failed to create data interface '${PNETNAME}'"
                return ${RET}
            fi
        fi
    fi

    return 0
}

function create_infra_interface_vlan()
{
    local COMPUTE=$1
    local IFNAME=$2
    local PCIADDR=$3
    local VLANID=$4

    PORTNAME=`system host-port-list ${COMPUTE} | grep ${PCIADDR} | awk '{print $4}'`
    #IFUUID=`system host-if-list -a ${COMPUTE} | awk -v PORTNAME=[u\'$PORTNAME\'] '($12 ~ PORTNAME) {print $2}'`
    IFUUID=`system host-if-list -a ${COMPUTE} | grep ${PORTNAME} | awk '{print $2}'`

    if [ -n "${IFUUID}" ]; then
 	IFTEST=`system host-if-list -a ${COMPUTE} | grep ${IFNAME} | awk '{print $2}'`
        if [ -z "${IFTEST}" ]; then
            log "Creating infra interface for ${COMPUTE} ${IFNAME} for ${PORTNAME} on VLAN ${VLANID} using ${PCIADDR}"
            log_command "system host-if-add -V ${VLANID} -nt infra ${COMPUTE} ${IFNAME} vlan ${IFUUID}"

            RET=$?
            if [ ${RET} -ne 0 ]; then
                echo "Failed to create data interface '${PNETNAME}'"
                return ${RET}
            fi
        fi
    fi

    return 0
}

function set_system_name()
{
    local NAME=$1
    local DESCRIPTION="${NAME}: setup by Colo-Init-Script-Hudson.sh"

    source ${OPENRC}
    log_command "system modify name=${NAME} description=\"${DESCRIPTION}\""
    RET=$?
    return ${RET}
}

## Set the DNS configuration
##
function set_dns()
{
    if is_stage_complete "dns"; then
        info "Skipping DNS configuration; already done"
        return 0
    fi
    echo "Setting DNS configuration"
    source ${OPENRC}
    log_command "system dns-modify nameservers=${NAMESERVERS} action=apply"
    RET=$?
    stage_complete "dns"
    return ${RET}
}

## Set the NTP configuration
##
function set_ntp()
{
    if is_stage_complete "ntp"; then
        info "Skipping NTP configuration; already done"
        return 0
    fi
    echo "Setting NTP configuration"
    source ${OPENRC}
    log_command "system ntp-modify ntpservers=${NTPSERVERS}"
    RET=$?
    stage_complete "ntp"
    return ${RET}
}

## Set the switch cores configuration
##
function set_platform_cores()
{
    local NODE=$1
    local CORES=$2

    if is_stage_complete "platform_cores" ${NODE}; then
        info "Skipping platform core config; already done"
        return 0
    fi
    echo "Setting platform core configuration"
    source ${OPENRC}
    log_command "system host-cpu-modify -f platform -p0 ${CORES} ${NODE}"
    RET=$?
    stage_complete "platform_cores" ${NODE}
    return ${RET}
}

## Setup keys
##
function setup_keys()
{
    local PRIVKEY="${HOME}/.ssh/id_rsa"
    local PUBKEY="${PRIVKEY}.pub"
    local KEYNAME=""
    local TENANT=""
    local ID=""

    if is_stage_complete "public_keys"; then
        info "Skipping public key configuration; already done"
        return 0
    fi

    echo "Adding VM public keys"

    if [ -f ${HOME}/id_rsa.pub ]; then
        ## Use a user defined public key instead of the local user public key
        ## if one is found in the home directory
        PUBKEY="${HOME}/id_rsa.pub"
    elif [ ! -f ${PRIVKEY} ]; then
        log "Generating new SSH key pair for ${USER}"
        ssh-keygen -q -N "" -f ${PRIVKEY}
        RET=$?
        if [ ${RET} -ne 0 ]; then
	        echo "Failed to generate SSH key pair"
            return ${RET}
        fi
    fi

    for TENANT in ${TENANTS[@]}; do
        source ${HOME}/openrc.${TENANT}
        KEYNAME="keypair-${TENANT}"
        ID=`nova keypair-list | grep -E ${KEYNAME}[^0-9] | awk '{print $2}'`
        if [ -z "${ID}" ]; then
            log_command "nova keypair-add --pub-key ${PUBKEY} ${KEYNAME}"
        fi
    done

    stage_complete "public_keys"

    return 0
}

## Setup keys for admin tenant
##
function setup_keys_admin()
{
    local PRIVKEY="${HOME}/.ssh/id_rsa"
    local PUBKEY="${PRIVKEY}.pub"
    local KEYNAME=""
    local TENANT="admin"
    local ID=""

    if is_stage_complete "public_keys_admin"; then
        info "Skipping public key configuration; already done"
        return 0
    fi

    echo "Adding VM public keys for admin"

    if [ -f ${HOME}/id_rsa.pub ]; then
        ## Use a user defined public key instead of the local user public key
        ## if one is found in the home directory
        PUBKEY="${HOME}/id_rsa.pub"
    elif [ ! -f ${PRIVKEY} ]; then
        log "Generating new SSH key pair for ${USER}"
        ssh-keygen -q -N "" -f ${PRIVKEY}
        RET=$?
        if [ ${RET} -ne 0 ]; then
	        echo "Failed to generate SSH key pair"
            return ${RET}
        fi
    fi

    source ${OPENRC}
    KEYNAME="keypair-${TENANT}"
    ID=`nova keypair-list | grep -E ${KEYNAME}[^0-9] | awk '{print $2}'`
    if [ -z "${ID}" ]; then
        log_command "nova keypair-add --pub-key ${PUBKEY} ${KEYNAME}"
    fi

    stage_complete "public_keys_admin"

    return 0
}

## Setup local storage on a single node
##
function setup_local_storage()
{
    local NODE=$1
    local MODE=$2
    local USE_ROOT=$3
    local XTRA_PVS=$4
    local LV_CALC_MODE=$5
    local LV_SIZE=$6
    local USE_ROOT=$3
    local XTRA_PVS=$4
    local LV_CALC_MODE=$5
    local LV_SIZE=$6

    if is_stage_complete "local_storage" ${NODE}; then
        info "Skipping local storage configuration for ${NODE}; already done"
        return 0
    fi

    # Special Case: Small system controller-0 (after running lab_cleanup)
    if [[ "${SMALL_SYSTEM}" == "yes" && "${NODE}" == "controller-0" ]]; then
        local NOVA_VG=$(system host-lvg-list ${NODE} ${CLI_NOWRAP} | awk '{if ($4 == "nova-local" && $6 == "provisioned") print $4}')
        if [ "${NOVA_VG}" == "nova-local" ]; then
            info "Skipping local storage configuration for ${NODE}; already done"
            return 0
        fi
    fi

    # Validate parameters: mode
    if [[ ${MODE} == local* || "${MODE}" == "remote" ]]; then
        info "Adding nova storage; Instance disks backed by ${MODE} storage for ${NODE}."
    else
        echo "ERROR: mode storage setting for ${NODE} is uknown: ${MODE}"
        return 3
    fi

    # Validate parameters: use_root
    if [[ "${USE_ROOT}" != "yes" && "${USE_ROOT}" != "no" ]]; then
        echo "ERROR: use_root storage setting for ${NODE} is unknown: ${USE_ROOT}"
        return 3
    fi

    # Validate parameters: make sure that at least one physical volume will be added
    if [[ "${USE_ROOT}" == "no" && "${XTRA_PVS}" == "none" ]]; then
        echo "ERROR: No physical volumes are specified for ${NODE}"
        return 3
    fi


    # Validate parameters: lv_calc_mode and lv_fixed_size
    if [ "${LV_CALC_MODE}" == "fixed" ]; then
        if [[ "${MODE}" == "local_lvm" && "${LV_SIZE}" == "0" ]]; then
            echo "ERROR: lv_fixed_size storage setting for ${NODE} is invalid: ${LV_SIZE}"
            return 3
        fi
    else
        echo "ERROR: lv_calc_mode storage setting for ${NODE} is unknown: ${LV_CALC_MODE}"
        return 3
    fi

    # Volume Group: Create the the nova-local volume group
    local NOVA_VG=$(system host-lvg-list ${NODE} ${CLI_NOWRAP} | awk '{if ($4 == "nova-local" && ($6 == "provisioned" || $6 ~ /adding/)) print $4}')
    if [ -z "${NOVA_VG}" ]; then
    log_command "system host-lvg-add ${NODE} nova-local"
    fi

    # Physical Volumes: Use the root disk partition
    if [ "${USE_ROOT}" == "yes" ]; then
        local ROOT_DISK=$(system host-show ${NODE} | grep rootfs | awk '{print $4}')
        local ROOT_DISK_UUID=$(system host-disk-list ${NODE} ${CLI_NOWRAP} | grep ${ROOT_DISK} | awk '{print $2}')

        if [ "${ROOT_DISK_UUID}" != "" ]; then
            local NOVA_PV=$(system host-pv-list ${NODE} ${CLI_NOWRAP} | grep nova-local | grep ${ROOT_DISK_UUID} | awk '{if ($10 == "provisioned" || $10 == "adding") print $4}')
            if [ -z ${NOVA_PV} ]; then
                # Adding the root disk will always result in failure. We'll ignore the failure and check that it's been added
                log_command "system host-pv-add ${NODE} nova-local ${ROOT_DISK_UUID} || true"
                local NOVA_PV=$(system host-pv-list ${NODE} ${CLI_NOWRAP} | grep nova-local | grep ${ROOT_DISK_UUID} | awk '{if ($10 == "provisioned" || $10 == "adding") print $4}')
                if [ -z ${NOVA_PV} ]; then
                    #We tried to add the rootfs and it's not there. Return an error.
                    echo "ERROR: could not add the rootfs disk to nova-local"
                    return 1
                fi
            fi

        else
            echo "ERROR: could not find the rootfs disk (${ROOT_DISK}) UUID for ${NODE}"
            return 4
        fi
    fi

    # Physical Volumes: Process the extra disks
    if [ "${XTRA_PVS}" != "none" ]; then
        local DISK_ARRAY=(${XTRA_PVS//,/ })
        for DINDEX in ${!DISK_ARRAY[@]}; do
            local DISK_UUID=$(system host-disk-list ${NODE} ${CLI_NOWRAP} | grep ${DISK_ARRAY[${DINDEX}]} | awk '{print $2}')

            if [ "${DISK_UUID}" != "" ]; then
                # Skip the root disk if it's part of the extra disks as it's already added
                if [[ "${USE_ROOT}" == "yes"  && "${DISK_UUID}" == "${ROOT_DISK_UUID}" ]]; then
                    continue
                fi
                # Add the addition physical volume
                local NOVA_PV=$(system host-pv-list ${NODE} ${CLI_NOWRAP} | grep nova-local | grep ${DISK_UUID} | awk '{if ($10 == "provisioned" || $10 == "adding") print $4}')
                if [ -z ${NOVA_PV} ];then 
                log_command "system host-pv-add ${NODE} nova-local ${DISK_UUID}"
                fi
            else
                echo "ERROR: could not find the disk (${DISK_ARRAY[${DINDEX}]}) UUID for ${NODE}"
                return 4
            fi
        done
    fi

    # Set instances LV parameter
    if [ "${MODE}" == "local_lvm" ]; then
        log_command "system host-lvg-modify ${NODE} nova-local -b lvm -s ${LV_SIZE}"
    elif [ "${MODE}" == "local_image" ]; then 
        log_command "system host-lvg-modify ${NODE} nova-local -b image"
    elif [ "${MODE}" == "remote" ]; then 
        log_command "system host-lvg-modify ${NODE} nova-local -b remote"
    fi

    stage_complete "local_storage" ${NODE}

    return 0
}


############################# Set System #############################

source ${OPENRC}

log_command "set_system_name Titanium-Control-Simplex"
NAMESERVERS="9.9.9.9,8.8.8.8,8.8.4.4"
set_dns
#NTPSERVERS="0.pool.ntp.org,1.pool.ntp.org,2.pool.ntp.org"
#set_ntp

############################# Set Quotas #############################

TENANT="admin"
TENANTID=$(get_tenant_id ${TENANT})
ADMINID=$(get_tenant_id ${TENANT})
#log_command "neutron quota-update --subnet 100 --network 50 --port 200 --floatingip 50 --security-group 20 --tenant-id ${TENANTID}"
#log_command "nova quota-update ${TENANTID} --instances 50 --cores 100"
#log_command "cinder quota-update ${TENANTID} --volumes 50 --snapshots 50"


############################# Create Images #############################
echo "Creating Images"

source ${OPENRC}

# Generic OS images
if [ "${LOAD_IMAGES}" == "yes" ]; then
    IMAGENAME=Windows-Server-2012
    IMAGEFILE=windows_server_2012_r2_standard_eval_kvm.qcow2
    create_glance_image_windows ${IMAGENAME} ${IMAGE_DIR}/${IMAGEFILE} qcow2

    IMAGENAME=Ubuntu-16.04-Cloud-Image
    IMAGEFILE=xenial-server-cloudimg-amd64-disk1.img
    create_glance_image ${IMAGENAME} ${IMAGE_DIR}/${IMAGEFILE} qcow2
fi

############################# Create Flavors #############################
#
echo "Creating Flavors"

source ${OPENRC}
flavor_create embedded 101 64 0 1
flavor_create small 102 1024 0 1
flavor_create medium 103 2048 0 1
flavor_create large 104 4096 0 1
flavor_create embedded-smp 201 64 0 2
flavor_create small-smp 202 1024 0 2
flavor_create medium-smp 203 2048 0 2
flavor_create large-smp 204 4096 0 2

############################# Create Volumes #############################
#
# create_cinder_volume ${IMAGE} $NAME} ${SIZE}

echo "Creating Volumes"

if [ "${CREATE_VOLUMES}" == "yes" ]; then
    source ${OPENRC}
    VMNAME=Windows-Server-2012
    VOLSIZE=40
    VOLNAME=vol-${VMNAME}-1
    IMAGENAME=${VMNAME}
    create_cinder_volume ${IMAGENAME} ${VOLNAME} ${VOLSIZE}

    VMNAME=Ubuntu-16.04-Cloud-Image
    VOLSIZE=10
    VOLNAME=vol-${VMNAME}-1
    IMAGENAME=${VMNAME}
    create_cinder_volume ${IMAGENAME} ${VOLNAME} ${VOLSIZE}
fi

############################# Create Keypairs #############################
#
echo "Creating Keypairs"

# Note:  Keypairs will be created for the machine this script is running on

source ${OPENRC}

setup_keys_admin

############################# Platform Cores #############################
#
# Set number of platform cores to 1 so 4 logical cores for VMs
NODE="controller-0"
set_platform_cores ${NODE} 1

############################# Configure Storage #############################
#
NODE="controller-0"
setup_local_storage ${NODE} local_image no ${LOCAL_STORAGE_DEV} fixed 51200

############################# Configure Compute Nodes #############################
#
echo "Creating Data Interfaces on compute nodes"

source ${OPENRC}

NORTH_SOUTH='north-south'
EAST_WEST='east-west'
create_providernet ${NORTH_SOUTH}
create_providernet ${EAST_WEST}

create_providernet_range ${NORTH_SOUTH} ${NORTH_SOUTH} ${EXTERNAL_NETWORK_VLAN}-${EXTERNAL_NETWORK_VLAN} shared
create_providernet_range ${EAST_WEST} ${EAST_WEST} ${EAST_WEST_VLAN_START}-${EAST_WEST_VLAN_END} shared

# Data Port 1 reserved for mgmt on duplex (not used on simplex)
# Data Port 2 used for providernets
NODE="controller-0"
DATA0="data0"

create_data_interface ${NODE} "${NORTH_SOUTH},${EAST_WEST}" ${DATA0} ${DATA0PCIADDR}

############################# Configure Storage #############################
#
FILE=${HOME}/.lab_setup.interfaces
if [ ! -f ${FILE} ]; then
    touch ${FILE}
    echo ""aafe524a-fce2-4e4f-af7c-446b0713f76f
    echo "WARNING:"
    echo "Stopping after storage setup.  Rerun this command"
    echo "after controller unlocked and enabled."
    echo ""
    exit 0
fi


############################# Configure Networks #############################
#
echo "Creating Networks"

source ${OPENRC}

EXTERNALNET='external-net'
PUBLICNET='public-net'
INTERNALNET='internal-net'

EXTERNALSUBNET='external-subnet'
PUBLICSUBNET='public-subnet'
INTERNALSUBNET='internal-subnet'

# Create networks
X=$(get_network_id ${EXTERNALNET})
if [ -z "${X}" ]; then
    echo "Creating Network ${EXTERNALNET}"
    log_command "neutron net-create --tenant-id ${ADMINID} --provider:network_type=vlan --provider:physical_network=${NORTH_SOUTH} --provider:segmentation_id=${EXTERNAL_NETWORK_VLAN} --router:external ${EXTERNALNET}"
fi

X=$(get_network_id ${PUBLICNET})
if [ -z "${X}" ]; then
    echo "Creating Network ${PUBLICNET}"
    log_command "neutron net-create --tenant-id ${ADMINID} --provider:network_type=vlan --provider:physical_network=${EAST_WEST} --shared ${PUBLICNET}"
fi

X=$(get_network_id ${INTERNALNET})
if [ -z "${X}" ]; then
    echo "Creating Network ${INTERNALNET}"
    log_command "neutron net-create --tenant-id ${ADMINID} --provider:network_type=vlan --provider:physical_network=${EAST_WEST} --shared ${INTERNALNET}"
fi

# Create subnets
echo "Creating Subnets"
EXTERNALNETID=`neutron net-list | grep ${EXTERNALNET} | awk '{print $2}'`
PUBLICNETID=`neutron net-list | grep ${PUBLICNET} | awk '{print $2}'`
INTERNALNETID=`neutron net-list | grep ${INTERNALNET} | awk '{print $2}'`

# External subnet - Assuming relatively small range of IPs for floating IPs external router to do dhcp and gateway since OAM and EXTERNAL data net are on the same subnet
X=$(get_subnet_id ${EXTERNALSUBNET})
if [ -z "${X}" ]; then
    echo "Creating Subnet ${EXTERNALSUBNET}"
    log_command "neutron subnet-create --tenant-id ${ADMINID} --name ${EXTERNALSUBNET} --dns-nameserver 9.9.9.9 --dns-nameserver 8.8.8.8 --dns-nameserver 8.8.4.4 --allocation-pool start=${EXTERNAL_NETWORK_FLOAT_START},end=${EXTERNAL_NETWORK_FLOAT_END} --disable-dhcp --gateway ${EXTERNAL_NETWORK_GATEWAY} ${EXTERNALNET} ${EXTERNAL_NETWORK_CIDR}"
fi

X=$(get_subnet_id ${PUBLICSUBNET})
if [ -z "${X}" ]; then
    echo "Creating Subnet ${PUBLICSUBNET}"
    log_command "neutron subnet-create --tenant-id ${ADMINID} --name ${PUBLICSUBNET} --dns-nameserver 9.9.9.9 --dns-nameserver 8.8.8.8 --dns-nameserver 8.8.4.4 --allocation-pool start=10.10.20.2,end=10.10.20.254 --enable-dhcp --gateway 10.10.20.1 ${PUBLICNET} 10.10.20.0/24"
fi

X=$(get_subnet_id ${INTERNALSUBNET})
if [ -z "${X}" ]; then
    echo "Creating Subnet ${INTERNALSUBNET}"
    log_command "neutron subnet-create --tenant-id ${ADMINID} --name ${INTERNALSUBNET} --allocation-pool start=192.168.10.2,end=192.168.10.250 --enable-dhcp --gateway 192.168.10.1 ${INTERNALNET} 192.168.10.0/24"
fi

############################# CONFIGURE ROUTER #############################
#
echo "Creating Routers"

EXTERNALROUTER='external-router'
X=$(get_router_id ${EXTERNALROUTER})
if [ -z "${X}" ]; then
    echo "Creating Router ${EXTERNALROUTER}"
    log_command "neutron router-create ${EXTERNALROUTER}"

    EXTERNALROUTERID=`neutron router-list | grep ${EXTERNALROUTER} | awk '{print $2}'`
    log_command "neutron router-gateway-set --fixed-ip ip_address=${EXTERNAL_NETWORK_ROUTER_IP} ${EXTERNALROUTER} ${EXTERNALNETID}"

    # Add interfaces to router
    log_command "neutron router-interface-add ${EXTERNALROUTER} ${PUBLICSUBNET}"
fi


