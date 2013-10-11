package t::Hatena::Newbie::Engine::Index;

use strict;
use warnings;
use utf8;
use lib 't/lib';

use parent 'Test::Class';

use Test::Hatena::Newbie;
use Test::Hatena::Newbie::Mechanize;

sub _get : Test(3) {
    my $mech = create_mech;
    $mech->get_ok('/');
    $mech->title_is('Hatena::Newbie');
    $mech->content_contains('Hatena-Newbie');
}

__PACKAGE__->runtests;

1;
