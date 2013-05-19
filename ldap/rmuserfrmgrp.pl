#!/usr/bin/perl 

use Net::LDAP;

$ldap = Net::LDAP->new("127.0.0.1");

$mesg = $ldap->bind("cn=Manager,dc=myldap,dc=lan", password=>"", version =>3);

$basedn="dc=terracotta,dc=lan";
$sid="S-1-5-21-1810527774-2496153094-1573869345";


$userName=$ARGV[1];
$groupName=$ARGV[0];

 my $modify = $ldap->modify ( "cn=$groupName,ou=Groups,$basedn",
                                        changes => [
                                                    delete => [memberUid => "$userName"]
                                                   ]                                                                
					 );   


if ($modify->code ) {
        print "Error!  Operation failed.\n";
      print  "$modify{code}, $modify{error_name}, $modify{error_text}, $modify{mesg_id}, $modify{dn} \n";
}


$ldap->unbind;

