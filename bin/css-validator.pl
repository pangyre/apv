#!/usr/bin/env perl
use strictures;
use WebService::Validator::CSS::W3C;
use Path::Tiny; # <-- Slurp file/page to check. LWP to get?

my $css = "p { color: not-a-color }";
my $val = WebService::Validator::CSS::W3C->new;
my $ok = $val->validate(string => $css);

if ( $ok and ! $val->is_valid )
{
    print "Errors:\n";
    printf "  * %s\n", $_->{message}
        for $val->errors;
}
