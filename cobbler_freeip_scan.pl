#!/usr/bin/perl
$mesg="\n\t -h --help \n\t -n --Network fe, data or mgmt\n\t -C --If it's a controller \n\t -c --Number or free ip you need,upto 508 \n \n Usage : ./freeip.pl -n <network subnet name> -C <if it's a controller> -c <No of free ip's you need,upto 508 > \n";

use Getopt::Std;
use Array::Utils qw(:all);




$NETWORK="10.129.";
@FE=(0);
@FECNT=(1..15);
@DATA=(16);
@DATACNT=(17..31);
@MGMT=(32);
@MGMTCNT=(33..47);
@IPS=(1..254);
undef $COUNT;

%options=();
getopts("hn:Cc:", \%options);


$OPT="$options{n}" if  defined $options{n};
$COUNT="$options{c}" if  defined $options{c};
print "$mesg" if defined $options{h};


if (defined $options{C}){
        if ( "$options{n}" eq "fe" )   { @NETPARAM=@FECNT}
        if ( "$options{n}" eq "data" ) { @NETPARAM=@DATACNT }
        if ( "$options{n}" eq "mgmt" ) { @NETPARAM=@MGMTCNT }
        }

if (!defined $options{C}){
        if ( "$options{n}" eq "fe" )   { @NETPARAM=@FE}
        if ( "$options{n}" eq "data" ) { @NETPARAM=@DATA }
        if ( "$options{n}" eq "mgmt" ) { @NETPARAM=@MGMT }
        }



if (defined $options{n}) {$Totalfreeip=master()} else { print "Please check help for correct options \n" if !defined $options{h}};

if ( $Totalfreeip < $COUNT ) {  $m=master(); print "------ $m ---- \n"; }; 




sub master {
	$ipv4="0";	
	$NETID=shift(@NETPARAM);
	@ret=get_used_ip ( "$NETID");
	@free=search_free_ip ( \@IPS,  \@ret, $NETID);
		foreach (@free) {
                	print "$_ \n";
			$ipv4++
        	}
		print "You have $ipv4 unassigned ip in cobbler for network  10.129.$NETID.0/20\n\n";
		return $ipv4++;

}



sub search_free_ip {
	my  $range=@_[0];
	my  $used=@_[1];
	my  $net=@_[2];
	@freeipno=();
	@freeip=();
	@freeipno=array_minus(@$range,@$used);	

		foreach $no (@freeipno) {
			$ip=join('','10.129.',$net,'.',$no);
			push(@freeip,$ip);
	}
			return @freeip;
}

sub uniq { my %seen; grep !$seen{$_}++, @_  };

sub get_used_ip {

        my $Netid="@_[0]";
	@ip=();

	system("/usr/bin/cobbler report > /tmp/cobbler");
        open (FH,"<","/tmp/cobbler") or die "$!: Cobbler File error";

        while ($ipadd = <FH>) {
                chomp $ip;
                if ($ipadd =~ /\b(10\.129\.$Netid\.)(.*)\b/) {
                push(@ip,$2);
                }
        }
        @ip=uniq(@ip);
        @ip=sort {$a <=> $b} @ip;
        return @ip;
	close FH;
}

