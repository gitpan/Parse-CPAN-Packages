use Module::Build;
use strict;

my $build = Module::Build->new(
  create_makefile_pl => 'traditional',
  license     => 'perl',
  module_name => 'Parse::CPAN::Packages',
  requires    => {
    'Class::Accessor::Chained' => 0,
    'CPAN::DistnameInfo' => 0,
    'Test::More'         => 0,
},
);
$build->create_build_script;
