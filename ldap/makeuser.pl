#!/usr/bin/perl  -w

# $Id: makeuser.pl,v 1.16 2008/02/27 01:16:22 root Exp $

# This file now under RCS control!


use Net::LDAP;
use Crypt::SmbHash;


$ldap = Net::LDAP->new("127.0.0.1");

$mesg = $ldap->bind("cn=Manager,dc=myldap,dc=lan", password=>"");

if ($mesg->code ) {
      die "Error ldap_error_name($mesg->code)\n";
}
 
$basedn="dc=terracotta,dc=lan";
$sid="S-1-5-21-1810527774-2496153094-1573869345";

$userName="swallace";
$userCN="Sandy";
$userSN="Wallace";
$userUidNumber=99999;
$userGidNumber=99999;
$userHomeDirectory="/nonexistent";
$shell="/bin/false";
$gecos=$userCN;
$departmentNumber=20000;
$password="swtermed";
#$rid=500;
$rid=(2*$userUidNumber)+1000;
$crpass=crypt($password,"dl");
my ($lmpassword,$ntpassword) = ntlmgen $password;

my $add = $ldap->add ("uid=$userName,ou=People,$basedn",
                             attr => [
                                      'objectclass' => ['top','inetOrgPerson','posixAccount','shadowAccount','sambaSAMAccount'],
                                      'cn'   => "$userCN",
                                      'sn'   => "$userSN",
                                      'uid'   => "$userName",
                                      'uidNumber'   => "$userUidNumber",
                                      'gidNumber'   => "$userGidNumber",
                                      'homeDirectory'   => "$userHomeDirectory",
                                      'loginShell'   => "$shell",
                                      'gecos'   => "$gecos",
			              'mail'   => "$userName\@terracottatech.com",	
                                      'description'   => "$gecos",
                                      'userPassword'   => "{crypt}$crpass",
                                      'sambaPwdLastSet' => "2147483647",
                                      'sambaLogonTime' => '0',
                                      'sambaLogoffTime' => '2147483647',
                                      'sambaKickoffTime' => '2147483647',
                                      'sambaPwdCanChange' => "0",
                                      'sambaPwdMustChange' => "2147483647",
                                      'displayName' => "$gecos",
                                      'sambaAcctFlags' => "[UX]",
                                      'sambaSID' => "$sid" . "-$rid",
                                      'sambaLMPassword' => "$lmpassword",
                                      'sambaPrimaryGroupSID' => "$sid" . "-515",
                                      'sambaNTPassword' => "$ntpassword",
				      'departmentNumber' => "$departmentNumber"
                                       ]                                                                
					 );   

                                                                                                                    

$ldap->unbind;


