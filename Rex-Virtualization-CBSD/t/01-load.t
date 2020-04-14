#!perl
use 5.006;
use strict;
use warnings;
use Test::More;

plan tests => 1;

BEGIN {
    use_ok( 'Rex::Virtualization::CBSD::list' ) || print "Bail out!\n";
}

diag( "Testing Rex::Virtualization::CBSD::list $Rex::Virtualization::CBSD::list::VERSION, Perl $], $^X" );
