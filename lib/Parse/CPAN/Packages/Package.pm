package Parse::CPAN::Packages::Package;
use strict;
use base qw( Class::Accessor::Chained );
 __PACKAGE__->mk_accessors(qw( package version prefix distribution ));
use Parse::CPAN::Packages::Distribution;
use vars qw($VERSION);
$VERSION = '2.12';

sub new {
  my $class    = shift;

  my $self = {};
  bless $self, $class;

  return $self;
}

1;
