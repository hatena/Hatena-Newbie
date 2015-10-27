package t::Hatena::Newbie::DBI::Factory;
use strict;
use warnings;
use utf8;

use lib 't/lib';

use parent 'Test::Class';

use Test::More;

use Test::Hatena::Newbie;

use Hatena::Newbie::Context;

sub _use : Test(1) {
    use_ok 'Hatena::Newbie::Context';
}

sub _db_config : Test(3) {
    my $factory = Hatena::Newbie::Context->new;
    my $db_config = $factory->db_config('hatena_newbie');
    is $db_config->{user}, 'nobody';
    is $db_config->{password}, 'nobody';
    is $db_config->{dsn}, 'dbi:mysql:dbname=hatena_newbie_test;host=localhost';
}

sub _dbh : Test(1) {
    my $factory = Hatena::Newbie::Context->new;
    my $dbh = $factory->dbh;
    ok $dbh;

}

__PACKAGE__->runtests;

1;
