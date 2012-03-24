#!/usr/bin/env perl
use strictures;
use Plack::Builder;
use Plack::App::Directory;
use Cwd;

my $app = Plack::App::Directory->new({ root => cwd() })->to_app;

builder {
    enable "Plack::Middleware::SSI";
    $app;
};

__END__
