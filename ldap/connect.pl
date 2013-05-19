#!/usr/bin/perl  -w

use Net::LDAP;
use Net::LDAP::Util;

$ldap = Net::LDAP->new("127.0.0.1");

$mesg = $ldap->bind("cn=Manager,dc=myldap,dc=lan", password=>"");
#mesg = $ldap->bind("cn=Manager,dc=terracotta,dc=lan", password=>"dookie");

if ($mesg->code ) {
      die "Error ldap_error_name($mesg->code)\n";
}
                                                                                   
$mesg = $ldap->search(filter=>"(objectClass=*)", base=>"dc=terracotta,dc=lan");
@entries = $mesg->entries;
foreach $entry (@entries) {
        $entry->dump;
}


$ldap->unbind;

