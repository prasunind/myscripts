#!/opt/bcs/bin/perl
use CGI qw(:standard);

$DIR="/data/servers/eu_apps_aol_fr/pages/ssl"
$fqdn = param(sitename);
$KEYSIZE=1024;

system= openssl genrsa -out $DIR/$URL.key  $KEYSIZE

print header;
print start_html ( -title=>'RSP  Viewer',
                  -author=>'Prasun', -bgcolor=>"black", -text=>"white" );


$fqdn = param(sitename);
#$fqdn = shift;


  $status=(`/data/servers/eu_apps_aol_fr/pages/eu3/scripts/makecert.sh $fqdn > /dev/null`) ; die "Could not generate the SSL : $?" unless $status == 0 ;
  print "<head>";
#  print "<meta http-equiv=\"REFRESH\" content=\"0;url=http://centraol.ops.aol.com:5900/ssl/$fqdn.key\">";
  print "<meta http-equiv=\"REFRESH\" content=\"0;url=http://centraol.ops.aol.com:5900/ssl/$fqdn.csr\">";
  print "</head>";


end_html;

