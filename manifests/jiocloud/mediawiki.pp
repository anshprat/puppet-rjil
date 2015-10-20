class rjil::jiocloud::mediawiki {
  include ::mediawiki

  class { 'mediawiki':
    server_name      => 'wiki.corp.jiocloud.com',
    admin_email      => 'jiocloud.toolsteam@ril.com',
    db_root_password => '78bbb96bfe3efd6afe6112b2468a68cf',
    doc_root         => '/mnt/data/var/www/wikis',
    max_memory       => '1024'
  }

  mediawiki::instance { 'jiocloud':
    db_password => '2f1c8f08c99caaf1e7806e8dd50ed4e2',
    db_name     => 'jiocloud_wiki_db',
    db_user     => 'jiocloud_wiki_db',
    port        => '80',
    ensure      => 'present'
  }
}
