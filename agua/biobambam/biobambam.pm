package biobambam;
use Moose::Role;
use Method::Signatures::Simple;

method doInstall ($installdir, $version) {
	$self->logDebug("version", $version);
	$self->logDebug("installdir", $installdir);

	$self->gitInstall($installdir, $version);
	$self->makeInstall($installdir, $version);	
	
	#$self->confirmInstall($installdir, $version);
	
	return 1;
}

method makeInstall ($installdir, $version) {
	$self->logDebug("version", $version);
	$self->logDebug("installdir", $installdir);
	
	my $query = "SELECT version, installdir FROM package WHERE package='libmaus'";
	my $libmaus	=	$self->db()->queryhash($query);
	$self->logDebug("libmaus", $libmaus);
	my $libmausversion	=	$libmaus->{version};	
	my $libmausinstalldir	=	$libmaus->{installdir};	
	$self->logDebug("libmausversion", $libmausversion);
	$self->logDebug("libmausinstalldir", $libmausinstalldir);

	#### CHANGE DIR
    $self->changeDir("$installdir/$version");
	
	#### MAKE
	$self->runCommand("autoreconf -i -f");
	$self->runCommand("./configure --with-libmaus=$libmausinstalldir/$libmausversion --prefix=$installdir/$version");
	$self->runCommand("make");
	
	return 1;
}


1;
