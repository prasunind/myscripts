#!/usr/bin/perl 
#die "$0 username groupname " if ( $#ARGV != 1 );

use Net::LDAP;

$ldap = Net::LDAP->new("127.0.0.1");

$mesg = $ldap->bind("cn=Manager,dc=myldap,dc=lan", password=>"", version =>3);

$basedn="dc=terracotta,dc=lan";
#$sid="S-1-5-21-1810527774-2496153094-1573869345";


$userName=$ARGV[0];
$groupName=$ARGV[1];

 my $modify = $ldap->modify ( "cn=$groupName,ou=Groups,$basedn",
                                        changes => [
                                                    add => [memberUid => "$userName"]
                                                   ]                                                                
					 );   



if ($modify->code ) {
        print "Error!  Operation failed.\n";
      print "Return code: ", $modify->code ; 
      print "\n";
      print "Error name: ",$modify->error_name;
      print "\n";
      print "Error text: ",$modify->error_text ;
      print "\n";
      print "Mesg id: ",$modify->mesg_id ;
      print "\n";
      print "Modify DN: ", $modify->dn ;


}


$ldap->unbind;

