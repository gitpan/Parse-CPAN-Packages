package Parse::CPAN::Packages::Distribution;
use strict;
use base qw( Class::Accessor::Chained );
 __PACKAGE__->mk_accessors(qw( prefix dist version maturity filename 
  cpanid distvname ));
use vars qw($VERSION);
$VERSION = '2.12';

sub new {
  my $class    = shift;

  my $self = {};
  bless $self, $class;

  return $self;
}

1;
