#!/bin/bash


$YUM -y install git subversion policycoreutils-python ntp puppet

# Sync clock with ntp server (vm's tend to have their clock lag behind)
chkconfig --level 235 ntpd on
service ntpd start

# copy the puppet modules in the correct folder
cp -r $OC_BASEDIR/configs/puppet/modules/* /etc/puppet/modules/.
