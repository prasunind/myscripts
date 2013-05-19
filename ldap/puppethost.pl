#!/usr/bin/perl  -w


use Socket;
use Net::LDAP;

$ldap = Net::LDAP->new("127.0.0.1");

$mesg = $ldap->bind("cn=Manager,dc=myldap,dc=lan", password=>"");

if ($mesg->code ) {
      die "Error ldap_error_name($mesg->code)\n";
}
 

$basedn="dc=terracotta,dc=lan";

$machine=$ARGV[0] . ".terracotta.lan";
$environment="development";
$type=$ARGV[1];   # monkey
$ipHostNumber= gethostbyname($machine);
$address=inet_ntoa($ipHostNumber);
#$address="10.0.4.43";

print "DEBUG:\t machine=[$machine] ip=[$address]\n";
# machines
my $modify = $ldap->add ( "cn=$machine,ou=Computers,$basedn",
                                       attr => [
          		                        objectClass => ['device', 'ipHost', 'puppetClient'],
						'cn'   => $machine,
                                                'environment' => $environment,
						'puppetClass' => $type,
						'ipHostNumber' => $address
                                                   ]
                                      );
                                                                               

# error check

if ($modify->code ) {
      print  "$modify{code}, $modify{error_name}, $modify{error_text}, $modify{mesg_id}, $modify{dn}
 \n";
}

$ldap->unbind;

