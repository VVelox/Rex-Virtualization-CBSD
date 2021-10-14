#!perl
use 5.006;
use strict;
use warnings;
use Test::More;

plan tests => 1;

BEGIN {
    use_ok( 'Rex::Virtualization::CBSD::restart' ) || print "Bail out!\n";
}

diag( "Testing Rex::Virtualization::CBSD::restart $Rex::Virtualization::CBSD::restart::VERSION, Perl $], $^X" );
