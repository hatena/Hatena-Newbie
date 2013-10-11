package Hatena::Newbie::Config::Route;

use strict;
use warnings;
use utf8;

use Router::Simple::Declare;

sub make_router {
    return router {
        connect '/' => {
            engine => 'Index',
            action => 'default',
        };
        connect '/user/list' => {
            engine => 'User',
            action => 'list',
        };
        connect '/user/register' => {
            engine => 'User',
            action => 'register',
        } => { method => 'POST' };
    };
}

1;
