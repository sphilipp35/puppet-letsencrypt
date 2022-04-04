# @summary Installs and configures the dns-gandi plugin
#
# This class installs and configures the Let's Encrypt dns-gandi plugin.
# https://github.com/obynio/certbot-plugin-gandi
#
# @param api_key Gandi api key.
# @param manage_package Manage the plugin package.
# @param package_name The name of the package to install when $manage_package is true.
# @param config_dir The path to the configuration directory.
#
class letsencrypt::plugin::dns_gandi (
  String[1] $api_key,
  Stdlib::Absolutepath $config_dir = $letsencrypt::config_dir,
  Boolean $manage_package          = true,
) {
  require letsencrypt

  if $manage_package {
    package { $package_name:
      ensure => installed,
    }
  }

  $ini_vars = {
    dns_gandi_api_key    => $api_key,
  }

  file { "${config_dir}/gandi.ini":
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0400',
    content => epp('letsencrypt/ini.epp', {
        vars => { '' => $ini_vars },
    }),
  }
}
