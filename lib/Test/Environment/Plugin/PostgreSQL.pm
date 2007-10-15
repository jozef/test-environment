package Test::Environment::Plugin::PostgreSQL;

=head1 NAME

Test::Environment::Plugin::PostgreSQL - PostreSQL psql function for testing

=head1 SYNOPSIS

	use Test::Environment qw{
		PostgreSQL
	};
	
	# set database credentials
	psql(
		'database' => $config->{'db'}->{'database'},
		'hostname' => $config->{'db'}->{'hostname'},
		'username' => $config->{'db'}->{'username'},
		'password' => $config->{'db'}->{'password'},
	);
	
	# execute sql query
	my @output = psql(
		'switches' => '--expanded',
		'command'  => 'SELECT * FROM Table',
		# ..., see psql function description for more
	)


=head1 DESCRIPTION

This plugin will export 'psql' function that can be used to execute PostreSQL psql command
with lot of options for testing.

=cut


use strict;
use warnings;

use base qw{ Exporter };
our @EXPORT = qw{
	psql
};
our $debug = 0;

use Carp::Clan;
use String::ShellQuote;


=head1 FUNCTIONS

=head2 import

All functions are exported 2 levels up. That is to the use Test::Environment caller.

=cut

sub import {
	my $package = shift;

	# export symbols two levels up - to the Test::Environment caller
	__PACKAGE__->export_to_level(2, $package, @EXPORT);
}


=head2 psql()

psql command executed easily. Here is the list of options that can be used.

Option related to the connection to the database.

	username
	password
	database
	hostname
	port

By setting this PostreSQL %ENV variables will be set. So for psql command to the
same databse you need to set them only once.

The rest of the option related to the psql command.

	command         - scalar or array ref of sql commands
	switches        - scalar or array of additional psql switches
	output_filename - the output will be written to this file (-o)
	execution_path  - before executing psql change to that folder
	stderr_redirect - will redirect stderr to stdout so that also error appears in the return value
	debug           - turn on debug mode, it can be also done globaly by setting "$ENV{'IN_DEBUG_MODE'} = 1" 

=cut

sub psql {
	my %arg = @_;
	
	$ENV{'PGUSER'}     = $arg{'username'} if exists $arg{'username'};
	$ENV{'PGPASSWORD'} = $arg{'password'} if exists $arg{'password'};
	$ENV{'PGDATABASE'} = $arg{'database'} if exists $arg{'database'};
	$ENV{'PGHOST'}     = $arg{'hostname'} if exists $arg{'hostname'};
	$ENV{'PGPORT'}     = $arg{'port'}     if exists $arg{'port'};	
	
	# function paramaters
	my $command         = $arg{'command'};
	my $output_filename = $arg{'output_filename'};
	my $execution_path  = $arg{'execution_path'};
	my $stderr_redirect = $arg{'stderr_redirect'};
	
	my @switches        = (ref $arg{'switches'} eq 'ARRAY' ? @{$arg{'switches'}} : $arg{'switches'} )
		if exists $arg{'switches'};
	
	local $debug = 1 if ($arg{'debug'} or $ENV{'IN_DEBUG_MODE'});
	
	# if there is no command return nothink to do more
	return if not defined $command;
	
	# if more commands then join them together
	if (ref $command eq 'ARRAY') {
		$command = join '; ', @{$command};
	}
	$command .= ';' if ($command !~ m{;\s*$}xms);
	
	
	my @additional_parameters;	
	if (defined $output_filename) {
		push(@additional_parameters, '-o', '"'.$output_filename.'"')
	}
	
	# redirect stderr to stdout
	open(STDERR, ">&STDOUT") if (defined $stderr_redirect);
	
	# chdir if needed
	if (defined $execution_path) {
		execute(    # done using execute so we can see it in the debug mode as cd command
			'cd',
			$execution_path,
		);
	}
		
	my @ret = execute(
		'psql',
		@switches,
		'-c',
		$command,
		@additional_parameters,
	);
	
	return @ret if defined wantarray;
	return join('', @ret);
}


=head2 execute

Executes command as system and return output.

In debug mode prints command to stderr.

=cut

sub execute {
	my $cmd = shell_quote @_;
	print STDERR '+ ', $cmd, "\n" if $debug;
	my @ret = `$cmd`;
}

1;


=head1 SEE ALSO

Test::Environment L<http://search.cpan.org/perldoc?Test::Environment>

=head1 AUTHOR

Jozef Kutej - E<lt>jozef@kutej.netE<gt>

=cut
