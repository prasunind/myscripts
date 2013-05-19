#!/opt/bcs/bin/perl -w


use CGI qw(:standard);

print header;
print start_html ( -title=>'Log Viewer'
                   -author=>'Prasun', -bgcolor=>"black", -text=>"white" );
$chan  =  param( channel );
$server   =  param( ser );
$ln    =  param( line );
$grp   =  param( word );

if ( $grp eq  "full" )  {
	$A = " ";
}
elsif ( $grp eq "er" ) {
	$A = "| grep 'ERR' ";
}
elsif ( $grp eq "sev" ) {
        $A = "| grep 'SEV' ";
}
elsif ( $grp eq "fa" ) {
        $A = "| grep 'FATAL' ";
}
else {
	$A = "Invalid Option";
	print "$A";
} 
  
$cmdtorun = "tail\ -$ln\ /data/servers/$chan/logs/channel-frontend.log\ $A";

&go_hunting_location($server, $cmdtorun);

sub go_hunting_location {
        my $server = $_[0];
        my $command = $_[1];
        my $location = `ssh -q jv-fr01\@$server \ $command ` ; 
        chomp ($location);
        my @slocation = split(/^/,$location);
        foreach $line(@slocation) {
         print "<br>$line " ;
	}
}
#print "<meta http-equiv=\"refresh\" content=\"5\" >";
end_html;
