#
# (c) Zane C. Bowers-Hadley <vvelox@vvelox.net>
#

package Rex::Virtualization::CBSD::create;

use strict;
use warnings;

our $VERSION = '0.0.1';    # VERSION

use Rex::Logger;
use Rex::Helper::Run;
use Term::ANSIColor qw(colorstrip);

sub execute {
	my ( $class, %opts ) = @_;

	#make sure we have the very minimum needed
	# also that each value is sane
	my @required_keys = ( 'name', 'vm_os_type', 'vm_os_profile' );
	foreach my $key (@required_keys) {
		if ( !defined( $opts{$key} ) ) {
			die 'Required key "' . $key . '" not defined';
		}

		# make sure it does not contain any tabs, spaces, =, \. /, ', ", or new lines.
		if ( $opts{$key} =~ /[\t\ \=\\\/\'\"\n]/ ) {
			die 'The value "'
				. $opts{$key}
				. '" for key "'
				. $key
				. '" matched /[\t\ \=\/\\\'\"\n]/, meaning it is not a valid value';
		}
	}

	# get where CBSD is installed to
	my %cbsd;
	eval { %cbsd = get_user('cbsd'); } or do {
		my $error = $@ || 'Unknown failure';
		die( "get_user('cbsd') died with... " . $error );
	};

	my $command
		= 'cbsd bcreate jname="'
		. $opts{name}
		. '" vm_os_type="'
		. $opts{vm_os_type}
		. '" vm_os_profile="'
		. $opts{vm_os_profile}.'"';

	# the variables to check for.
	my @variables=(
				   'bhyve_vnc_tcp_bind',
				   'imgsize',
				   'inter',
				   'interface2',
				   'nic_flags',
				   'nic_flags2',
				   'quiet',
				   'removejconf',
				   'runasap',
				   'vm_cpus',
				   'vm_ram',
				   'zfs_snapsrc'
				   );
	# add each found variable to the command
	foreach my $key (@variables) {
		# make sure it does not contain any tabs, spaces, =, \. /, ', ", or new lines.
		if ( $opts{$key} =~ /[\t\ \=\\\/\'\"\n]/ ) {
			die 'The value "'
				. $opts{$key}
				. '" for key "'
				. $key
				. '" matched /[\t\ \=\/\\\'\"\n]/, meaning it is not a valid value';
		}

		if (defined($opts{$key})) {
			$command=' '.$key.'="'.$opts{$key}.'"';
		}
	}

	Rex::Logger::debug("Creating a new CBSD VM via... ".$command);

	my $returned = i_run( $command, fail_ok => 1 );

	# the output is colorized
	$returned = colorstrip($returned);

	# test after no such as that will also exit non-zero
	if ( $? != 0 ) {
		die( "Error running '" . $command . "' returned... " . $returned );
	}

	return $returned;
}

1;
