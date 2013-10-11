package t::Hatena::Newbie::Model::User;

use strict;
use warnings;
use utf8;
use lib 't/lib';

use Test::Hatena::Newbie;

use Test::More;

use parent 'Test::Class';

use DateTime;
use DateTime::Format::MySQL;

sub _use : Test(startup => 1) {
    my ($self) = @_;
    use_ok 'Hatena::Newbie::Model::User';
}

sub _accessor : Test(3) {
    my $now = DateTime->now;
    my $user = Hatena::Newbie::Model::User->new(
        user_id => 1,
        name    => 'user_name',
        created => DateTime::Format::MySQL->format_datetime($now),
    );
    is $user->user_id, 1;
    is $user->name, 'user_name';
    is $user->created->epoch, $now->epoch;
}

__PACKAGE__->runtests;

1;
