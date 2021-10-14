#!perl
use 5.006;
use strict;
use warnings;
use Test::More;

plan tests => 1;

BEGIN {
    use_ok( 'Rex::Virtualization::CBSD::remove' ) || print "Bail out!\n";
}

diag( "Testing Rex::Virtualization::CBSD::remove $Rex::Virtualization::CBSD::remove::VERSION, Perl $], $^X" );
