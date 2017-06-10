#!/usr/bin/env perl
use strictures;
use WebService::Validator::CSS::W3C;
use Path::Tiny; # <-- Slurp file/page to check. LWP to get?
use Scalar::Util "blessed";
use LWP::Simple;

my $thing = shift || die "Give a file or webpage to vaidate";
$thing = -e $thing ? path($thing) : URI->new($thing);

my $val = WebService::Validator::CSS::W3C->new;

my $string = $thing->can("host") ? get($thing) : $thing->slurp;
my $ok = $val->validate( profile => "css3",
                          string => $string );


if ( $ok and ! $val->is_valid )
{
    print "Errors:\n";
    for my $error ( $val->errors )
    {
        $error->{message} =~ s/\A\s+|\s+\z//g;
        next if $error->{message} eq "Parse Error";
        printf "  * %s\n", $error->{message};
    }
}
elsif ( $ok )
{
    print "OK!\n";
}
else
{
    print "Uncaught error...\n";
}

print $thing, $/;
