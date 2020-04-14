#!perl
use 5.006;
use strict;
use warnings;
use Test::More;

plan tests => 1;

BEGIN {
    use_ok( 'Rex::Virtualization::CBSD::stop' ) || print "Bail out!\n";
}

diag( "Testing Rex::Virtualization::CBSD::stop $Rex::Virtualization::CBSD::stop::VERSION, Perl $], $^X" );
