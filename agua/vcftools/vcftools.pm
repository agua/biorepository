
package vcftools;
use Moose::Role;
use Method::Signatures::Simple;

method doInstall ($installdir, $version) {
    $self->logDebug("version", $version);
    $self->logDebug("installdir", $installdir);
    $version = $self->version() if not defined $version;
   
    return 0 if not $self->gitInstall($installdir, $version);
   
    return 0 if not $self->autogenInstall($installdir, $version);
   
    return $version;
}

method autogenInstall ($installdir, $version) {
	$self->logDebug("version", $version);
	$self->logDebug("version", $version);

	#### CHANGE DIR
    $self->changeDir("$installdir/$version");
	
    #### INSTALL DEPENDENCIES
    $self->runCommand("apt-get -y install autoconf autogen intltool pkg-config");
    
	#### MAKE
	$self->runCommand("./autogen.sh");
	$self->runCommand("./configure");
	$self->runCommand("make");
	#$self->runCommand("make install");
	$self->runCommand("cp src/cpp/vcftools .");

	return 1;
}


1;
