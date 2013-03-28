#!/bin/sh

echo "Installing packages for Tomcat. This may take several minutes. (depending on available bandwidth)"
#installation of tomcat is handled by puppet

#make sure puppet is in the repositories
if ! rpm -qi puppetlabs-release > /dev/null
then
	rpm -ivh http://yum.puppetlabs.com/el/6/products/i386/puppetlabs-release-6-6.noarch.rpm
fi

$YUM -y install puppet

/usr/bin/puppet apply -e "include tomcat"

if keytool -list -alias 'openconext cacert' -keystore /etc/pki/java/cacerts \
    -storepass changeit -noprompt > /dev/null
then
    keytool -delete -alias "openconext cacert" \
      -keystore /etc/pki/java/cacerts -storepass changeit -noprompt > /dev/null
fi

keytool -import -file /etc/httpd/keys/openconext_ca.pem \
  -trustcacerts -alias "openconext cacert" \
  -keystore /etc/pki/java/cacerts -storepass changeit -noprompt

service tomcat6 stop
sleep 5
if ps faxuww | egrep -a '^tomcat '
then
  killall -q -9 -u tomcat  java
fi
sleep 2

# Remove possibly previously installed webapps and caches
rm -Rf $CATALINA_HOME/webapps/*
rm -Rf $CATALINA_HOME/work/*
rm -Rf $CATALINA_HOME/conf/Catalina/*
