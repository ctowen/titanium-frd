id=`system host-list | grep -i none |awk '{print $2}'`
mgmt_mac=`system host-show ${id} | grep mgmt_mac | awk '{print $4}'`
system host-add -p controller -m ${mgmt_mac} -o graphical -c tty1
