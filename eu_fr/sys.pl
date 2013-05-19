#!/opt/bcs/bin/perl -w

use Net::SSH::Perl;
use Math::BigInt;
use CGI qw(:standard);

print header;
print start_html ( -title=>'Check SSL Certificate',
                   -author=>'Prasun', -bgcolor=>"black", -text=>"#00FF00" );

#$channel  =  param( channel );
$server   =  param( ser  );
$do   =  param( act );
#$argu  =  param( par );
$cmdtorun      =  "$do"; 

 &go_hunting_location($server, $cmdtorun);

sub go_hunting_location {
        my $server = $_[0];
	my $command = $_[1];
        #$myenv =~ s/\./_/g;
        my $location = `ssh -q jv-fr01\@$server \"$command\" `;
        chomp ($location);
        my @slocation = split(/^/,$location);
  	foreach $host(@slocation) {
         print "<br> $host </br>" ;
      }

}




end_html;
