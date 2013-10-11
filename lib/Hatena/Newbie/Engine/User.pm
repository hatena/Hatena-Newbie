package Hatena::Newbie::Engine::User;

use strict;
use warnings;
use utf8;

use FormValidator::Lite;

sub list {
    my ($class, $c) = @_;

    my $users = $c->dbh('hatena_newbie')->select_all_as(q[
        SELECT * FROM user
          ORDER BY created desc
    ], "Hatena::Newbie::Model::User");

    $c->html('user/list.html', {
        users => $users,
    });
}

sub register {
    my ($class, $c) = @_;

    my $validator = FormValidator::Lite->new($c->req);
    $validator->check(
        name => ['NOT_NULL', [REGEXP => qr/^[a-zA-Z][a-zA-Z0-9_-]{2,31}$/]],
    );

    if ($validator->has_error) {
        return $c->redirect('/user/list');
    }

    $c->dbh('hatena_newbie')->query(q[
        INSERT INTO user (name, created)
          VALUES(:name, :created)
    ], {
        name    => $c->req->parameters->{name},
        created => DateTime->now,
    });

    $c->redirect('/user/list');
}

1;
