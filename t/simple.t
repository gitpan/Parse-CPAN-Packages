#!/usr/bin/perl -w
use strict;
use lib 'lib';
use Test::More tests => 23;
use_ok("Parse::CPAN::Packages");

my $p = Parse::CPAN::Packages->new("t/02packages.details.txt");
isa_ok($p, "Parse::CPAN::Packages");

my @packages = sort map { $_->package } $p->packages;
is_deeply(\@packages,
          [qw(Acme::Colour Acme::Colour::Old Acme::ComeFrom Acme::Comment Acme::CramCode Acme::Currency accessors accessors::chained accessors::classic )]);

my $m = $p->package("Acme::Colour");
is($m->package, "Acme::Colour");
is($m->version, "1.00");

my $d = $m->distribution;
is($d->prefix, "L/LB/LBROCARD/Acme-Colour-1.00.tar.gz");
is($d->dist, "Acme-Colour");
is($d->version, "1.00");
is($d->maturity, "released");
is($d->filename, "Acme-Colour-1.00.tar.gz");
is($d->cpanid, "LBROCARD");
is($d->distvname, "Acme-Colour-1.00");

is( $p->package("accessors::chained")->distribution->dist, "accessors",
    "accessors::chained lives in accessors" );

is( $p->package("accessors::classic")->distribution->dist, "accessors",
    "as does accessors::classic" );

is( $p->package("accessors::chained")->distribution,
    $p->package("accessors::classic")->distribution,
    "and they're using the same distribution object" );

my $dist = $p->distribution('S/SP/SPURKIS/accessors-0.02.tar.gz');
is( $dist->dist, 'accessors' );
is( $dist, $p->package("accessors::chained")->distribution,
    "by path match by name" );

is_deeply( [ map { $_->package } $dist->contains ],
          [ qw( accessors accessors::chained accessors::classic ) ],
           "dist contains packages" );

$d = $p->latest_distribution("Acme-Colour");
is($d->prefix, "L/LB/LBROCARD/Acme-Colour-1.00.tar.gz");
is($d->version, "1.00");

is_deeply([map { $_->prefix } $p->latest_distributions], [
  'A/AU/AUTRIJUS/Acme-ComeFrom-0.07.tar.gz',
  'X/XE/XERN/Acme-CramCode-0.01.tar.gz',
  'S/SM/SMUELLER/Acme-Currency-0.01.tar.gz',
  'L/LB/LBROCARD/Acme-Colour-1.00.tar.gz',
  'K/KA/KANE/Acme-Comment-1.02.tar.gz',
  'S/SP/SPURKIS/accessors-0.02.tar.gz'
]);

open(IN, "t/02packages.details.txt");
my $details = join '', <IN>;
close(IN);

$p = Parse::CPAN::Packages->new($details);
isa_ok($p, "Parse::CPAN::Packages");

@packages = sort map { $_->package } $p->packages;
is_deeply(\@packages,
          [qw(Acme::Colour Acme::Colour::Old Acme::ComeFrom Acme::Comment Acme::CramCode Acme::Currency accessors accessors::chained accessors::classic )]);
