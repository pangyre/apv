package SanitizerX;
use warnings;
use strict;
use Carp;
use CSS::Tiny;
use HTML::Tagset;
use HTML::Entities;
use HTML::TokeParser::Simple;
use XML::LibXML;
use URI;
use Sub::Exporter -setup => {
    exports => [ qw( sanitize_html ) ],
    groups => [ default => [ qw( sanitize_html ) ] ],
};

=head1 Known issues to fix

Scheme on hrefs must be validated: /https?/

CSS parsing must be vetted and have @import and potential shortcuts pulled.

Final pass through XML::LibXML to ensure well formed HTML.

=cut

our %AllowedTags = %HTML::Tagset::isKnown;

# I put in HTML5 too though they aren't in the isKnown list currently.
delete @AllowedTags{qw( html head meta style body title object embed
                        bgsound layer
                        noscript script param video iframe img link
                        applet area base basefont blink dir form input
                        option select frame frameset ilayer video 
                        isindex listing map noframes noembed nolayer
                        menu optgroup param textarea
                        canvas audio command datalist figure keygen source
                        ~comment ~directive ~literal ~pi )};

$AllowedTags{"br/"} = 1; # Known common bad case.
$AllowedTags{"hr/"} = 1; # Known common bad case.

our %AllowedAttributes = map { $_ => 1 } qw( title href style );

# this passes to HTML::TokeParser::Simple which takes a string ref,
# a file handle, or a file name as argument.

# Side issue: <pre> can break a page layout.
# Fix in stylesheets, not inline -- white-space:pre-line will fix this
# without breaking most expectations.

sub sanitize_html {
   my $html_thing = shift || croak "You must give an argument to sanitize_html";
   my $renew = "";
   my $p = HTML::TokeParser::Simple->new($html_thing);
   no warnings "uninitialized";
   while ( my $token = $p->get_token )
   {
       if ( $token->is_start_tag )
       {
#           warn "Dropping ", $token->as_is and
               next unless $AllowedTags{$token->get_tag};

           my $attrseq = $token->get_attrseq;
           @$attrseq = grep { $AllowedAttributes{$_} } @$attrseq;
           $token->rewrite_tag;

           if ( my $style = $token->get_attr("style") )
           {
               my $css = CSS::Tiny->read_string("_null_ { $style }");
               $token->set_attr( style => format_css($css->{_null_}) );
           }
           if ( my $href = $token->get_attr("href") )
           {
               my $uri = URI->new($href);
               $token->delete_attr("href")
                   unless $uri->scheme =~ /\Ahttps?\z/i
                   and
                   $uri->host =~ /\A[a-z0-9]+\.[a-z0-9]+\z/i;
           }
           $token->rewrite_tag;

           $renew .= $token->as_is;
       }
       elsif ( $token->is_end_tag )
           {
           next unless $AllowedTags{$token->get_tag};
           $token->rewrite_tag;
           $renew .= $token->as_is;
       }
       elsif ( $token->is_text and ! $token->[-1] )
           {
           $renew .= encode_entities($token->as_is);
       }
       elsif ( $token->is_text
               or $token->is_pi
               or $token->is_comment
               or $token->is_declaration )
           {
           # Skip PI/CDATA/comment/script-body stuff.
           }
       else
           {
           die "Unhandled ", ref($token), " - what to do? --> ", $token->as_is;
       }
   }

   my $libxml = XML::LibXML->new;
   $libxml->recover_silently(1);
   my $doc = $libxml->parse_html_string(<<"");
<html><head><title>untitled</title></head><body>
<div id="0x7377CCD850F111E0BFA695BADFF11978">
$renew
</div>
</body></html>

   my $wrapper = [ $doc->findnodes('//div[@id="0x7377CCD850F111E0BFA695BADFF11978"]') ]->[0];
   my $renew2 = "";
   $wrapper->normalize;
   for ( $wrapper->findnodes("//a") )
   {
       $_->parentNode->removeChild($_)
           unless $_->hasAttribute("href");
   }
   for ( $wrapper->findnodes("//*") )
   {
       $_->parentNode->removeChild($_)
           unless $_->textContent() =~ /\S/;
   }

   $renew2 .= $_->serialize(1) for $wrapper->childNodes;
   $renew2 =~ s/\A\s+|\s+\z//g;
   $renew2;
}

# subs -----------------------------------------
sub format_css {
    my $css = shift || return '';
    my @pairs;
    for my $attr ( sort keys %{$css} )
        {
        next if $css->{$attr} =~ /\burl\b/i; # Skip anything that loads urls.
        push @pairs, "$attr:$css->{$attr}";
    }
    join ";", @pairs, ""; # "" -> gets closing ";"
}
1;

__DATA__
