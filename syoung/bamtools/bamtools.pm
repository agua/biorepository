package bamtools;
use Moose::Role;
use Method::Signatures::Simple;

method doInstall ($installdir, $version) {
	$self->logDebug("version", $version);
	$self->logDebug("installdir", $installdir);

	$self->gitInstall($installdir, $version);

	$self->makeInstall($installdir, $version);	

	$self->confirmInstall($installdir, $version);
	
	return 1;
}

method makeInstall ($installdir, $version) {
	$self->logDebug("version", $version);
	$self->logDebug("installdir", $installdir);
	
	#### CREATE BUILD DIR
	my $builddir	=	"$installdir/$version/build";
	`mkdir -p $builddir` if not -d $builddir;
	
	#### CHANGE DIR
    $self->changeDir($builddir);
	
	#### MAKE
	$self->runCommand("cmake ..");

	$self->runCommand("make");

	return 1;
}


1;
