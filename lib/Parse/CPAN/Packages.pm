package Parse::CPAN::Packages;
use strict;
use base qw( Class::Accessor::Chained );
 __PACKAGE__->mk_accessors(qw( filename data ));
use CPAN::DistnameInfo;
use Parse::CPAN::Packages::Package;
use vars qw($VERSION);
$VERSION = '2.12';

sub new {
  my $class    = shift;
  my $filename = shift;

  my $self = {};
  bless $self, $class;

  $filename = '02packages.details.txt' if not defined $filename;
  $self->filename($filename);

  $self->parse;
  return $self;
}

sub parse {
  my $self     = shift;
  my $filename = $self->filename;

  my $data;

  open(IN, $filename) || die "Failed to read $filename: $!";
  # skip the header
  while(my $line = <IN>) {
    last if $line eq "\n";
  }
  while(my $line = <IN>) {
    chomp $line;
    my($package, $packageversion, $prefix) = split ' ', $line;
    my $m = Parse::CPAN::Packages::Package->new;
    $m->package($package);
    $m->version($packageversion);

    my $i = CPAN::DistnameInfo->new($prefix);

    my $d = Parse::CPAN::Packages::Distribution->new;
    $d->prefix($prefix);
    $d->dist($i->dist);
    $d->version($i->version);
    $d->maturity($i->maturity);
    $d->filename($i->filename);
    $d->cpanid($i->cpanid);
    $d->distvname($i->distvname);
 
    $m->distribution($d);

    $data->{$package} = $m;
  }
  close(IN);

  $self->data($data);
}

sub package {
  my $self    = shift;
  my $package = shift;
  return $self->data->{$package};
}

sub packages {
  my $self = shift;
  return values %{$self->data};
}

1;

__END__

=head1 NAME

Parse::CPAN::Packages - Parse 02packages.details.txt.gz

=head1 SYNOPSIS

  use Parse::CPAN::Packages;
  
  # must have downloading and un-gzip-ed
  my $p = Parse::CPAN::Packages->new("02packages.details.txt");

  my $m = $p->package("Acme::Colour");
  # $m is a Parse::CPAN::Packages::Package object
  print $m->package, "\n";    # Acme::Colour
  print $m->version, "\n";   # 1.00

  my $d = $p->distribution;
  # $d is a Parse::CPAN::Packages::Package object
  print $d->prefix, "\n";    # L/LB/LBROCARD/Acme-Colour-1.00.tar.gz
  print $d->dist, "\n";      # Acme-Colour
  print $d->version, "\n";   # 1.00
  print $d->maturity, "\n";  # released
  print $d->filename, "\n";  # Acme-Colour-1.00.tar.gz
  print $d->cpanid, "\n";    # LBROCARD
  print $d->distvname, "\n"; # Acme-Colour-1.00

  my @packages = $p->packages;
  # all the package objects

=head1 DESCRIPTION

The Comprehensive Perl Archive Network (CPAN) is a very useful
collection of Perl code. It has several indices of the files that it
hosts, including a file named "02packages.details.txt.gz" in the
"modules" directory. This file contains lots of useful information and
this module provides a simple interface to the data contained within.

Note that this module does not concern itself with downloading or
unpacking this file. You should do this yourself.

The constructor takes the path to the 02packages.details.txt file. It
defaults to loading the file from the current directory.

In a future release L<Parse::CPAN::Packages::Package> and
L<Parse::CPAN::Packages::Distribution> might have more information.

=head1 AUTHOR

Leon Brocard <acme@astray.com>

=head1 COPYRIGHT

Copyright (C) 2004, Leon Brocard

This module is free software; you can redistribute it or modify it under
the same terms as Perl itself.
