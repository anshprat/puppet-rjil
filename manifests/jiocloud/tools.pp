rjil::jiocloud::tools {
  $tools_pkgs = [ 'php5-snmp']
  package { $tools_pkgs: }
  include apache::mod::rewrite
}
