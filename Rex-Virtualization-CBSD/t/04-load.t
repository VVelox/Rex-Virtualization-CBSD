#!perl
use 5.006;
use strict;
use warnings;
use Test::More;

plan tests => 1;

BEGIN {
    use_ok( 'Rex::Virtualization::CBSD::info' ) || print "Bail out!\n";
}

diag( "Testing Rex::Virtualization::CBSD::info $Rex::Virtualization::CBSD::info::VERSION, Perl $], $^X" );
