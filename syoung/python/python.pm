package python;
use Moose::Role;
use Method::Signatures::Simple;

method doInstall ($installdir, $version) {
	$self->logDebug("version", $version);
	$self->logDebug("installdir", $installdir);

	$self->zipInstall($installdir, $version);
	
	$self->makeAltInstall($installdir, $version);

	$self->installSetuptools($installdir, $version);
	
	$self->installPip($installdir, $version);

	$self->confirmInstall($installdir, $version);
	
	return 1;
}

method installSetuptools ($installdir, $version) {
	my $dependencies	=	$self->opsinfo()->dependencies();
	my $setupversion 	=	$$dependencies[0]->{version};
	$self->logDebug("setupversion", $setupversion);
	
	my $basedir	=	$self->getBaseDir($installdir);
	$self->logDebug("basedir", $basedir);
	
	my $setupdir	=	"$basedir/setuptools/$setupversion";
	$self->changeDir($setupdir);
	
	$self->runCommand("$installdir/$version/python setup.py install");
}

method installPip ($installdir, $version) {
	my $dependencies	=	$self->opsinfo()->dependencies();
	my $pipversion 	=	$$dependencies[1]->{version};
	$self->logDebug("pipversion", $pipversion);
	
	my $basedir	=	$self->getBaseDir($installdir);
	$self->logDebug("basedir", $basedir);
	
	my $pipdir	=	"$basedir/pip/$pipversion";
	$self->changeDir($pipdir);
	
	$self->runCommand("$installdir/$version/python setup.py install");
}

method makeAltInstall ($installdir, $version) {
	$self->logDebug("version", $version);
	$self->logDebug("installdir", $installdir);
	
	#### CHANGE DIR
    $self->changeDir("$installdir/$version");

	#### MAKE
	$self->runCommand("./configure --prefix=/usr");
	$self->runCommand("make");
	$self->runCommand("make altinstall");
	
	return 1;
}


1;
