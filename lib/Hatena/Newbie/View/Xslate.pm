package Hatena::Newbie::View::Xslate;

use strict;
use warnings;
use utf8;

use Hatena::Newbie::Config;

use Text::Xslate ();

our $tx = Text::Xslate->new(
    path      => [ config->root->subdir('templates') ],
    cache     => 0,
    cache_dir => config->root->subdir(qw(tmp xslate)),
    syntax    => 'TTerse',
    module    => [ qw(Text::Xslate::Bridge::TT2Like) ],
    function  => {
    },
);

sub render_file {
    my ($class, $file, $args) = @_;
    my $content = $tx->render($file, $args);
    $content =~ s/^\s+$//mg;
    $content =~ s/>\n+/>\n/g;
    return $content;
}

1;
