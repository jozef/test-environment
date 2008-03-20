package # hide from CPAN indexer
    Apache2::Log;

=head1 NAME

Test::Environment::Plugin::Apache2::Apache2::Log - fake Apache2::Log for Test::Environment

=head1 SYNOPSIS

=head1 DESCRIPTION

=cut

use warnings;
use strict;

our $VERSION = '0.01';

use Log::Log4perl;
use List::MoreUtils 'none';

sub Apache2::RequestRec::log {
    my $self   = shift;
    
    return Log::Log4perl::get_logger();
}

1;
