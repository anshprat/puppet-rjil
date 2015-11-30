# Class for adding postfix
# == parameters ==
# [*satellite*]
# A Boolean to define whether to configure postfix as a satellite relay host. This setting is mutually exclusive with the mta
# Boolean.
# Default: False (puppet-postfix)
# Default: True (puppet-rjil)
# [*myhostname*]
# [*mydestination*]
# [*mydomain*]
# [*relayhost*]
# [*mail_name*]
# [*data_directory*]

class rjil::commonservices::postfix (
  $satellite      = true,
  $myhostname     = 'jiocloudsmtp',
  $mydestination  = '',
  $mydomain       = 'ril.com',
  $relayhost      = '10.137.2.23',
  $mail_name      = '',
  $data_directory = ''
) {
  class { 'postfix':
    ensure    => 'present',
    satellite => true,
  }

  postfix::config {
    'smtpd_banner':                     value => "$myhostname ESMTP $mail_name (Ubuntu)";
    'biff':                             value => "no";
    'append_dot_mydomain':              value => "no";
    'readme_directory':                 value => "no";
    'smtpd_tls_cert_file':              value => "/etc/ssl/certs/ssl-cert-snakeoil.pem";
    'smtpd_tls_key_file':               value => "/etc/ssl/private/ssl-cert-snakeoil.key";
    'smtpd_use_tls':                    value => "yes";
    'smtpd_tls_session_cache_database': value => "btree:${data_directory}/smtpd_scache";
    'smtp_tls_session_cache_database':  value => "btree:${data_directory}/smtp_scache";
    'smtpd_relay_restrictions':         value => "permit_mynetworks permit_sasl_authenticated defer_unauth_destination";
    'myhostname':                       value => "$myhostname";
    'alias_maps':                       value => "hash:/etc/aliases";
    'alias_database':                   value => "hash:/etc/aliases";
    'mydomain':                         value => "$mydomain";
    'myorigin':                         value => "/etc/mailname";
    'mydestination':                    value => "$mydestination";
    'relayhost':                        value => "$relayhost";
    'mynetworks':                       value => "127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128";
    'mailbox_size_limit':               value => "0";
    'recipient_delimiter':              value => ",";
    'inet_interfaces':                  value => "loopback-only";
    'inet_protocols':                   value => "all";
  }
}
