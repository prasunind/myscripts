#!/usr/bin/perl  -w

use Net::LDAP;
use Crypt::SmbHash;


$userName=$ARGV[0];

$ldap = Net::LDAP->new("127.0.0.1");

$mesg = $ldap->bind("cn=Manager,dc=myldap,dc=lan", password=>"");

if ($mesg->code ) {
      die "Error ldap_error_name($mesg->code)\n";
}
 
$basedn="dc=terracotta,dc=lan";


my $add = $ldap->delete ("uid=$userName,ou=People,$basedn");

$ldap->unbind;

