package Hatena::Newbie;

use strict;
use warnings;
use utf8;

use Class::Load qw(load_class);
use Guard;  # guard
use HTTP::Status ();
use Try::Tiny;

use Hatena::Newbie::Error;
use Hatena::Newbie::Context;
use Hatena::Newbie::Config;
use Hatena::Newbie::Logger qw(critf);

sub as_psgi {
    my $class = shift;
    return sub {
        my $env = shift;
        return $class->run($env);
    };
}

my $ContextClass;
sub run {
    my ($class, $env) = @_;

    my $context = Hatena::Newbie::Context->from_env($env);
    my $dispatch;
    try {
        my $route = $context->route or Hatena::Newbie::Error->throw(404);
        $route->{engine} or Hatena::Newbie::Error->throw(404);
        $env->{'hatena.newbie.route'} = $route;

        my $engine = join '::', __PACKAGE__, 'Engine', $route->{engine};
        my $action = $route->{action} || 'default';
        $dispatch = "$engine#$action";

        load_class $engine;

        $class->before_dispatch($context);

        my $handler = $engine->can($action) or Hatena::Newbie::Error->throw(501);

        $engine->$handler($context);
    }
    catch {
        my $e = $_;
        my $res = $context->request->new_response;
        if (eval { $e->isa('Hatena::Newbie::Error') }) {
            my $message = $e->{message} || HTTP::Status::status_message($e->{code});
            $res->code($e->{code});
            $res->header('X-Error-Message' => $message);
            $res->content_type('text/plain');
            $res->content($message);
        }
        else {
            critf "%s", $e;
            my $message = (config->env =~ /production/) ? 'Internal Server Error' : $e;
            $res->code(500);
            $res->content_type('text/plain');
            $res->content($message);
        }
        $context->response($res);
    }
    finally {
        $class->after_dispatch($context);
    };

    $context->res->headers->header(X_Dispatch => $dispatch);
    return $context->res->finalize;
}

sub before_dispatch {
    my ($class, $c) = @_;
    # -------- csrfのための何らかの処理が欲しい -----
    # if ($c->req->method eq 'POST') {
    #     if ($c->user) {
    #         my $rkm = $c->req->parameter(body => 'rkm') or die 400;
    #         my $rkc = $c->req->parameter(body => 'rkc') or die 400;
    #         if ($rkm ne $c->user->rkm || $rkc ne $c->user->rkc) {
    #             die 400;
    #         }
    #     } else {
    #         die 400;
    #     }
    # }
}

sub after_dispatch {
    my ($class, $c) = @_;
}

1;
