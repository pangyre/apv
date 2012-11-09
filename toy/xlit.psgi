#!/usr/bin/env perl
use strictures;
use utf8;
use Encode;
use Text::Unidecode;
use Plack::Request;

=pod

=encoding utf8

=head1 Synopsis

Transliteration (all roads lead to English-centric ASCII in this case) toy.

  plackup xlit.psgi
  HTTP::Server::PSGI: Accepting connections at http://0:5000/

=head2 A test string or two or three or ibid, etc, eg, cf, ie, et al

 北京, 香港, 上海, 新加坡共和国… சிங்கப்பூர் குடியரசு
 Φιμ αμετ αυδιρε φεριθυς ατ, νε φις δωλορε ινθεγρε ευισμοδ…
 l'été est arrivé à peine après aôut
 ¿España es un paìs muy lindo?
  みせる です
 Здравствуйте
السلام عليكم 
  바보 양키스

L<Plack>, L<plackup>, et cetera.

=cut

my $template = do { local $/; <DATA> };

sub {
    my $env = shift; # PSGI env
    my $req = Plack::Request->new($env);
    my $text = decode("UTF-8",$req->parameters->{text} || "");
    my $unidecoded = unidecode($text);
    ( my $page = $template ) =~ s/{TEXT}/$text/;
    $page =~ s/{OUT}/$unidecoded/;

    my $length = length($template);
    [ 200, [ "Content-Type" => "text/html; charset=utf-8" ],
      [ encode("UTF-8", $page) ] ];
}

__DATA__
<html>
<head>
  <title>XLITERAT0R!</title>
  <style>* { font-family: helvetica neue, helvetica }</style>
</head>
<body style="height:80%;width:90%;padding:5%;margin:0;">
<h1><a href="https://github.com/pangyre/apv/blob/master/toy/xlit.psgi">xlit.psgi</a></h1>
<form style="width:45%; float:left">
<p>
  <textarea name="text" style="width:100%;
  height:15em">{TEXT}</textarea>
  <input type="submit" />
</p>
</form>
<p style="width:45%; margin-left:3%; float:left; white-space:pre-wrap">
{OUT}
</p>
</body>
</html>
