package t::Hatena::Newbie::DBI::Factory;
use strict;
use warnings;
use utf8;

use lib 't/lib';

use parent 'Test::Class';

use Test::More;

use Test::Hatena::Newbie;

use Hatena::Newbie::DBI::Factory;

sub _use : Test(1) {
    use_ok 'Hatena::Newbie::DBI::Factory';
}

sub _dbconfig : Test(3) {
    my $dbfactory = Hatena::Newbie::DBI::Factory->new;
    my $db_config = $dbfactory->dbconfig('hatena_newbie');
    is $db_config->{user}, 'hatena_newbie';
    is $db_config->{password}, 'hatena_newbie';
    is $db_config->{dsn}, 'dbi:mysql:dbname=hatena_newbie_test;host=localhost';
}

sub _dbh : Test(1) {
    my $dbfactory = Hatena::Newbie::DBI::Factory->new;
    my $dbh = $dbfactory->dbh('hatena_newbie');
    ok $dbh;

}

__PACKAGE__->runtests;

1;
