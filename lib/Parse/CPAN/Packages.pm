package Parse::CPAN::Packages;
use strict;
use base qw( Class::Accessor::Fast );
__PACKAGE__->mk_accessors(qw( details data dists latestdists ));
use CPAN::DistnameInfo;
use Parse::CPAN::Packages::Package;
use Sort::Versions;
use vars qw($VERSION);
$VERSION = '2.20';

sub new {
  my $class    = shift;
  my $filename = shift;

  my $self = { dists => {}, latestdists => {} };
  bless $self, $class;

  $filename = '02packages.details.txt' if not defined $filename;

  if ($filename =~ /Description:/) {
    $self->details($filename);
  } else {
    open(IN, $filename) || die "Failed to read $filename: $!";
    $self->details(join '', <IN>);
    close(IN);
  }

  $self->parse;
  return $self;
}

sub parse {
  my $self    = shift;
  my $details = $self->details;
  $details = (split "\n\n", $details)[1];

  my $data;
  my $latestdists;

  foreach my $line (split "\n", $details) {
    my($package, $packageversion, $prefix) = split ' ', $line;
    my $m = Parse::CPAN::Packages::Package->new;
    $m->package($package);
    $m->version($packageversion);

    my $dist = $self->dists->{ $prefix } ||= do {
      my $d = Parse::CPAN::Packages::Distribution->new;
      my $i = CPAN::DistnameInfo->new($prefix);
      $d->prefix($prefix);
      $d->dist($i->dist);
      $d->version($i->version);
      $d->maturity($i->maturity);
      $d->filename($i->filename);
      $d->cpanid($i->cpanid);
      $d->distvname($i->distvname);
      $d;
    };

    $m->distribution($dist);
    push @{ $dist->packages }, $m;

    push @{$latestdists->{$dist->dist}}, $dist if $dist->dist;

    $data->{$package} = $m;
  }
  close(IN);

  foreach my $dist (keys %$latestdists) {
    my @dists = @{$latestdists->{$dist}};
    my $highest_version = (sort { versioncmp($a->version || 0, $b->version || 0) } @dists)[-1];
    $self->latestdists->{$dist} = $highest_version;
  }

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

sub distribution {
  my $self = shift;
  my $dist = shift;
  return $self->dists->{$dist};
}

sub distributions {
  my $self = shift;
  return values %{$self->dists};
}

sub latest_distribution {
  my $self = shift;
  my $dist = shift;
  return $self->latestdists->{$dist};
}

sub latest_distributions {
  my $self = shift;
  return values %{$self->latestdists};
}

1;

__END__

=head1 NAME

Parse::CPAN::Packages - Parse 02packages.details.txt.gz

=head1 SYNOPSIS

  use Parse::CPAN::Packages;

  # must have downloaded and un-gzip-ed
  my $p = Parse::CPAN::Packages->new("02packages.details.txt");
  # either a filename as above or pass in the contents of the file
  my $p = Parse::CPAN::Packages->new($packages_details_contents);

  my $m = $p->package("Acme::Colour");
  # $m is a Parse::CPAN::Packages::Package object
  print $m->package, "\n";   # Acme::Colour
  print $m->version, "\n";   # 1.00

  my $d = $p->distribution;
  # $d is a Parse::CPAN::Packages::Distribution object
  print $d->prefix, "\n";    # L/LB/LBROCARD/Acme-Colour-1.00.tar.gz
  print $d->dist, "\n";      # Acme-Colour
  print $d->version, "\n";   # 1.00
  print $d->maturity, "\n";  # released
  print $d->filename, "\n";  # Acme-Colour-1.00.tar.gz
  print $d->cpanid, "\n";    # LBROCARD
  print $d->distvname, "\n"; # Acme-Colour-1.00

  # all the package objects
  my @packages = $p->packages;

  # all the distribution objects
  my @distributions = $p->distributions;

  # the latest distribution
  $d = $p->latest_distribution("Acme-Colour");
  is($d->prefix, "L/LB/LBROCARD/Acme-Colour-1.00.tar.gz");
  is($d->version, "1.00");

  # all the latest distributions
  my @distributions = $p->latest_distributions;

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
