#!/usr/bin/perl

use strict;
use warnings;

use Test::More; # 'no_plan';
BEGIN { plan tests => 3 };

use English '-no_match_vars';

BEGIN {
	use_ok 'Test::Environment', qw{
		PostgreSQL
	};
}

my $username = 'user1';
my $password = 'pass1';

psql(
	'username' => $username,
	'password' => $password,
);

is($ENV{'PGUSER'},     $username, 'check if psql set the postres PGUSER');
is($ENV{'PGPASSWORD'}, $password, 'check if psql set the postres PGPASSWORD');


