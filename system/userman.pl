#!/usr/bin/perl -w

# script to allow users to change their ldap password

use CGI ':standard';
#use CGI::Carp 'fatalsToBrowser';
use Net::LDAP;

print header;
print start_html ( -title=>'Userman',-author=>'Prasun', -bgcolor=>"white", -text=>"black" );

my $Userid  =  param("Userid");
my $tcgroup   =  param("tcin");
my $svnadd   =  param("svnin");
my $manager  =  param("formUser");
#$cmdtorun      =  "$do";



#print "<br> $Userid \n $tcgroup \n $svnadd \n $manager </br>";



# Make sure username does not already exist
if (open(PASSWD, "/etc/passwd")) {
        while ($line = <PASSWD>) {
                $usernameTmp = $1 if $line =~ /^([^:]*):.*/;
                if ($Userid eq $usernameTmp) {
                        $run = adduser($Userid);
                }else {
                        print "<H4>The UserID s not in internal employee list, contact Helpdesk</H4>";
                }
        }
        close(PASSWD);
} else {
        $error = "Cannot open /etc/passwd on sand.";
}

print end_html;

sub verifyuser {

                my $userid = shift;
                my $ldap = Net::LDAP->new('10.0.4.88') or die "$@";
                $mesg = $ldap->bind("cn=Manager,dc=terracotta,dc=org", password=>"marpre59", version =>3);
                die("Unable to bind. Your current password was probably incorrect",
                $mesg->code, $mesg->error) if $mesg->code;

                $search = $ldap->search(        base=>"ou=People,dc=terracotta,dc=org",
                                        filter=>"(uid=$userid)"
                                        );
                my $result = $search->as_struct;
                my @returnvalue = values %$result;
                print "@result";

                        if ($search->code ) {
                                print "Error!  Operation failed.\n";
                                 print "Return code: ", $search->code ;
                                print "\n";
                                print "Error name: ",$search->error_name;
                                print "\n";
                                print "Error text: ",$search->error_text ;
                                print "\n";
                                print "Mesg id: ",$search->mesg_id ;
                                print "\n";
                                print "Modify DN: ", $search->dn ;
                                }

                $ldap->unbind;
                }

sub adduser {

                my $userid = shift;
                my $ldap = Net::LDAP->new('10.0.4.88') or die "$@";
                $mesg = $ldap->bind("cn=Manager,dc=terracotta,dc=org", password=>"marpre59", version =>3);
                die("Unable to bind. Your current password was probably incorrect",
                $mesg->code, $mesg->error) if $mesg->code;

                $basedn="dc=terracotta,dc=org";



                        my $modify = $ldap->modify ( "cn=tcinternal,ou=Groups,$basedn",
                                                changes => [
                                                         add => [memberUid => "$userid"]
                                                        ]
                                                        );


                                if ($modify->code ) {
                                        print "Error name: ",$modify->error_name;
                                        print "\n";
                                #       print "Error text: ",$modify->error_text ;
                                        print "\n";
                                  } else {
                                        print "User  has been added to tcinternal"
                                        }

                                $ldap->unbind;


        }










