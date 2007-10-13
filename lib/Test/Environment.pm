package Test::Environment;

=head1 NAME

Test::Environment - 

=cut

use strict;
use warnings;

use Carp::Clan;
use English '-no_match_vars';
use File::Basename;

BEGIN {
	$ENV{'RUNNING_ENVIRONMENT'} = 'testing';
}

=head2 import()

=cut

sub import {
	my $package = shift;
	my @args    = @_;

	foreach my $plugin_name (@args) {
		croak 'bad plugin name' if $plugin_name !~ m{^\w+(::\w+)*$}xms;
		
		my $plugin_module_name = 'Test::Environment::Plugin::'.$plugin_name; 
		eval 'use '.$plugin_module_name.';';
		if ($EVAL_ERROR) {
			croak 'Failed to load "'.$plugin_module_name.'" - '.$EVAL_ERROR;
		}
	}
}

1;


=head1 AUTHOR

Jozef Kutej, E<lt>jk@E<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2007 by Jozef Kutej

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.


=cut
