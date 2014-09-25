package r;
use Moose::Role;
use Method::Signatures::Simple;

method doInstall ($installdir, $version) {
	$self->logDebug("version", $version);
	$self->logDebug("installdir", $installdir);

	$self->zipInstall($installdir, $version);
	$self->configInstall($installdir, $version);
	
	$self->confirmInstall($installdir, $version);
	
	return 1;
}

method configInstall ($installdir, $version) {
	$self->logDebug("version", $version);
	$self->logDebug("installdir", $installdir);
	
	#### CHANGE DIR
    $self->changeDir("$installdir/$version");
	
	#### MAKE
	$self->runCommand("./configure --with-x=no");
	$self->runCommand("make");
	
	return 1;
}


1;
