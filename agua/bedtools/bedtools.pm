package bedtools;
use Moose::Role;
use Method::Signatures::Simple;

method doInstall ($installdir, $version) {
	$self->logDebug("version", $version);
	$self->logDebug("installdir", $installdir);
	$version 	= 	$self->version() if not defined $version;
	$version 	= 	$self->zipInstall($installdir, $version);
	$version	=	$self->configInstall($installdir, $version);

	$self->confirmInstall($installdir, $version);
	
	return $version;
}

method configInstall ($installdir, $version) {
	$self->logDebug("version", $version);
	$self->logDebug("installdir", $installdir);
	
	#### CHANGE DIR
    $self->changeDir("$installdir/$version");
	
	#### MAKE
	$self->runCommand("make");
	
	return $version;
}

1;