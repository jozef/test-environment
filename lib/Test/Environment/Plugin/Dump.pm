package Test::Environment::Plugin::Dump;

=head1 NAME

Test::Environment::Plugin::Dump - 

=cut

use strict;
use warnings;

use base qw{ Exporter };
our @EXPORT = qw{
	dump_with_name
};

use Carp::Clan;
use File::Slurp;


sub import {
	my $package = shift;

	# export symbols two levels up - to the Test::Environment caller
	__PACKAGE__->export_to_level(2, $package, @EXPORT);
}


our $dumps_folder = $FindBin::Bin.'/dumps';
sub dump_with_name {
	my $name = shift;
	
	croak 'please set dump name' if not defined $name;
	
	return read_file($dumps_folder.'/'.$name);
}

1;
