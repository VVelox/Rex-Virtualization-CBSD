#
# (c) Zane C. Bowers-Hadley <vvelox@vvelox.net>
#

package Rex::Virtualization::CBSD::stop;

use strict;
use warnings;

our $VERSION = '0.0.1';    # VERSION

use Rex::Logger;
use Rex::Helper::Run;
use Term::ANSIColor qw(colorstrip);

sub execute {
	my ( $class, $name, %opts ) = @_;

	# make sure we have a
	if ( !defined($name) ) {
		die('No VM name defined');
	}

	my $command='cbsd bset jname='.$name;

	Rex::Logger::debug( "CBSD VM stop via ".$command );

	
	
	my $returned = i_run( $command, fail_ok => 1 );

	# the output is colorized
	$returned = colorstrip($returned);

	# check for failures caused by it not existing
	if ( $returned =~ /^No\ such/ ) {
		die( '"' . $name . '" does not exist' );
	}

	# test after no such as that will also exit non-zero
	if ( $? != 0 ) {
		die( "Error running 'cbsd bstop " . $name . "'" );
	}

	# this is warning message will be thrown if stop fails.... does not return 0 though
	if ( $returned =~ /unable\ to\ determine\ bhyve\ pid/ ) {
		die( "Either already stopped or other issue determining bhyve PID for '" . $name . "'" );
	}

	return 1;
}

1;
