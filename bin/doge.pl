#!/usr/bin/env perl

use 5.16.0;
use Mojo::UserAgent;

say $_->text for "Mojo::UserAgent"
    ->new
    ->get("https://coinmarketcap.com/currencies/dogecoin/")
    ->result
    ->dom
    ->find(".details-panel-item--price__value")
    ->each;

__END__

class="h2 text-semi-bold details-panel-item--price__value"
