use strict;
use warnings;
use Test::More;


use login;
use login::Web;
use login::Web::View;
use login::Web::ViewFunctions;

use login::DB::Schema;
use login::Web::Dispatcher;


pass "All modules can load.";

done_testing;
