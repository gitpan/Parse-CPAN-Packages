#!/usr/bin/perl -w
use strict;
use lib 'lib';
use Test::More tests => 12;
use_ok("Parse::CPAN::Packages");

my $p = Parse::CPAN::Packages->new("t/02packages.details.txt");
isa_ok($p, "Parse::CPAN::Packages");

my @packages = sort map { $_->package } $p->packages;
is_deeply(\@packages, [qw(Acme::Colour Acme::ComeFrom Acme::Comment Acme::CramCode Acme::Currency)]);

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
