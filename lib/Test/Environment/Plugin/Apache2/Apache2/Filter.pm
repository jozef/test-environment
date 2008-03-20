package # hide from CPAN indexer
    Apache2::Filter;

=head1 NAME

Test::Environment::Plugin::Apache2::Apache2::Filter - fake Apache2::Filter for Test::Environment

=head1 SYNOPSIS

=head1 DESCRIPTION

=cut

use warnings;
use strict;

our $VERSION = '0.01';

use IO::String;
use Carp::Clan ();

use base 'Class::Accessor::Fast';
=head1 PROPERTIES

=cut

__PACKAGE__->mk_accessors(qw{
    ctx
    data
    max_buffer_size
});

=head1 METHODS

=cut

sub new {
    my $class = shift;
    my $self = $class->SUPER::new({
        'data'            => '',
        'request_rec'     => {},
        'max_buffer_size' => 100,
        @_,
    });
    
    if (ref $self->data eq 'SCALAR') {
        $self->{'data'} = IO::String->new(${$self->data});
    }
    elsif (ref $self->data eq '') {
        my $filename = $self->{'data'};
        open($self->{'data'}, '<', $filename)
            or die 'failed to open "'.$filename.'": '.$!;
    }
    elsif (eval { $self->data->can('read'); }) {
    }
    else {
        Carp::Clan::croak('wrong "data" argument passed');
    }
    
    return $self;
}

sub read {
    my $self   = shift;

    my $buffer   = \$_[0];
    my $len      =  $_[1];
    
    $len = $self->max_buffer_size
        if $len > $self->max_buffer_size;
    
    return read($self->data, $$buffer, $len);
}

sub print {
    my $self   = shift;

    $self->{'data_for_next_filter'} .= @_;
}

1;
