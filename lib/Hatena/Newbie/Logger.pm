package Hatena::Newbie::Logger;

use strict;
use warnings;
use utf8;

use parent qw(Log::Minimal);

our $ENV_DEBUG = 'HATENA_NEWBIE_DEBUG';
our $HANDLE = \*STDERR;
our $PRINT = sub {
    my ($time, $level, $mess, $trace) = @_;
    print { $HANDLE } "$time [$level] $mess @ $trace\n";
};

1;
__END__
