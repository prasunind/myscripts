#!/usr/bin/perl 

use Net::LDAP;
use Crypt::SmbHash;

$ldap = Net::LDAP->new("127.0.0.1");

$mesg = $ldap->bind("cn=Manager,dc=myldap,dc=lan", password=>"", version =>3);


$basedn="dc=terracotta,dc=lan";

$userName=$ARGV[0];

$loop = "true";
while ($loop eq "true") {
	print "New password: ";
	system("stty -echo");
	$password1 = <STDIN>;
	chop($password1);
	print "\n";
	print "Confirm password: ";
	$password2 = <STDIN>;
	chop($password2);
	print "\n";
	system("stty echo");

	if ($password1 ne $password2) {
		print "Passwords do not match!\n";
		print "--Hit Enter--";
		$pause = <STDIN>;
	} else {
		$loop = "false";
	}
}

$password=$password1;

my $crpass=crypt($password,"lk");
my ($lmpassword,$ntpassword) = ntlmgen $password;
my $currenttime = time();


 my $modify = $ldap->modify ( "uid=$userName,ou=People,$basedn",
                                        changes => [
        replace=>[userPassword => "{crypt}$crpass"],
        replace=>[sambaLMPassword => "$lmpassword"],
        replace=>[sambaNTPassword => "$ntpassword"],
        replace=>[sambaPwdLastSet => "$currenttime"]]);

    


if ($modify->code ) {
      print  "$modify{code}, $modify{error_name}, $modify{error_text}, $modify{mesg_id}, $modify{dn} \n";
}


print "Set password for $userName\n";


$ldap->unbind;

