package go;
use Moose::Role;
use Method::Signatures::Simple;

method doInstall ($installdir, $version) {
    $self->logDebug("version", $version);
    $self->logDebug("installdir", $installdir);
    $version = $self->version() if not defined $version;
   
    return 0 if not $self->zipInstall($installdir, $version);

    #return 0 if not $self->makeInstall($installdir, $version);
   
    return $version;
}

method makeInstall ($installdir, $version) {
	$self->logDebug("version", $version);
	$self->logDebug("version", $version);

    #### INSTALL DEPENDENCIES
    $self->runCommand("apt-get install -y bison libbison-dev linux-image-3.13.0-74-generic");
    $self->runCommand("apt-get install -y gawk");
    $self->runCommand("apt-get install -y libc6-dev");
    $self->runCommand("apt-get install -y mercurial");
    
	#### CHANGE DIR
    $self->changeDir("$installdir/$version/src");
	    
	#### MAKE
    $self->runCommand("./all.bash");

	$self->runCommand("make");

	return 1;
}


1;
