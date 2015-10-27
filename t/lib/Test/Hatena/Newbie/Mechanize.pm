package Test::Hatena::Newbie::Mechanize;

use strict;
use warnings;
use utf8;

use parent qw(Test::WWW::Mechanize::PSGI);
use Plack::Builder;

use Test::More ();

use Exporter qw(import);
our @EXPORT = qw(create_mech);

use Hatena::Newbie;

my $app = builder {
    enable 'HTTPExceptions';

    Hatena::Newbie->as_psgi;
};

sub create_mech (;%) {
    return __PACKAGE__->new(@_);
}

sub new {
    my ($class, %opts) = @_;

    my $self = $class->SUPER::new(
        app     => $app,
        %opts,
    );

    return $self;
}

1;
