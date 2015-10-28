# packages etc required for tools/commonservices
class rjil::commonservices::tools {
  $tools_pkgs = ['php5-snmp']

  package { $tools_pkgs: }

  class { 'apache::mod::rewrite': }
}
