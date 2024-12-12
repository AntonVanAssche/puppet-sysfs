# @summary A module for managing sysfs settings.
#
# @example A basic example:
#   include sysfs
#
#  @param settings
#    A hash of sysfs settings to apply.
#
# === Authors
#
# Dan Foster <dan@zem.org.uk>
#
# === Copyright
#
# Copyright 2015 Dan Foster, unless otherwise noted.
#
class sysfs (
  Optional[Hash] $settings = undef
) {
  package { 'sysfsutils':
    ensure => installed,
  }

  if ($facts['os']['family'] == 'RedHat') and (versioncmp($facts['os']['release']['full'], '7') >= 0) {
    file {
      default:
        owner => root,
        group => root,
        ;
      '/usr/local/bin/sysfs-reload':
        source => 'puppet:///modules/sysfs/sysfs-reload',
        mode   => '0700',
        before => File['/etc/systemd/system/sysfsutils.service']
        ;
      '/etc/systemd/system/sysfsutils.service':
        source => 'puppet:///modules/sysfs/sysfsutils.service',
        mode   => '0644',
        before => Service['sysfsutils'],
        ;
    }

    exec { 'sysfsutils_reload_rhel':
      command     => '/usr/bin/awk -F= \'/(\S+)\s*=(\S+)/{cmd=sprintf("/bin/echo %s > /sys/%s",$2, $1); system(cmd)}\' /etc/sysfs.conf',
      refreshonly => true,
      subscribe   => Concat['/etc/sysfs.conf'],
    }
  }

  service { 'sysfsutils':
    ensure    => running,
    enable    => true,
    subscribe => Concat['/etc/sysfs.conf'],
  }

  concat { '/etc/sysfs.conf':
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    force   => true,
    require => Package['sysfsutils'],
  }

  if $settings {
    create_resources('sysfs::setting', $settings)
  }

}
