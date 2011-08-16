#!/usr/bin/env perl
use strict;
use warnings;
use Plack::Request;
use Data::Dump;
sub {
    my $req = Plack::Request->new(shift);
    my $body = Data::Dump::dump($req);
    $body .= "\n\n-- \n" . $req->content . "\n"
        if $req->content;

    return [ 200,
             [ "Content-Type" => "text/plain; charset=utf-8",
               "Content-Length" => length($body), ],
             [ $body ]
           ];
};
