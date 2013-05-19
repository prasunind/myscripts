#!/usr/bin/perl -w

use Socket;
use DBI;
use strict;
use Encode;

$ENV{'LC_ALL'} = 'C';
$ENV{'LC_CTYPE'} = 'C';

sub strictify_utf8 {
   my $data = shift;
#   if (Encode::is_utf8($data) && !Encode::is_utf8($data,1)) {
       Encode::_utf8_off($data);
       Encode::from_to($data, 'utf8', 'UTF-8');
       Encode::_utf8_on($data);
#   }
   return $data;
}

use Geo::IP::PurePerl;
my $GeoIPOrg_db = Geo::IP::PurePerl->new("/export2/GeoIP-data/GeoIPOrg.dat",GEOIP_STANDARD);
my $GeoLiteCity_db = Geo::IP::PurePerl->open("/export2/GeoIP-data/GeoLiteCity.dat", GEOIP_STANDARD);

my $phoneHomeDB = DBI->connect ("dbi:Pg:dbname=pp", "", "", { pg_enable_utf8 => 1 });
if ( !defined $phoneHomeDB ) { die "Cannot connect to phonehome database!\n"; }

while (my $logEntry = <STDIN>) {
	my $phoneHomeLine = "false";
	$phoneHomeLine = $logEntry if $logEntry =~ /.*GET \/kit\/reflector\?.*pageID=upda.ies.*/;
	if ($phoneHomeLine ne "false") {
		# initialize variables we will reuse
		my $part1 = "";
		my $part2 = "";
		my $data = "";
		my %phoneHomeData = (
			time => "1970-01-01 00:00:00",
			ip_address => "0.0.0.0",
			domain_name => "",
			kitID => "",
			pageID => "",
			id => "",
			os_name => "",
			jvm_name => "",
			jvm_version => "",
			platform => "",
			tc_version => "",
			tc_product => "",
			uptime_secs => 0,
			source => "",
			country_code => "",
			country_name => "",
			region => "",
			city => "",
			organization_name => "",
		);

		# Fix an error, where some entries do not have an "&" seperating id from os-name
		$part1 = $1 if $phoneHomeLine =~ /(.*)os\-name=.*/;
		$part2 = $1 if $phoneHomeLine =~ /.*(os\-name=.*)/;
		$phoneHomeLine = "$part1" . "&" . "$part2";

		# Regex out basic log info
		$phoneHomeData{'time'} = $1 if $phoneHomeLine =~ /.*\[(.*)\].*/;
		$phoneHomeData{'ip_address'} = $1 if $phoneHomeLine =~ /^(\S+)\s.*/;
		if ($phoneHomeData{'ip_address'} ne "0.0.0.0") {
			$phoneHomeData{'domain_name'} = gethostbyaddr(inet_aton($phoneHomeData{'ip_address'}), AF_INET);
		}
		if (!defined $phoneHomeData{'domain_name'}) { $phoneHomeData{'domain_name'} = $phoneHomeData{'ip_address'} };

		# Grab all of the other values and stick it into the hash
		$data = $1 if $phoneHomeLine =~ /.*GET \/kit\/reflector\?(kitID=.*)\sHTTP.*/;
		my @key = split /&/, $data;
		foreach my $keyPair (@key) {
			(my $name, my $value) = split /=/, $keyPair;	
			# Change "-" to "_" on some of these names
			if (defined $name) {
				$name =~ s/\-/_/g;
				$phoneHomeData{$name} = $value;
			}
		}


# Populate the GeoIP information about the organization who own this IP address
# ----------
		my $ip_addr = $phoneHomeData{'ip_address'};
                my $organization_name = $GeoIPOrg_db->org_by_name($ip_addr);
                my ($country_code,$country_code3,$country_name,$region,$city,$postal_code,$latitude,$longitude,$metro_code,$area_code) = $GeoLiteCity_db->get_city_record($ip_addr);
                $phoneHomeData{ 'country_code' } = strictify_utf8( $country_code );
                $phoneHomeData{ 'country_name' } = strictify_utf8( $country_name );
                $phoneHomeData{ 'region' } = strictify_utf8( $region );
                $phoneHomeData{ 'city' } = strictify_utf8( $city );
                $phoneHomeData{ 'organization_name' } = strictify_utf8( $organization_name );


# ----------
		my $update = $phoneHomeDB->prepare("
		UPDATE updatecheck SET time=?, ip_address=?, domain_name=?, kitID=?, pageID=?, id=?, os_name=?, jvm_name=?, jvm_version=?, platform=?, tc_version=?, tc_product=?, uptime_secs=?, source=?, country_code=?, country_name=?, region=?, city=?, organization_name=? WHERE time=? AND id=?");
		if (!defined $update) {
			die "Cannot prepare SQL statement: $DBI::errstr\n";
		}
		my $ret = $update->execute($phoneHomeData{'time'}, $phoneHomeData{'ip_address'}, $phoneHomeData{'domain_name'}, $phoneHomeData{'kitID'}, $phoneHomeData{'pageID'}, $phoneHomeData{'id'}, $phoneHomeData{'os_name'}, $phoneHomeData{'jvm_name'}, $phoneHomeData{'jvm_version'}, $phoneHomeData{'platform'}, $phoneHomeData{'tc_version'}, $phoneHomeData{'tc_product'}, $phoneHomeData{'uptime_secs'}, $phoneHomeData{'source'}, $phoneHomeData{ 'country_code'}, $phoneHomeData{'country_name'}, $phoneHomeData{'region'}, $phoneHomeData{'city'}, $phoneHomeData{'organization_name'}, $phoneHomeData{'time'}, $phoneHomeData{'id'});

		if( ! defined $ret ) { $ret = 0; }
		$update->finish;
		if( defined $ret && $ret == 0 ) {
			my $insert = $phoneHomeDB->prepare("
			INSERT INTO updatecheck (time, ip_address, domain_name, kitID, pageID, id, os_name, jvm_name, jvm_version, platform, tc_version, tc_product, uptime_secs, source, country_code, country_name, region, city, organization_name) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)" );
			if (!defined $insert) {
				die "Cannot prepare SQL statement: $DBI::errstr\n";
			}
			my $ret = $insert->execute($phoneHomeData{'time'}, $phoneHomeData{'ip_address'}, $phoneHomeData{'domain_name'}, $phoneHomeData{'kitID'}, $phoneHomeData{'pageID'}, $phoneHomeData{'id'}, $phoneHomeData{'os_name'}, $phoneHomeData{'jvm_name'}, $phoneHomeData{'jvm_version'}, $phoneHomeData{'platform'}, $phoneHomeData{'tc_version'}, $phoneHomeData{'tc_product'}, $phoneHomeData{'uptime_secs'}, $phoneHomeData{'source'}, $phoneHomeData{ 'country_code'}, $phoneHomeData{'country_name'}, $phoneHomeData{'region'}, $phoneHomeData{'city'}, $phoneHomeData{'organization_name'} );
	
			if( ! defined $ret ) { $ret = 0; }
			$insert->finish;
		}
	}

} # while( <STDIN> )

$phoneHomeDB->disconnect;
