use strict;
use warnings;
use Test::More;

sub dna_complement {
    local $_ = @_ ? join("",@_) : $_;
    y/ATGC/TACG/;
    $_;
}

# Another idea-ish? y/ATGC/TACG/ for @_ ? @_ : $_;

is( dna_complement("AGTCATG"), "TCAGTAC",
    "AGTCATG <-> TCAGTAC" );

for ( "AGTCATG" )
{
   is( dna_complement, "TCAGTAC",
     'Passing by $_ works');
}

for ( "AGTCATG" )
{
   dna_complement();
   isnt( $_, "TCAGTAC", '$_ is not changed in place to its complement' );
   is( $_, "AGTCATG", '$_ is not updated in place at all' );
}

done_testing();
