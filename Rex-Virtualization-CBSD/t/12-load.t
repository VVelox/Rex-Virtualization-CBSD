#!perl
use 5.006;
use strict;
use warnings;
use Test::More;

plan tests => 1;

BEGIN {
    use_ok( 'Rex::Virtualization::CBSD::start' ) || print "Bail out!\n";
}

diag( "Testing Rex::Virtualization::CBSD::start $Rex::Virtualization::CBSD::start::VERSION, Perl $], $^X" );
