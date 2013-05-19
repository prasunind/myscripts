#!/usr/bin/perl  -w



$basedn="dc=myldap,dc=lan";


open UFILE, "<uidnummap" or die "stupid username file $!";

while (<UFILE>) {
   chomp;
   ($name,$gid) = split / /, $_;


$userName="$name";
$gidNumber=$gid;

print "dn: cn=$userName,ou=Groups,$basedn\n";
print "objectClass: posixGroup\n";
print "cn: $name\n";
print "gidNumber: $gid\n";
print "\n";                                                                                                                   

}


