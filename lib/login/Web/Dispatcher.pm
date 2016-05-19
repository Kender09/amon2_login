package login::Web::Dispatcher;
use strict;
use warnings;
use utf8;
use Amon2::Web::Dispatcher::RouterBoom;
use Data::Dumper;
use Digest::MD5;


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
    my $message = "ログイン失敗";
    my $id = $c->req->parameters->{id};
    my $pass = $c->req->parameters->{pass};
    my $pass_hash = Digest::MD5->md5_base64($pass);
    my $sth = $c->db->prepare("SELECT * FROM login WHERE id = ? AND password = ?");
    $sth->execute($id, $pass_hash);
    if ( $sth->fetchrow_array) {
       $message = "ログイン成功";
    };
    return $c->redirect('/login', {
      message => $message
    });
};

any '/sign_up' => sub {
    my ($c) = @_;
    return $c->render('sign_up.tx', {
      message => $c->req->parameters->{message}
    });
};

post '/sign_up_pos'=>sub{
  my ($c) = @_;
  my $message = "登録失敗";
  my $id = $c->req->parameters->{id};
  my $pass = $c->req->parameters->{pass};
  my $sth = $c->db->prepare("SELECT * FROM login WHERE id = ?");
  $sth->execute($id);
  if (! ($sth->fetchrow_array) ){
    my $pass_hash = Digest::MD5->md5_base64($pass);
    $sth = $c->db->prepare("INSERT INTO login (id, password) VALUES (?, ?)");
    $sth->execute($id, $pass_hash);
    $message = "$id 登録成功";
  };
  return $c->redirect('/sign_up', {
    message => $message
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
