package # hide from CPAN indexer
    Apache2::RequestRec;

=head1 NAME

Test::Environment::Plugin::Apache2::Apache2::RequestRec - fake Apache2::RequestRec for Test::Environment

=head1 SYNOPSIS

=head1 DESCRIPTION

=cut

use warnings;
use strict;

our $VERSION = '0.01';

use APR::Pool;
use APR::Table;

use base 'Class::Accessor::Fast';
=head1 PROPERTIES

=cut

__PACKAGE__->mk_accessors(qw{
    hostname
    uri
    apr_pool
    args
});

sub new {
    my $class = shift;
    my $self = $class->SUPER::new({
        'apr_pool'    => APR::Pool->new,
        @_,
    });
    
    # initilize all apr tables
    foreach my $apt_table_name (qw(apr_table headers_in headers_out subprocess_env pnotes)) {
        $self->{$apt_table_name} = APR::Table::make($self->apr_pool, 100)
            if not defined $self->{$apt_table_name};
    }
    
    return $self;
}

=cut

sub pnotes {
    my $self      = shift;
    my $note_name = shift;
    
    if (@_ > 0) {
        $self->{'pnotes'}->{$note_name} = shift;
    }
    
    return $self->{'pnotes'}->{$note_name};
}

=cut

sub pnotes         { return shift->get_set('pnotes',         @_) };
sub apr_table      { return shift->get_set('apr_table',      @_) };
sub subprocess_env { return shift->get_set('subprocess_env', @_) };
sub headers_in     { return shift->get_set('headers_in',     @_) };
sub headers_out    { return shift->get_set('headers_out',    @_) };

sub get_set {
    my $self = shift;
    my $name = shift;
   
    if (@_ > 0) {
        my $key_name = shift;
        if (@_ > 0) {
            $self->{$name}->add($key_name => shift);
        }
        return $self->{$name}->get($key_name);
    }
    else {
        return $self->{$name};
    }
}

sub Apache2::Filter::r {
    my $self   = shift;
    $self->request_rec(@_);
}

sub Apache2::Filter::request_rec {
    my $self   = shift;
    
    if (@_ > 0) {
        $self->{'request_rec'} = shift;
    }
    
    if (ref $self->{'request_rec'} ne __PACKAGE__) {
        $self->{'request_rec'} = bless $self->{'request_rec'}, __PACKAGE__;
    }
    
        
    return $self->{'request_rec'};
}


'writing on the wall';
