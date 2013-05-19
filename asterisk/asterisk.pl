#!/usr/bin/perl  -w


use CGI qw(:standard);
use CGI::Carp qw(warningsToBrowser fatalsToBrowser);

print header;
print start_html ( -title=>'Oncall Admin',
                   -author=>'Prasun', -bgcolor=>"white", -text=>"black" );



($engnameus, $engphoneus) = split( /-/, param( oncallus ));
($engnameind, $engphoneind) = split(/-/, param( oncallind));
($fenameus, $fephoneus) = split(/-/, param( feoncallus));
($fenameind, $fephoneind) = split(/-/, param( feoncallind));
$cmd = "sudo /usr/bin/extensionreload";


if ( "$fenameus" eq "" ) {
	print "<br> Eng Oncall is $engnameus and contact number is $engphoneus </br>";
	print "<br> India Eng Oncall is $engnameind and contact number is $engphoneind </br>";

	$update = `echo ";Engoncall \n ;$engnameus \nENGONCALL=DAHDI/g1/$engphoneus \n ;$engnameind \nINDIAENGONCALL=DAHDI/g1/$engphoneind \n"  >/etc/asterisk/engoncall`;

		if ( "$?" == 0 ){
        		print "<br><h4> **** File Updated successfully ***** </h4></br>";
			$department=Eng;
			$person1=$engnameus;
			$person2=$engnameind;		
			$manager=prasun;
        			}
		else {
        		print "<br> <h4> <font color=\"red\"> ***** File could not be updated, contact sysadmin **** </font></h4></br>";
			exit;
             	     }

		      }	


 else {
	print "<br> FE  Oncall is $fenameus and contact number is $fephoneus </br>";
        print "<br> India FE  Oncall is $fenameind and contact number is $fephoneind </br>";

	$update = `echo ";Feoncall \n ;$fenameus \nFIELDENGONCALL=DAHDI/g1/$fephoneus \n ;$fenameind \nINDIAFIELDENGONCALL=DAHDI/g1/$fephoneind \n"  >/etc/asterisk/feoncall`;	
	


		if ( "$?" == 0 ){
                        print "<br><h4> **** File Updated successfully ***** </h4></br>";
			$department=FE;
                        $person1=$fenameus;
                        $person2=$fenameind;
			$manager=njain;

                                }
                else {
                        print "<br> <h4> <font color=\"red\"> ***** File could not be updated, contact sysadmin **** </font></h4></br>";
                        exit;
                     }

	}



$output =  system "$cmd" ;

if ( "$ouput" == 0 ) {
	$inform = `echo "$department Oncall rotation was done for this week \n$department Oncall US is : $person1 \n$department Oncall IND is : $person2 \n "| mail -s \"$department Oncall Rotation \" sysad\@.com, $manager\@.com`;
	print "<br> *If you see \"Dialplan reloaded\" then asterisk reloaded new oncall updates successfully, else inform sysadmin </br>";
	} else {
	$inform = `echo "$department Oncall rotation cannot be done, file was updated but couldn't reload asterisk"| mail -s \"$department Oncall Rotation \" sysad\@terracottatech.com,$manager\@.com`;
		}

#print "$stderr";

end_html;
