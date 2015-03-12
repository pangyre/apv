#!/usr/bin/env perl
use 5.01;
use strictures;
use Number::Format "format_number";
use Getopt::Long;

GetOptions( "principal=f" => \my $p,
            "rate=f" => \my $r,
            "years=f" => \my $t,
            "compounded=i" => \my $n );

my $A = $p * ( 1 + $r/$n )**($n*$t);

say '$', format_number($A,2);

exit 0;

__DATA__
