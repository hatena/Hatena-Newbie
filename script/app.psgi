use strict;
use warnings;
use utf8;

use lib 'lib';

use Hatena::Newbie;
use Hatena::Newbie::Config;

use Path::Class qw(file);
use Plack::Builder;

my $app = Hatena::Newbie->as_psgi;
my $root = config->root;

builder {
    enable 'Runtime';
    enable 'Head';

    # static file

    enable 'Static', (
        path => qr<^/(?:images|js|css)/>,
        root => config->param('dir.static.root'),
    );
    enable 'Static', (
        path => qr<^/favicon\.ico$>,
        root => config->param('dir.static.favicon'),
    );

    # access and error logs

    my $log = +{ map {
        my $file = file($ENV{uc "${_}_log"} || config->param("file.log.${_}"));
        $file->dir->mkpath;
        my $fh = $file->open('>>') or die "Cannot open >> $file: $!";
        $fh->autoflush(1);
        $_ => $fh;
    } qw(access error) };

    enable sub {
        my $app = shift;
        sub {
            my $env = shift;
            $env->{'psgi.errors'} = $log->{error};
            return $app->($env);
        };
    };

    enable 'AccessLog::Timed', (
        logger => sub {
            my $fh = $log->{access};
            print $fh @_;
        },
        format => join(
            "\t",
            'time:%t',
            'host:%h',
            'domain:%V',
            'req:%r',
            'status:%>s',
            'size:%b',
            'referer:%{Referer}i',
            'ua:%{User-Agent}i',
            'taken:%D',
            'xdispatch:%{X-Dispatch}o',
        )
    );

    enable 'HTTPExceptions';

    $app;
};
