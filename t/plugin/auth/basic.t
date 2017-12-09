
=head1 DESCRIPTION

This tests the basic auth module.

=head1 SEE ALSO

L<Yancy::Plugin::Auth::Basic>, L<Yancy::Backend::Test>

=cut

use v5.24;
use experimental qw( signatures postderef );
use Test::More;
use Test::Mojo;
use Mojo::JSON qw( true false );
use FindBin qw( $Bin );
use Mojo::File qw( path );
use lib "".path( $Bin, '..', '..', 'lib' );
use Digest;

use Yancy::Backend::Test;
%Yancy::Backend::Test::COLLECTIONS = (
    users => {
        doug => {
            username => 'doug',
            email => 'doug@example.com',
            password => Digest->new( 'SHA-1' )->add( '123qwe' )->b64digest,
        },
        joel => {
            username => 'joel',
            email => 'joel@example.com',
            password => Digest->new( 'SHA-1' )->add( '456rty' )->b64digest,
        },
    },
);

$ENV{MOJO_CONFIG} = path( $Bin, '..', '..', 'share/config.pl' );
$ENV{MOJO_HOME} = path( $Bin, '..', '..', 'share' );

my $t = Test::Mojo->new( 'Yancy' );
$t->app->plugin( 'Auth::Basic', {
    collection => 'users',
    id_field => 'username', # default
    password_field => 'password', # default
    password_digest => {
        type => 'SHA-1',
    },
});

subtest 'api allows saving user passwords' => sub {
    my $doug = {
        $Yancy::Backend::Test::COLLECTIONS{users}{doug}->%*,
        password => 'qwe123',
    };
    $t->put_ok( '/admin/api/users/doug', json => $doug )
      ->status_is( 200 );
    is $Yancy::Backend::Test::COLLECTIONS{users}{doug}{password},
        Digest->new( 'SHA-1' )->add( 'qwe123' )->b64digest,
        'new password is digested correctly'
};

subtest 'unauthenticated user cannot admin' => sub {

};

subtest 'user can login' => sub {

};

subtest 'logged-in user can do things' => sub {

};

done_testing;
