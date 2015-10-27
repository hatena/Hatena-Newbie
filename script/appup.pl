#!/usr/bin/env perl
use strict;
use warnings;

use Path::Class qw(file);

my $Root = file(__FILE__)->dir->parent->resolve->absolute;
unshift @INC, glob $Root->subdir('modules', '*', 'lib');
unshift @INC, $Root->subdir('lib').q();

$ENV{DEBUG} = 1 unless defined $ENV{DEBUG};

my $config = 'Hatena::Newbie::Config';
eval "require $config" or die $@;

my $runner = Plack::Runner::Hatena::Newbie->new;
$runner->parse_options(
    '--port' => $config->param('server.port'),
    '--app'  => 'script/app.psgi',
    '--Reload' => join(',', glob 'lib modules/*/lib'),
    @ARGV,
);

$ENV{HATENA_NEWBIE_ENV} = $runner->{env} || 'local';
$runner->{env} = 'development';

my $options = +{ @{ $runner->{options} } };

my $server = Proclet::Hatena::Newbie->new(
    color => 1,
    log => {
        access => $config->param('file.log.access'),
        error  => $config->param('file.log.error'),
    },
    runner => $runner,
    %$options,
);

# --enable-kyt-prof
if ($options->{kyt_prof}) {
    require Devel::KYTProf;
    Devel::KYTProf->namespace_regex(qr/^Hatena::Newbie/);
}

$server->run;

package Plack::Runner::Hatena::Newbie;
use strict;
use warnings;
use parent 'Plack::Runner';
use Plack::Runner;
use Plack::Builder;

sub prepare_devel {
    my ($self, $app) = @_;

    $app = Plack::Runner::build {
        my $app = shift;
        my $static = qr<^/(images/|js/|css/|favicon\.ico)>;

        builder {
            enable 'Lint';
            enable 'StackTrace::RethrowFriendly';
            enable_if { $_[0]->{PATH_INFO} !~ $static } 'AccessLog';

            mount '/'   => $app;
        };
    } $app;

    push @{$self->{options}}, server_ready => sub {
        my($args) = @_;
        my $name  = $args->{server_software} || ref($args); # $args is $server
        my $host  = $args->{host} || 0;
        my $proto = $args->{proto} || 'http';
        my $port  = $args->{port};
        print STDERR "$name: Accepting connections at $proto://$host:$port/\n";
    };

    $app;
}

package Proclet::Hatena::Newbie;
use strict;
use warnings;
use parent 'Proclet';
use Carp qw(carp);
use Path::Class qw(file);

sub new {
    my ($class, %args) = @_;
    my $self = $class->SUPER::new(%args);
    $self->initialize(%args);
    return $self;
}

sub initialize {
    my ($self, %args) = @_;
    my $runner = $args{runner};

    if (ref $args{log} and ref $args{log} eq 'HASH') {
        $self->service(
            code => sub {
                file($args{log}->{error})->dir->mkpath;
                system 'touch', $args{log}->{error};
                system qw(tail -n 0 -F), $args{log}->{error};
            },
            tag  => 'log',
        );
    }

    $runner or carp 'No runner is specified';
    $self->service(
        code => sub { $runner->run },
        tag => 'app',
    );
}
