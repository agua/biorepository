package circos;
use Moose::Role;
use Method::Signatures::Simple;

method doInstall ($installdir, $version) {
	$self->logDebug("installdir", $installdir);
	$self->logDebug("version", $version);
	$version = $self->version() if not defined $version;

	#print "Download zipfile failed\n" and exit if not $self->zipInstall($installdir, $version);
	
	$self->confirmInstall($installdir, $version);
	
	return $version;
}


method installDependencies ($opsdir, $installdir) {
	$self->logDebug("opsdir", $opsdir);
	$self->logDebug("installdir", $installdir);

	
	return;
	
	
	$self->installCpanm();

	my $arch = $self->getArch();
	$self->logDebug("arch", $arch);
	if ( $arch eq "centos" ){
		$self->runCommand("yum install perl-devel");
		$self->runCommand("yum -y install gd gd-devel");
	}
	elsif ( $arch eq "ubuntu" ) {
		$self->runCommand("apt-get -y install libperl-dev");
		$self->runCommand("apt-get -y install libgd2-xpm");
		$self->runCommand("apt-get -y libgd2-xpm-dev");
	}
	else {
		print "Architecture not supported: $arch\n" and exit;
	}

	my $modsfile	=	"$opsdir/perlmods.txt";
	$self->logDebug("modsfile", $modsfile);
	
	my $perlmods =	$self->getLines($modsfile);
	$self->logDebug("perlmods", $perlmods);
	foreach my $perlmod ( @$perlmods ) {
		next if $perlmod =~ /^#/;
		$self->runCommand("cpanm install $perlmod");
	}
}


1;