#!/usr/bin/perl

use strict;
use warnings;

use Test::More; # 'no_plan';
BEGIN { plan tests => 8 };

use Test::Differences;
use English '-no_match_vars';

my $original_execute;
BEGIN {
	use_ok 'Test::Environment', qw{
		PostgreSQL
	};
	$original_execute = \&Test::Environment::Plugin::PostgreSQL::execute;
}

my @execute_args;
my $username = 'user1';
my $password = 'pass1';
my $database = 'db';
my $hostname = 'host';
my $port     = 'port';

psql(
	'username' => $username,
	'password' => $password,
	'database' => $database,
	'hostname' => $hostname,
	'port'     => $port,
);

is($ENV{'PGUSER'},     $username, 'check if psql set the postres PGUSER');
is($ENV{'PGPASSWORD'}, $password, 'check if psql set the postres PGPASSWORD');
is($ENV{'PGDATABASE'}, $database, 'check if psql set the postres PGDATABASE');
is($ENV{'PGHOST'},     $hostname, 'check if psql set the postres PGHOST');
is($ENV{'PGPORT'},     $port,     'check if psql set the postres PGPORT');

my @output = psql(
	'execution_path'  => '/tmp',
	'command'         => 'SELECT',
	'output_filename' => '/tmp/test.out',
	'switches'        => '-x',
);

eq_or_diff(
	[ @execute_args ],
	[ 'cd', '/tmp', 'psql', '-x', '-o', '"/tmp/test.out"', '-c', 'SELECT;' ],
	'check call to execute'
);

is($output[0], 'psql -x -o "/tmp/test.out" -c SELECT;', 'check output');


no warnings 'redefine';

sub Test::Environment::Plugin::PostgreSQL::execute {
	push @execute_args, @_;
	unshift @_, 'echo', '-n';
	return $original_execute->(@_);
}
