# @summary Set sysfs settings
#
# @example A basic example:
#   sysfs::setting { 'class/block/sdb/queue/read_ahead_kb':
#     value => 8
#   }
#
# @param value
#   The value to set the sysfs setting to.
#
define sysfs::setting (
  String $value
) {
  concat::fragment { $name:
    target  => '/etc/sysfs.conf',
    content => "${name}=${value}\n";
  }
}
