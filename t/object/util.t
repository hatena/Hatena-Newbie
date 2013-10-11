package t::Hatena::Newbie::DBI::Factory;

use strict;
use warnings;
use utf8;
use lib 't/lib';

use parent 'Test::Class';

use Test::More;

use Test::Hatena::Newbie;

use Hatena::Newbie::Util;

sub _use : Test(1) {
    use_ok 'Hatena::Newbie::Util';
}

__PACKAGE__->runtests;

1;
