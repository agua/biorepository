package bcftools;
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

	#### DOWNLOAD DEPENDENCY
	$self->runCommand("git clone git\@github.com:samtools/htslib");

	#### CHANGE DIR
    $self->changeDir("$installdir/$version/htslib");

	#### SYNC VERSION - htslib
	$self->runCommand("git checkout $version");
	
	#### CHANGE DIR
    $self->changeDir("$installdir/$version");

	#### SYNC VERSION - bcftools
	$self->runCommand("git checkout $version");

	$self->runCommand("make HTSDIR=htslib");

	#### INSTALL
	$self->makeInstall($installdir, $version);

	return 1;
}


1;