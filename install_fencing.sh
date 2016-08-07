#!/bin/bash

curl -s https://raw.githubusercontent.com/sjafferali/fence_ec2/master/fence_ec2 > /usr/sbin/fence_ec2
curl -s https://raw.githubusercontent.com/sjafferali/fence_ec2/master/ha_log.sh > /usr/sbin/ha_log.sh
chmod -v 755 /usr/sbin/ha_log.sh /usr/sbin/fence_ec2

HOSTS_ONLINE=$(pcs status | egrep ^Online | awk '{print$3","$4}')
if [[ -z $(pcs stonith | grep ec2) ]]
then
  pcs stonith create ec2-fencing fence_ec2 pcmk_host_check="static-list" pcmk_host_list="$HOSTS_ONLINE" tag="Name" action="off" op monitor interval="600s" timeout="300s" op start start-delay="60s" interval="0"
  pcs property set stonith-enabled=true
fi  
