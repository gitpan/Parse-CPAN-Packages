use Module::Build;
use strict;

my $build = Module::Build->new(
  create_makefile_pl => 'traditional',
  license     => 'perl',
  module_name => 'Parse::CPAN::Packages',
  requires    => {
    'Class::Accessor::Fast' => 0,
    'CPAN::DistnameInfo' => 0,
    'IO::Zlib'           => 0,
    'Test::More'         => 0,
    'Sort::Versions'     => 0,
},
);
$build->create_build_script;
