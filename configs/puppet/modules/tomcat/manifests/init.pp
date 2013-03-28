class tomcat {
    package {'tomcat6':
      ensure  => installed,
      require => Package['java-1.6.0-openjdk','mysql-connector-java'],
    }

    package {'java-1.6.0-openjdk':
      ensure => installed,
    }

    package {'mysql-connector-java':
      ensure => installed,
    }

    file { '/etc/tomcat6/server.xml':
      source  => 'puppet:///modules/tomcat/server.xml',
      notify  => Service['tomcat6'],
      require => Package['tomcat6'],
    }

    file { '/etc/tomcat6/catalina.properties':
      source  => 'puppet:///modules/tomcat/catalina.properties',
      notify  => Service['tomcat6'],
      require => Package['tomcat6'],
    }

    file { '/etc/tomcat6/tomcat6.conf':
      source  => 'puppet:///modules/tomcat/tomcat6.conf',
      notify  => Service['tomcat6'],
      require => Package['tomcat6'],
    }

    file { '/etc/tomcat6/tomcat-users.xml':
      source  => 'puppet:///modules/tomcat/tomcat-users.xml',
      notify  => Service['tomcat6'],
      require => Package['tomcat6'],
    }

    file { '/etc/tomcat6/classpath_properties/log4j.xml':
      source  => 'puppet:///modules/tomcat/log4j.xml',
      notify  => Service['tomcat6'],
      require => Package['tomcat6'],
    }

    file { '/etc/tomcat6/classpath_properties':
      ensure  => 'directory',
      mode    => '755',
      require => Package['tomcat6'],
    }

    file { '/usr/share/tomcat6/wars':
      ensure  => 'directory',
      mode    => '755',
      require => Package['tomcat6'],
    }

    file { '/opt/tomcat':
      ensure   => 'link',
      target   => '/usr/share/tomcat6',
      mode     => '777',
      require => Package['tomcat6'],
    }

    file { ['/usr/share/tomcat6/shared/lib','/usr/share/tomcat6/shared']:
      ensure  => 'directory',
      mode    => '755',
      require => Package['tomcat6'],
      before  => File['/usr/share/tomcat6/shared/lib/mysql-connector-java.jar'],
    }

    file { '/usr/share/tomcat6/shared/lib/mysql-connector-java.jar':
      ensure   => 'link',
      target   => '/usr/share/java/mysql-connector-java.jar',
      mode     => '777',
      require  => Package['tomcat6','mysql-connector-java'],
      notify   => Service['tomcat6'],
    }

    service { 'tomcat6':
      ensure     => running,
      enable     => true,
      hasrestart => true,
      hasstatus  => true,
    }
}
