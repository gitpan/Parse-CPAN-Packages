#!perl
use Module::Build;
use strict;

my $build = Module::Build->new(
    create_makefile_pl => 'traditional',
    license            => 'perl',
    module_name        => 'Parse::CPAN::Packages',
    requires           => {
        'Class::Accessor::Fast' => 0,
        'CPAN::DistnameInfo'    => 0,
        'IO::Zlib'              => 0,
        'version'               => 0,
    },
    build_requires => { 'Test::More' => 0, },
);
$build->create_build_script;
