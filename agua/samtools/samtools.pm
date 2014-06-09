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
	
	#### CHANGE DIR
    $self->changeDir("$installdir/$version");
	
	#### MAKE
	$self->runCommand("make");
	
	return 1;
}


1;
