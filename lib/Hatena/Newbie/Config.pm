package Hatena::Newbie::Config;

use strict;
use warnings;
use utf8;

use Hatena::Newbie::Config::Route;

use Config::ENV 'HATENA_NEWBIE_ENV', export => 'config';
use Path::Class qw(file);

my $Router = Hatena::Newbie::Config::Route->make_router;
my $Root = file(__FILE__)->dir->parent->parent->parent->absolute;

sub router { $Router }
sub root { $Root }

common {
};

my $server_port = $ENV{SERVER_PORT} || 3000;

config default => {
    'server.port'     => $server_port,
    'origin'          => "http://localhost:${server_port}",
    'file.log.access' => 'log/access_log',
    'file.log.error'  => 'log/error_log',
    'dir.static.root'    => 'static',
    'dir.static.favicon' => 'static/images',
};

config production => {
};

config local => {
    parent('default'),
    db => {
        hatena_newbie => {
            user     => 'nobody',
            password => 'nobody',
            dsn      => 'dbi:mysql:dbname=hatena_newbie;host=localhost',
        },
    },
    db_timezone => 'UTC',
};

config test => {
    parent('default'),

    db => {
        hatena_newbie => {
            user     => 'nobody',
            password => 'nobody',
            dsn      => 'dbi:mysql:dbname=hatena_newbie_test;host=localhost',
        },
    },
    db_timezone => 'UTC',
};

1;
