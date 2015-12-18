package picard;
use Moose::Role;
use Method::Signatures::Simple;

method doInstall ($installdir, $version) {
    $self->logDebug("installdir", $installdir);
    $self->logDebug("version", $version);
    $version = $self->version() if not defined $version;
   
    return 0 if not $self->gitInstall($installdir, $version);
   
    return 0 if not $self->buildInstall($installdir, $version);
   
	$self->confirmInstall($installdir, $version);

    return $version;
}

method buildInstall ($installdir, $version) {
    $self->logDebug("installdir", $installdir);
    $self->logDebug("version", $version);

	#### CHANGE DIR
    $self->changeDir("$installdir/$version");

	#### DOWNLOAD htsjdk
	$self->runCommand("git clone https://github.com/samtools/htsjdk");

	#### INSTALL ant
	$self->runCommand("apt-get install -y ant");
	
	#### BUILD
	$self->runCommand("ant");
}


1;