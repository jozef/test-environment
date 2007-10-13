package Test::Environment::Plugin::PostgreSQL;

=head1 NAME

Test::Environment::Plugin::PostgreSQL - 

=cut

use strict;
use warnings;

use base qw{ Exporter };
our @EXPORT = qw{
	psql
};

use Carp::Clan;

sub import {
	my $package = shift;

	# export symbols two levels up - to the Test::Environment caller
	__PACKAGE__->export_to_level(2, $package, @EXPORT);
}


# let the psql command be executed easily
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
	my $egrep           = $arg{'egrep'};
	my $invert_match    = $arg{'invert_match'};
	
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
	
	if (defined $stderr_redirect) {
		push(@additional_parameters, '2>'.$stderr_redirect)
	}

	if (defined $egrep) {
		push(@additional_parameters,
			'|',
			'grep',
			'-E',
		);
		push(@additional_parameters, '-v') if $invert_match;
		push(@additional_parameters, '"'.$egrep.'"');
	}
	
	my @pre_parameters;
	if (defined $execution_path) {
		push(@pre_parameters,
			'cd',
			'"'.$execution_path.'"',
			';',
		);
	}
	
	#construct command, print and execute it then
	my @cmd = (
		@pre_parameters,
		'psql',
		'-c',
		'"'.$command.'"',
		@additional_parameters,
	);
	my $cmd = join(' ', @cmd);
	print 'executing: ', $cmd, "\n";
	my @ret = `$cmd`;
	
	return join('', @ret);
}

1;
