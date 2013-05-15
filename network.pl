#!/usr/bin/perl

use Getopt::Std;
use Array::Utils qw(:all);

$COUNT="1";
$TOTALC="";
$NETWORK="10.129.";
@FE="4";
@FECNT=(1..15);
@DATA="16";
@DATACNT=(17..31);
@MGMT="32";
@MGMTCNT=(33..47);
@IPS=(1..254);
undef $CNT;

%options=();
getopts("hn:Cc:", \%options);

print "Usage : ./freeip.pl -n <network subnet name> -C <if it's a controller> -c <No of free ip's you need> \n" if defined $options{h};

$OPT="$options{n}" if  defined $options{n};
$COUNT="$options{c}" if  defined $options{c};


if (defined $options{C}){
        if ( "$options{n}" eq "fe" )   { @NETPARAM="@FECNT"}
        if ( "$options{n}" eq "data" ) { @NETPARAM="@DATACNT" }
        if ( "$options{n}" eq "mgmt" ) { @NETPARAM="@MGMTCNT" }
        }

if (!defined $options{c}){
        if ( "$options{n}" eq "fe" )   { @NETPARAM="@FE"}
        if ( "$options{n}" eq "data" ) { @NETPARAM="@DATA" }
        if ( "$options{n}" eq "mgmt" ) { @NETPARAM="@MGMT" }
        }

$NETID=shift(@NETPARAM);



@ret=get_used_ip ( "$NETID");
@free=search_free_ip ( \@IPS,  \@ret, $NETID);


$TOTALC=$TOTALC + ($#free +1);

if ( $TOTALC >= $COUNT ) {
	
	foreach (@free) {
		print "$_ \n";
	}
}else {
	foreach (@free) {
                    print "$_ \n \n Scaning next subnet....\n";
		    $NETID=shift(@NETPARAM);		
		    @ret=get_used_ip ( "$NETID");
		    @free=search_free_ip ( \@IPS,  \@ret, $NETID);	
             }

}	
	








sub search_free_ip {
	my  $range=@_[0];
	my  $used=@_[1];
	my  $net=@_[2];
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

        open (FH,"<","/root/myscript/cobbler_output") or die "$!: Cobbler File error";

        while ($ipadd = <FH>) {
                chomp $ip;
                if ($ipadd =~ /\b(10\.0\.$Netid\.)(.*)\b/) {
                push(@ip,$2);
                }
        }
        @ip=uniq(@ip);
        @ip=sort {$a <=> $b} @ip;
        return @ip;
}

