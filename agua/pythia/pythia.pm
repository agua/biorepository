package pythia;
use Moose::Role;
use Method::Signatures::Simple;

method doInstall ($installdir, $version) {
    $self->logDebug("version", $version);
    $self->logDebug("installdir", $installdir);
    $version = $self->version() if not defined $version;
    
	#### SET FILE INFO URL
	$self->setFileInfoUrl($installdir, $version);
	
    return 0 if not $self->zipInstall($installdir, $version);
	
    return 0 if not $self->makeInstall($installdir, $version);

    return $version;
}

method setFileInfoUrl ($installdir, $version) {
	# CONVERT
	# http://sourceforge.net/projects/pythia/files/pythia/$versiondir/pythia-$version.tar.gz/download
	# TO
	#	http://sourceforge.net/projects/pythia/files/pythia/pythia_1_0_1/pythia-1.0.1.tar.gz/download

	$self->logDebug("installdir", $installdir);
	$self->logDebug("version", $version);

	my $versiondir = "pythia_" . $version;
	$versiondir =~ s/\./_/g;
	$self->logDebug("versiondir", $versiondir);

	#$self->logDebug("self->opsinfo", $self->opsinfo());
	my $url	=	$self->opsinfo()->url();
	$url =~ s/\$versiondir/$versiondir/g;
	$url =~ s/\$version/$version/g;
	$self->logDebug("url", $url);
	
	return $self->opsinfo()->url($url);
}

method makeInstall ($installdir, $version) {
    $self->logDebug("installdir", $installdir);
    $self->logDebug("version", $version);

	#### DEPENDENCIES
	my $arch = $self->getArch();
	$self->logDebug("arch", $arch);
	if ( $arch eq "ubuntu" ) {
		$self->runCommand("apt-get install -y swig");
		$self->runCommand("apt-get install -y python-dev");
		$self->runCommand("apt-get install -y python-numpy");
	}
	
	#### CHANGE DIR
    $self->changeDir("$installdir/$version");

	#### INSTALL
	my ($out, $err) = $self->runCommand("python setup.py install");
	$self->logDebug("out", $out);
	$self->logDebug("err", $err);
}



1;