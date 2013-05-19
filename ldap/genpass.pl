#!/usr/bin/perl 

use Net::LDAP;
use Crypt::SmbHash;



sub makepass {
# SopPasswd: A generator for Sort-of-pronounceable passwords.
# Version: 0.1
# Author: Mark A. Pors, mark@dreamzpace.com, www.dreamzpace.com
# License: GPL

my $dict = '/usr/share/dict/words';       # path to dict file
my $wordlen = 8;                    # desired length of the password
my $numwords =1;                 # number of passwords to print
my $sublen = 3;                     # length of the word chunks that create the password
my $sep = "\n";                     # how to separate the words

my @dict;

$wordlen >= $sublen || die "Error: The word length should be equal or larger than the length of the 'chunks'\n";

open (DICT, "<$dict") || die ("Cannot open dict: $!");
while (<DICT>) {
    chomp;
    push (@dict, $_);
}

for (my $j=0;$j<$numwords;$j++) {

    my @sub = ();
    my $word = '';
    my $parts = int ($wordlen/$sublen);

    for (my $i=0;$i < $parts; $i++) {
        do {
            $sub[$i] = substr ($dict[int (rand @dict)], 0, $sublen);
        }
        until (length $sub[$i] == $sublen);
        $word .= lc $sub[$i];
    }

    my $left = $wordlen % $sublen;
    $word .= substr (int rand (10**($wordlen - 1)), 0, $left);

    return $word.$sep;
}
}









my $password = makepass();
print( "Randomly generated password: " . $password . "\n" );
