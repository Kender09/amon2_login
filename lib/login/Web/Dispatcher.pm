package login::Web::Dispatcher;
use strict;
use warnings;
use utf8;
use Amon2::Web::Dispatcher::RouterBoom;

use Data::Dumper;


any '/' => sub {
    my ($c) = @_;
    my $counter = $c->session->get('counter') || 0;
    $counter++;
    $c->session->set('counter' => $counter);
    return $c->render('index.tx', {
        counter => $counter,
    });
};

any '/login' => sub {
    my ($c) = @_;
    return $c->render('login.tx', {
        message => $c->req->parameters->{message}
    });
};

post '/login_pos' => sub {
    my ($c) = @_;
    warn Dumper $c->req->parameters->{id};
    my $id = $c->req->parameters->{id};
    $c->session->expire();
    return $c->redirect('/login', {
      message => " $id ログイン"
    });
};


any '/sign_up' => sub {
    my ($c) = @_;
    return $c->render('sign_up.tx', {
    });
};

post '/reset_counter' => sub {
    my $c = shift;
    $c->session->remove('counter');
    return $c->redirect('/');
};

post '/account/logout' => sub {
    my ($c) = @_;
    $c->session->expire();
    return $c->redirect('/');
};

1;
