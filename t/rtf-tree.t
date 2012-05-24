#!/usr/bin/env perl
use strictures;
use Test::More;
use Path::Class "dir", "file";
#---------------------------------------------------------------------
my $test;
BEGIN {
    $test = file( File::Spec->rel2abs(__FILE__) );
}
use lib dir( $test->parent->parent, "lib")->stringify;
require tRTF;

my $fixtures = dir( $test->parent->parent, "fixture/rtf" );

ok( tRTF->new( type => "rtf" ),
    q{tRTF->new( type => "rtf" )} );


subtest "Hello, World!" => sub {
    my $fixture = file($fixtures,"hello.rtf");

    plan -e $fixture ?
        ( tests => 3 ) : ( skip_all => "fixture $fixture is missing" );

    my $rtf = tRTF->new( type => "rtf" );

    ok( $rtf->parse( file => $fixture ),
        '$rtf->parse( file => $fixture )' );

    is( $rtf->text_content, "Hello, World!",
        'Hello, World!' );

    is( tRTF->new
        ->parse( file => $fixture )
        ->text_content,
        "Hello, World!",
        "new->parse->text_content" );
};

subtest "Minimal" => sub {
    my $fixture = file($fixtures,"minimal.rtf");

    plan -e $fixture ?
        ( tests => 2 ) : ( skip_all => "fixture $fixture is missing" );

    my $rtf = tRTF->new( type => "rtf" );

    ok( $rtf->parse( file => $fixture ),
        '$rtf->parse( file => $fixture )' );

    my $expect = "This text has some markup.";

    is( $rtf->text_content, $expect, $expect );
};

subtest "Lines" => sub {
    my $fixture = file($fixtures,"lines.rtf");

    plan -e $fixture ?
        ( tests => 2 ) : ( skip_all => "fixture $fixture is missing" );

    my $rtf = tRTF->new( type => "rtf" );

    ok( $rtf->parse( file => $fixture ),
        '$rtf->parse( file => $fixture )' );

    my $esc = "one\\ntwo\\nfive\\n";
    my $expect = eval '"' . $esc . '"';
    is( $rtf->text_content, $expect, "Lines work: $esc" );
};

done_testing();

exit 0;

__DATA__
