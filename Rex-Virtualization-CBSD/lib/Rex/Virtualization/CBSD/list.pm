#
# (c) Zane C. Bowers-Hadley <vvelox@vvelox.net>
#

package Rex::Virtualization::CBSD::list;

use strict;
use warnings;

our $VERSION = '1.9.0'; # VERSION

use Rex::Logger;
use Rex::Helper::Run;
use Term::ANSIColor;

sub execute {
	my ( $class, $arg1 ) = @_;

	Rex::Logger::debug("Getting CBSD VM list via display=nodename,jname,jid,vm_ram,vm_curmem,vm_cpus,pcpu,vm_os_type,ip4_addr,status,vnc,path");

	my %VMs;

	my $found=i_run('display=nodename,jname,jid,vm_ram,vm_curmem,vm_cpus,pcpu,vm_os_type,ip4_addr,status,vnc,path'),
	fail_ok => 1;
	if ( $? != 0 ) {
		die("Error running 'display=nodename,jname,jid,vm_ram,vm_curmem,vm_cpus,pcpu,vm_os_type,ip4_addr,status,vnc,path'");
	}

	$found=colorstrip($found);

	my @found_lines=split(/\n/, $found);

	foreach my $line (@found_lines){
		my %VM;
		( $VM{'node'}, $VM{'name'}, $VM{'pid'}, $VM{'ram'}, $VM{'curmem'},
			$VM{'cpus'}, $VM{'pcpu'}, $VM{'os'}, $VM{'ip4'}, $VM{'status'},
			$VM{'vnc'}, $VM{'path'} ) = split(/[\ \t]/, $line;
		$VMs{$VM{'name'}=\%VM;
	}

	return \%VMs;
}

1;