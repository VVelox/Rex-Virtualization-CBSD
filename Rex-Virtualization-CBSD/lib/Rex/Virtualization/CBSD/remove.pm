#
# (c) Zane C. Bowers-Hadley <vvelox@vvelox.net>
#

package Rex::Virtualization::CBSD::remove;

use strict;
use warnings;

our $VERSION = '0.0.1'; # VERSION

use Rex::Logger;
use Rex::Helper::Run;
use Term::ANSIColor qw(colorstrip);

sub execute {
	my ( $class, $name ) = @_;

	if (!defined( $jname ) ){
		die('No VM name defined');
	}

	Rex::Logger::debug("CBSD VM remove via cbsd bremove ".$name);

	my %VMs;

	# note
	my $returned=i_run ('cbsd bremove '.$name , fail_ok => 1);
	if ( $? != 0 ) {
		die("Error running 'cbsd remove ".$name."'");
	}

	# the output is colorized
	$returned=colorstrip($found);

	if ( $returned =~ /^No\ such/ ){
		die('"'.$name.'" does not exist');
	}

	return 1;
}

1;