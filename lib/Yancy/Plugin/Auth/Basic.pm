package Yancy::Plugin::Auth::Basic;
our $VERSION = '0.005';
# ABSTRACT: A simple auth module for a site

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 SEE ALSO

L<Digest>

=cut

use Mojo::Base 'Mojolicious::Plugin';
use v5.24;
use experimental qw( signatures postderef );
use Digest;

sub register( $self, $app, $config ) {
    my $coll = $config->{collection};
    my $password_field = $config->{password_field};
    $app->yancy->filter->add( 'auth.digest' => sub( $name, $value, $field ) {
        return Digest->new( delete $config->{password_digest}{type}, $config->{password_digest}->%* )->add( $value )->b64digest;
    } );
    push $app->config->{collections}{$coll}{properties}{$password_field}{'x-filter'}->@*, 'auth.digest';
}

1;
