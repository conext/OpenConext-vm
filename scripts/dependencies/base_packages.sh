#!/bin/bash

#make sure puppet is in the repositories
if ! rpm -qi puppetlabs-release > /dev/null
then
        rpm -ivh http://yum.puppetlabs.com/el/6/products/i386/puppetlabs-release-6-6.noarch.rpm
fi

$YUM -y install git subversion policycoreutils-python ntp puppet

# Sync clock with ntp server (vm's tend to have their clock lag behind)
chkconfig --level 235 ntpd on
service ntpd start

# copy the puppet modules in the correct folder
cp -r $OC_BASEDIR/configs/puppet/modules/* /etc/puppet/modules/.
