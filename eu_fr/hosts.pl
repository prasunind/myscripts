#!/usr/bin/perl

use Time::Local;
use CGI qw(:standard);
#use CGI::Carp qw(warningsToBrowser fatalsToBrowser);

print header;
print start_html ( -title=>'Check Hosts Hosts',
                   -author=>'Prasun', -bgcolor=>black, -text=>"#00FF00" );


$input  =  param( first );
#$input  =  $ARGV[0];
$channel = "$input" ;



@ser = ` /data/servers/eu_apps_aol_fr/pages/eu3/scripts/host_env.sh  $input `;

@server = split / /, "@ser";

print " <h4> Hosts for $input  are : </h4> \n";

foreach $host(@server) {
      print "$host \n <br>" ;
      }

end_html;

