package Parse::CPAN::Packages::Distribution;
use strict;
use base qw( Class::Accessor::Chained );
__PACKAGE__->mk_accessors(qw( prefix dist version maturity filename
                              cpanid distvname packages ));
use vars qw($VERSION);
$VERSION = '2.12';

sub new {
    my $class = shift;
    my $self = $class->SUPER::new;
    $self->packages( [] );
}

sub contains {
    my $self = shift;
    return @{ $self->packages };
}

1;
