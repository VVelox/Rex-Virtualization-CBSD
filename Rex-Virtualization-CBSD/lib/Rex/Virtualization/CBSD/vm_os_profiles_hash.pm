#
# (c) Zane C. Bowers-Hadley <vvelox@vvelox.net>
#

package Rex::Virtualization::CBSD::vm_os_profiles_hash;

use strict;
use warnings;

our $VERSION = '0.0.1';    # VERSION

use Rex::Logger;
use Rex::Helper::Run;
use Term::ANSIColor qw(colorstrip);
use Rex::Commands::User;
use Rex::Commands::Fs;

sub execute {
	my ($class, $wanted_os) = @_;

	Rex::Logger::debug("Getting a list of VM OS types for CBSD ");

	# get where CBSD is installed to
	my %cbsd;
	eval { %cbsd = get_user('cbsd'); } or do {
		my $error = $@ || 'Unknown failure';
		die( "get_user('cbsd') died with... " . $error );
	};

	my $cbsd_etc_defaults_dir = $cbsd{home} . '/etc/defaults/';

	# get the VM OS/profile config lists
	my @vm_configs = grep { /^vm\-/ } list_files($cbsd_etc_defaults_dir);

	# find the requested ones
	my %profiles;
	foreach my $config (@vm_configs) {
		my ( $vm, $os, $profile ) = split( /\-/, $config, 3 );
		$profile=~s/\.conf$//;
		if (!defined( $profiles{$os} )) {
			$profiles{$os}={ $profile => 1 };
		}else {
			$profiles{$os}{$profile}=1
		}
	}

	return %profiles;
}

1;
