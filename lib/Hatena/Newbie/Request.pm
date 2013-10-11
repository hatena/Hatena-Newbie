package Hatena::Newbie::Request;

use strict;
use warnings;
use utf8;

use parent 'Plack::Request';

use Hash::MultiValue;

sub parameters {
    my $self = shift;

    $self->env->{'plack.request.merged'} ||= do {
        my $query = $self->query_parameters;
        my $body  = $self->body_parameters;
        my $path  = $self->route_parameters;
        Hash::MultiValue->new($path->flatten, $query->flatten, $body->flatten);
    };
}

sub route_parameters {
    my ($self) = @_;
    return $self->env->{'hatena.newbie.route.parameters'} ||=
        Hash::MultiValue->new(%{ $self->env->{'hatena.newbie.route'} });
}

sub is_xhr {
    my $self = shift;
    return ( $self->header('X-Requested-With') || '' ) eq 'XMLHttpRequest';
}

1;
