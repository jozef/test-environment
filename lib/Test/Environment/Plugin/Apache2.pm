package Test::Environment::Plugin::Apache2;

=head1 NAME

Test::Environment::Plugin::Apache2 - simulate Apache2 modules

=head1 SYNOPSIS

	use Test::Environment qw{
		Apache2
	};


=head1 DESCRIPTION

This module will just sets:

	unshift @INC, File::Spec->catdir(File::Basename::dirname(__FILE__), 'Apache');

So that the fake Apache2 modules are found and loaded from there.

=cut

use warnings;
use strict;

our $VERSION = '0.05';

use File::Basename qw();
use File::Spec qw();

unshift @INC, File::Spec->catdir(File::Basename::dirname(__FILE__), 'Apache2');

1;


__END__

=head1 AUTHOR

Jozef Kutej

=cut
