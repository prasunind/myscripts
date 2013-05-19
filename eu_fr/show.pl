#!/opt/bcs/bin/perl
use CGI qw(:standard);

print header;
print start_html ( -title=>'RSP  Viewer',
                  -author=>'Prasun', -bgcolor=>"black", -text=>"white" );


$server   =  param( ser );
$opt   =  param( word );
$domain = param( channel );

#$server = shift;
#$opt = shift;
#$domain = shift;

if($opt eq "cnf") {
  $status=(`/data/servers/eu_apps_aol_fr/pages/eu3/scripts/ttest/tel.pl $server $opt $domain  > /data/servers/eu_apps_aol_fr/pages/dumps/$domain.txt`); die "Could not get the info: $?" unless $status == 0 ;
  print "<head>"; 
  print "<meta http-equiv=\"REFRESH\" content=\"0;url=http://centraol.ops.aol.com:5900/dumps/$domain.txt\">";
  print "</head>"; 
}
else  {
   $status=(`/data/servers/eu_apps_aol_fr/pages/eu3/scripts/ttest/tel.pl $server $opt >/data/servers/eu_apps_aol_fr/pages/dumps/$server.txt`);die "Could not get the info: $?" unless $status == 0 ;
  print "<head>";
  print "<meta http-equiv=\"REFRESH\" content=\"0;url=http://centraol.ops.aol.com:5900/dumps/$server.txt\">";
  print "</head>";

}

end_html;

   




