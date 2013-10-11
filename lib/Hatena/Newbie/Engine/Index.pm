package Hatena::Newbie::Engine::Index;

use strict;
use warnings;
use utf8;

sub default {
    my ($class, $c) = @_;
    $c->html('index.html');
}

1;
__END__
