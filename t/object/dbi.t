package t::Hatena::Newbie::DBI;

use strict;
use warnings;
use utf8;
use lib 't/lib';

use parent 'Test::Class';

use Test::Hatena::Newbie;
use Test::More;

sub _use : Test(1) {
    use_ok 'Hatena::Newbie::DBI';
}

__PACKAGE__->runtests;

1;
