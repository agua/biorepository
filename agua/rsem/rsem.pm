package rsem;
use Moose::Role;
use Method::Signatures::Simple;

method doInstall ($installdir, $version) {
	$self->logDebug("version", $version);
	$self->logDebug("installdir", $installdir);

	$self->zipInstall($installdir, $version);
	$self->makeInstall($installdir, $version);
	
	$self->confirmInstall($installdir, $version);
	
	return 1;
}

method makeInstall ($installdir, $version) {
	$self->logDebug("version", $version);
	$self->logDebug("installdir", $installdir);
	
	#### CHANGE DIR
    $self->changeDir("$installdir/$version");
	
	#### MAKE
	$self->runCommand("make");
	$self->runCommand("make ebseq");
	
	return 1;
}


1;
