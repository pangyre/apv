#!/usr/bin/env perl
use strictures;
use Test::More;
use Path::Class "dir", "file";
#---------------------------------------------------------------------
my $self = file( File::Spec->rel2abs(__FILE__) );

my $fixtures = dir( $self->parent->parent, "fixture/rtf" );

my $hello = file($fixtures,"hello.rtf");

use tRTF;

ok( my $rtf = tRTF->new( type => "rtf" ),
    q{tRTF->new( type => "rtf" )} );

ok( $rtf->parse( file => $hello ),
    '$rtf->parse( file => $hello )' );

is( $rtf->text_content, "Hello, World!",
    'Hello, World!' );

done_testing();

exit 0;

__DATA__
