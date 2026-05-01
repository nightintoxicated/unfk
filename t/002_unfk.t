use strict;
use warnings;
use unfk;
use Test::More;

plan tests => 2;

ok(unfk::new());
my $x = unfk::new();
$x->{_command} = "ps -ef";
$x->{_tty} = "pts/1";
ok(unfk::locate_pid($x));
