package samtools;
use Moose::Role;
use Method::Signatures::Simple;

method doInstall ($installdir, $version) {
	$self->logDebug("version", $version);
	$self->logDebug("installdir", $installdir);

	$version 	= 	$self->gitInstall($installdir, $version);
	$self->makeInstall($installdir, $version);	
	
	#$self->confirmInstall($installdir, $version);
	
	return 1;
}

method makeInstall ($installdir, $version) {
	$self->logDebug("version", $version);
	$self->logDebug("installdir", $installdir);

	my $arch	=	$self->getArch();
	$self->logDebug("arch", $arch);
	
	if ( $arch eq "ubuntu" ) {
		$self->runCommand("apt-get install -y libncurses5 libncurses5-dev")
	}
	elsif ( $arch eq "centos" ) {
		$self->runCommand("yum install -y ncurses ncurses-devel")
	}
	
	#### CHANGE DIR
    $self->changeDir("$installdir/$version");
	
	#### MAKE
	$self->runCommand("make");
	
	return 1;
}


1;
