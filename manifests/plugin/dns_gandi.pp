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
  String[1] $package_name,
  String[1] $api_key,
  Stdlib::Absolutepath $config_dir      = $letsencrypt::config_dir,
  Boolean $manage_package               = false,
  Boolean $python_packages              = true,
  String[1] $plugin_pip3_version        = '1.3.2'
) {
  require letsencrypt

# old Legacy prefix-based
  if $manage_package {
    package { $package_name:
      ensure => installed,
    }
  }

# New post-prefix configuration for certbot>=1.7.0
  if $python_packages {

    $python_packages_name = [
      'git',
      'python3-pip',
      'python3-dev'
    ]

    package { 
      $python_packages_name:
        ensure => installed;
      'certbot-plugin-gandi':
        ensure   => $plugin_pip3_version,
        provider => 'pip3',
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
