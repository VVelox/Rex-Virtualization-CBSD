#
# (c) Zane C. Bowers-Hadley <vvelox@vvelox.net>
#

package Rex::Virtualization::CBSD::start;

use strict;
use warnings;

our $VERSION = '0.0.1'; # VERSION

use Rex::Logger;
use Rex::Helper::Run;
use Term::ANSIColor qw(colorstrip);

sub execute {
	my ( $class, $name ) = @_;

	if (!defined( $name ) ){
		die('No VM name defined');
	}

	Rex::Logger::debug("CBSD VM start via cbsd bstart ".$name);

	my $returned=i_run ('cbsd bstart '.$name , fail_ok => 1);
	# the output is colorized
	$returned=colorstrip($returned);
	# check for failures caused by it not existing
	if ( $returned =~ /^No\ such/ ){
		die('"'.$name.'" does not exist');
	}
	# check for failures caused by it already running
	if ( $returned =~ /^already\ running/ ){
		die('"'.$name.'" is already running');
	}
	# test after no such as that will also exit non-zero
	if ( $? != 0 ) {
		die("Error running 'cbsd bstart ".$name."'");
	}

	return 1;
}

1;
