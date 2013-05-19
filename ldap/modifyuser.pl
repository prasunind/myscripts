#!/usr/bin/perl -w

use Net::LDAP;
use Crypt::SmbHash;


$ldap = Net::LDAP->new("127.0.0.1");

$mesg = $ldap->bind("cn=Manager,dc=myldap,dc=lan", password=>"", version =>3);

$basedn="dc=terracotta,dc=lan";
$sid="S-1-5-21-1810527774-2496153094-1573869345";


$userName=$ARGV[0];
$userCN="nobody";
$userSN="nobody";
$userUidNumber=1000;
$userGidNumber=32767;
$userHomeDirectory="/nonexistent";
$shell="/sbin/nologin";
$gecos="Unprivileged User";
$password="terradome";
$rid=(2*$userUidNumber)+1000;
$crpass=crypt($password,"df");

$curtime = time();

# my ($lmpassword,$ntpassword) = ntlmgen $password;


 my $modify = $ldap->modify ( "uid=$userName,ou=People,$basedn",
                                        changes => [
#                                                     add => [departmentNumber => "0"]
                                            #          replace => [departmentNumber => "0"]
#                                                     replace => [userPassword => "\{crypt\}$crpass"]
#                                                     replace => [loginShell => '/bin/bash']
#                                                     replace => [sambaAcctFlags => '[UX         ]']
#							replace => [sambaPwdMustChange => "2147483647"]
							replace => [description => ""]
                                                   ]                                                                
					 );   


if ($modify->code ) {
      print  "code: ", $modify->code;
      print  "\nerror_name: ", $modify->error_name;
      print  "\nerror_text: ", $modify->error_text;
      print  "\nmesg_id: ", $modify->mesg_id;
      print  "\ndn: ", $modify->dn;
      print "\n";
}


# machines
#my $date=time;
#my $modify = $ldap_master->modify ( "uid=$userName,ou=Computers,$basedn",
#                                       changes => [
#                              replace => [objectClass => ['inetOrgPerson', 'posixAccount', 'sambaSAMAccount']],
#                                                    add => [sambaLogonTime => '0'],
#                                                    add => [sambaLogoffTime => '2147483647'],
#                                                    add => [sambaKickoffTime => '2147483647'],
 #                                                   add => [sambaPwdCanChange => '0'],
  #                                                  add => [sambaPwdMustChange => '2147483647'],
   #                                                 add => [sambaPwdLastSet => "$date"],
    #                                                add => [sambaAcctFlags => '[I          ]'],
     #                                               add => [sambaLMPassword => "$lmpassword"],
      #                                              add => [sambaNTPassword => "$ntpassword"],
       #                                             add => [sambaSID => "$user_sid"],
        #                                            add => [sambaPrimaryGroupSID => "$config{SID}-515"]
         #                                          ]
          #                            );
                                                                                                                    





$ldap->unbind;

