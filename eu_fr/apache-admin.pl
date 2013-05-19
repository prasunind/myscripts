#!/opt/bcs/bin/perl -w

use Net::SSH::Perl;
use CGI qw(:standard);

print header;
print start_html ( -title=>'Check SSL Certificate',
                   -author=>'Prasun', -bgcolor=>"black", -text=>"#00FF00" );

$channel  =  param( channel );
$server   =  param( ser  );
$do   =  param( act );
$cmdtorun      =  "/data/servers/$channel/bin/apache.sh  $channel  $do"; 

my $apacheadmin = Net::SSH::Perl->new("$server", identity_files => ["/home/jv-fr01/.ssh/id_dsa"], option =>[ "BatchMode yes"], protocol=>'2,1'); 
$apacheadmin->login('jv-fr01');
#$apacheadmin->login('jv-fr01');
my ($stdout, $stderr, $exit) = $apacheadmin->cmd("$cmdtorun");
chomp ($stdout);
my @out = split(/^/,$stdout);
foreach $line(@out) {
 print "<br> $line </br>";
 }
#print "$stdout";
print "$stderr";



print "$stderr";
#print "$exit";





end_html;
