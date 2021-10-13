package Rex::Virtualization::CBSD;

use 5.006;
use strict;
use warnings;

use Rex::Virtualization::Base;
use base qw(Rex::Virtualization::Base);

=head1 NAME

Rex::Virtualization::CBSD - CBSD virtualization modulem for bhyve

=head1 VERSION

Version 0.0.1

=cut

our $VERSION = '0.0.1';

=head1 SYNOPSIS

    use Rex::Commands::Virtualization;

    set virtualization => "CBSD";
    
    use Data::Dumper;

=cut

sub new {
	my $that  = shift;
	my $proto = ref($that) || $that;
	my $self  = {@_};

	bless( $self, $proto );

	return $self;
}

=head1 Methods

=head2 cbsd_base_dir

This returns the CBSD base dir that the install is stored in.

No arguments are taken.

This will die upon error.

    my $cbsd_base_dir=vm 'cbsd_base_dir'

=head2 disk_list

This returns a list of disks setup for use with Bhyve in CBSD via parsing
the output of the command below.

    cbsd bhyve-dsk-list display=jname,dsk_controller,dsk_path,dsk_size,dsk_sectorsize,bootable,dsk_zfs_guid header=0

This returned data is a array of hashes.

The keys are as below.

    vm - The name of the VM in question.
    
    controller - Controller type configured for this.
    
    path - The path to the disk.
    
    size - Size of the disk in question.
    
    sectorsize - size of the sectors in question.
    
    bootable - If it is bootable. true/false
    
    zfs_guid - ZFS GUID of the disk.

This dies upon failure.

    my @disks
    eval{
        @disks=vm 'disk_list';
    } or do {
        my $error = $@ || 'Unknown failure';
        warn('Failed to the disk list... '.$error);
    }
    
    print Dumper(\@disks);

=head2 freejname

Gets the next available VM name.

One argument is required and that is the base VM to use.

The optional argument 'lease_time' may be used to specify the number
of seconds a lease for the VM name should last. The default is 30.

    vm 'freejname' => 'foo';
    
    # the same thing, but with a 60 second lease time
    vm 'freejname' => 'foo', lease_time => '60';

=head2 info

This fetches the available configuration information for a VM via
the command below.

    cbsd bget jname=$vm

The returned value is a flat hash of key value pairs.

    my %vm_info
    eval{
        %vm_info=vm 'info' => 'foo';
    } or do {
        my $error = $@ || 'Unknown failure';
        warn('Failed to get settings for the VM... '.$error);
    }
    
    foreach my $vm_info_key (@{keys(%vm_info)}){
        print $vm_info_key.": ".$vm_info{$vm_info_key}."\n";
    }

=head2 list

List available VMs.

The returned array is a hash of hashes. The first level hash is the jname.

    nodename - The node name that this is set to run on.
    
    vm - Name of the VM.
    
    jid - Jail ID/process ID of the VM if running. IF '0' it is not running.
    
    vm_ram - Max RAM for the VM.
    
    vm_curmem - Current RAM in use by the VM.
    
    vm_cpus - Number of virtual CPUs.
    
    pcpu - Current CPU usage.
    
    vm_os_type - OS type for the VM.
    
    ip4_addr - Expected IPv4 address for the VM.
    
    status - Current status of the VM.
    
    vnc - VNC address and port for the VM.
    
    path - Path to where the VM is stored.

This dies upon failure.

    my %vm_list;
    eval{
        %vm_list=vm 'list';
    } or do {
        my $error = $@ || 'Unknown failure';
        warn('Failed to list the VM... '.$error);
    }
    
    foreach my $vm_name (@{keys( %vm_list )}){
        print
            "---------------------------\n".
            'VM: '.$vm_name."\n".
            "---------------------------\n".
            'jid: '.$vm_list{$vm_name}{jid}."\n".
            'vm_ram: '.$vm_list{$vm_name}{vm_ram}."\n".
            'vm_curmem: '.$vm_list{$vm_name}{vm_curmem}."\n".
            'vm_cpus: '.$vm_list{$vm_name}{vm_cpus}."\n".
            'vm_ram: '.$vm_list{$vm_name}{pcpu}."\n".
            'vm_os_type: '.$vm_list{$vm_name}{vm_os_type}."\n".
            'ip4_addr: '.$vm_list{$vm_name}{ip4_addr}."\n".
            'status: '.$vm_list{$vm_name}{status}."\n".
            'vnc: '.$vm_list{$vm_name}{vnc}."\n".
            'path: '.$vm_list{$vm_name}{path}."\n".
            "\n"
    }

=head2 nic_list

List configured NICs.

This returned data is a array of hashes.

The keys are as below.

    vm - The name of the VM in question.
    
    driver - The driver in use. As of currently either vtnet or e1000.
    
    type - Not currently used.
    
    parent - Either the name of the parent NIC, example 'bridge1', or set to 'auto'.
    
    hwaddr - The MAC address for the NIC.
    
    address - Address of the NIC. '0' if not configured.
    
    mtu - The MTU of NIC. '0' if default.
    
    persistent - 0/1 - 1 mean persistent nic (no managed by CBSD)
    
    ratelimit - Rate limit for the interface. '0' is the default.
                {tx}/{rx} (outgoing/incoming limit), {rxtx} - shared(rx+tx) limit, one value

This dies upon failure.

    my @nics
    eval{
        @nics=vm nic_list;
    } or do {
        my $error = $@ || 'Unknown failure';
        warn('Failed to the NIC list... '.$error);
    }
    
    print Dumper(\@nics);

=head2 pause

This pauses a VM in question. The following modes are available. If no
more is specified, audo is used.

    auto - (by default) triggering - e.g, if vm active then pause
    on - pause, stop
    off - unpause, continue

The command called is as below.

    cbsd bpause $vm mode=$mode

This dies upon failure.

    eval{
        vm 'pause' => 'foo';
    } or do {
        my $error = $@ || 'Unknown failure';
        warn('Failed to pause the VM foo... '.$error);
    }

=head2 pci_list

List configured PCI devices for a VM.

This returned data is a array of hashes.

The keys are as below.

    name - Drive name of the PCI item.
    
    bus - Bus number.
    
    slot - Slot number.
    
    function - Function number.
    
    desc - Description of the device.

One argument is required and that is the name of the VM.

This dies upon failure.

    my @devices
    eval{
        @devices=vm 'nic_list' => 'foo';
    } or do {
        my $error = $@ || 'Unknown failure';
        warn('Failed to the PCI device list... '.$error);
    }
    
    print Dumper(\@devices);

=head2 remove

This removes the selected VM and remove the data. This is done via the command...

    cbsd bdestroy $vm

One argument is taken and that is the name of the VM.

This dies upon failure.

    eval{
        vm 'remove' => 'foo'
    } or do {
        my $error = $@ || 'Unknown failure';
        warn('Failed to remove the VM foo... '.$error);
    }

=head2 restart

This restarts the selected VM. This is done via the command...

    cbsd brestart $vm

One argument is taken and that is the name of the VM.

This dies upon failure.

    eval{
        vm 'restart' => 'foo'
    } or do {
        my $error = $@ || 'Unknown failure';
        warn('Failed to restart the VM foo... '.$error);
    }

=head2 set

This sets various settings for a VM via the use of...

    cbsd bset jname=$vm ...

One argument is equired and that is the VM name.

This will die upon failure. Please note the CBSD currently does
not consider non-existent variables such as 'foofoo' to be a failure
and silently ignores those.

    # set the the VM foo to boot from net with a resolution of 800x600
    vm 'set' => 'foo',
        vm_boot => 'net',
        bhyve_vnc_resolution => '800x600';

=head2 start

This starts a VM. This is done via the command...

    cbsd bstart jname=$vm

One argument is taken and that is the name of the VM. If '*' or 'vm*' then
start all VM whose names begin with 'vm', e.g. 'vm1', 'vm2'...

This dies upon failure.

    eval{
        vm 'start' => 'foo'
    } or do {
        my $error = $@ || 'Unknown failure';
        warn('Failed to start the VM foo... '.$error);
    }


=head2 stop

This stops a VM. This is done via the command below...

    cbsd bstop jname=$vm [hard_timeout=$timeout] [noacpi=$noacpi]

One argument is required and that is the name of the VM.

The following options are optional.

    hard_timeout - Wait N seconds (30 by default) before hard reset.

    noacpi - 0,1. Set to 1 to prevent ACPI signal sending, just kill.
             By default it will attempt to use ACPI to ask it to shutdown.

This dies upon failure.

    eval{
        vm 'stop' => 'foo',
            hard_timeout => 60;
    } or do {
        my $error = $@ || 'Unknown failure';
        warn('Failed to stop the VM foo... '.$error);
    }

=head2 vm_os_profiles

Get the VM OS profiles for a specified OS type.

One argument is required and that is the OS type.

The returned value is a array.

This will die upon failure.

    # list the VM OS profiles for FreeBSD
    my @profiles=vm 'vm_os_profiles' => 'freebsd';
    print Dumper @profiles;

=head2 vm_os_profiles_hash

Get the VM OS profiles for a specified OS type.

The returned value is a two level hash. The keys for the first
level are the OS types and the keys for the second level are
the OS profile names.

This will die upon failure.

    my %os_profiles=vm 'vm_os_profiles_hash';
    print Dumper %os_profiles;

    # print the OS profiles for FreeBSD
    print Dumper keys( %{ $os_profiles{freebsd} } );

=head2 vm_os_types

Get the VM OS types there are profiles for.

The returned value is a array.

This will die upon failure.

    # list the VM OS profiles for FreeBSD
    my @os_types=vm 'vm_os_profiles';
    print Dumper @os_types;

=head1 AUTHOR

Zane C. Bowers-HAdley, C<< <vvelox at vvelox.net> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-rex-virtualization-cbsd at rt.cpan.org>, or through
the web interface at L<https://rt.cpan.org/NoAuth/ReportBug.html?Queue=Rex-Virtualization-CBSD>.
I will be notified, and then you'll automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Rex::Virtualization::CBSD


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<https://rt.cpan.org/NoAuth/Bugs.html?Dist=Rex-Virtualization-CBSD>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Rex-Virtualization-CBSD>

=item * Repository

L<https://github.com/VVelox/Rex-Virtualization-CBSD>

=item * CPAN Ratings

L<https://cpanratings.perl.org/d/Rex-Virtualization-CBSD>

=item * Search CPAN

L<https://metacpan.org/release/Rex-Virtualization-CBSD>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

This software is Copyright (c) 2020 by Zane C. Bowers-HAdley.

This is free software, licensed under:

  The Artistic License 2.0 (GPL Compatible)


=cut

1;    # End of Rex::Virtualization::CBSD
