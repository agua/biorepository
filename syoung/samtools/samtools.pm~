package cmake;
use Moose::Role;
use Method::Signatures::Simple;

method doInstall ($installdir, $version) {
	$self->logDebug("version", $version);
	$self->logDebug("installdir", $installdir);
	$version 	= 	$self->version() if not defined $version;

	$version 	= 	$self->zipInstall($installdir, $version);
	$version	=	$self->configInstall($installdir, $version);

	$self->confirmInstall($installdir, $version);
	
	return 1;
}

method configInstall ($installdir, $version) {
	$self->logDebug("version", $version);
	$self->logDebug("installdir", $installdir);
	
	#### CHANGE DIR
    $self->changeDir("$installdir/$version");
	
	#### MAKE
	$self->runCommand("./configure");
	$self->runCommand("make");
	$self->runCommand("make install");
	
	return 1;
}


1;