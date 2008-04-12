use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'Test::Environment',
    license             => 'perl',
    dist_author         => 'Jozef Kutej <jozef@kutej.net>',
    dist_version_from   => 'lib/Test/Environment.pm',
    requires => {
        'Carp::Clan'         => 0,
        'Test::More'         => 0,
        'Test::Differences'  => 0,
        'File::Slurp'        => 0,
        'String::ShellQuote' => 0,
        'File::Basename'     => 0,
        'List::MoreUtils'    => 0,
        'DBI'                => 0,
    },
    build_requires => {
        'Test::More' => 0,
    },
    add_to_cleanup      => [ 'Test-Environment-*' ],
    create_makefile_pl  => 'traditional',
    sign                => 1,
    create_readme       => 1,
);

$builder->create_build_script();
