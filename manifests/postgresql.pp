## PostgreSQL

### Deploys and configures a customer PostgreSQL server.

### Variable documentation
#### postgresql_username: The username of the PostgreSQL user that Automation Server provisions databases and users through.
#### postgresql_password: The password for the PostgreSQL user that Automation Server provisions databases and users through.
#### server_ip: Server management IP address (eg. 192.168.33.178)
#### server_public_ip: Server public IP address (eg. 212.200.237.157)

### Validations
##### postgresql_username(advanced): ^[a-z0-9_-]+$
##### postgresql_password(advanced): %password
##### server_ip: .*
##### server_public_ip: .*

class atomia::postgresql (
  $postgresql_username  = 'automationserver',
  $postgresql_password  = '',
  $server_ip            = '',
  $server_public_ip     = '',
){

  class { 'postgresql::server':
    ip_mask_deny_postgres_user => '0.0.0.0/32',
    ip_mask_allow_all_users    => '0.0.0.0/0',
    listen_addresses           => '*',
    ipv4acls                   => ['host all all 0.0.0.0/0 md5']
  }

  postgresql::server::role { 'atomia_postgresql_provisioning_user':
    username      => $postgresql_username,
    password_hash => postgresql_password($postgresql_username, $postgresql_password),
    createdb      => true,
    createrole    => true,
    superuser     => true
  }
}
