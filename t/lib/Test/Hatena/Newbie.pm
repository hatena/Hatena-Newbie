package Test::Hatena::Newbie;

use strict;
use warnings;
use utf8;

use Path::Class;
use lib file(__FILE__)->dir->subdir('../../../../lib')->stringify;
use lib glob file(__FILE__)->dir->subdir('../../../../modules/*/lib')->stringify;

use DateTime;
use DateTime::Format::MySQL;

BEGIN {
    $ENV{HATENA_NEWBIE_ENV} = 'test';
    $ENV{PLACK_ENV} = 'test';
    $ENV{DBI_REWRITE_DSN} ||= 1;
}

use DBIx::RewriteDSN -rules => q<
    ^(.*?;mysql_socket=.*)$ $1
    ^.*?:dbname=([^;]+?)(?:_test)?(?:;.*)?$ dbi:mysql:dbname=$1_test;host=localhost
    ^(DBI:Sponge:)$ $1
    ^(.*)$ dsn:unsafe:got=$1
>;

sub import {
    my $class = shift;

    strict->import;
    warnings->import;
    utf8->import;

    set_output();

    my $code = q[
        use Test::More;
    ];
    eval $code;
    die $@ if $@;
}

sub set_output {
    # http://blog.64p.org/entry/20081026/1224990236
    # utf8 hack.
    require Test::More;
    binmode Test::More->builder->$_, ":utf8"
        for qw/output failure_output todo_output/;
    no warnings 'redefine';
    my $code = \&Test::Builder::child;
    *Test::Builder::child = sub {
        my $builder = $code->(@_);
        binmode $builder->output,         ":utf8";
        binmode $builder->failure_output, ":utf8";
        binmode $builder->todo_output,    ":utf8";
        return $builder;
    };
}

1;
