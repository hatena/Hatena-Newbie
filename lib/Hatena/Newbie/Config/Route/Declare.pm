package Hatena::Newbie::Config::Route::Declare;
use strict;
use warnings;

use Exporter qw(import);
use Router::Simple ();
use subs qw(connect);

our @EXPORT = qw(router connect);

our $_router;
sub router (&) {
    local $_router = Router::Simple->new;
    $_[0]->();
    $_router;
}

sub connect ($$;$) {
    my ($path, $destination, $options) = @_;
    my $on_match = $options->{on_match};
    $_router->connect($path, {}, {
        %$options,
        on_match => sub {
            my ($env, $match) = @_;
            my $params = {};
            $params->{$_} = delete $match->{$_} for keys %$match;
            $match->{parameters} = $params;
            $match->{destination} = $destination;
            return $on_match ? $on_match->($env, $match) : 1;
        },
    });
}

1;
__END__
