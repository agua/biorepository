package terraform;
use Moose::Role;
use Method::Signatures::Simple;

method doInstall ($installdir, $version) {
    $self->logDebug("version", $version);
    $self->logDebug("installdir", $installdir);
    $version = $self->version() if not defined $version;
   
    return 0 if not $self->zipInstallFiles($installdir, $version);

    #### INSTALL FROM SOURCE   
    #return 0 if not $self->gitInstall($installdir, $version);
    #return 0 if not $self->makeInstall($installdir, $version);
   
    return $version;
}

method makeInstall ($installdir, $version) {
	$self->logDebug("installdir", $installdir);
	$self->logDebug("version", $version);

    my $goversion = $self->getDependencyVersion("go");
    $self->logDebug("goversion", $goversion);

	#### CHANGE DIR
    $self->changeDir("$installdir/$version");
	
	#### MAKE
	$self->runCommand("export GOROOT=$installdir/go/$goversion; export GOPATH=$installdir/go/$goversion/src; GOPATH=$installdir/go/$goversion/bin; make updatedeps");
	$self->runCommand("export GOPROOT$installdir/go/$goversion; export GOPATH=$installdir/go/$goversion/src; GOPATH=$installdir/go/$goversion/bin; make");

	return 1;
}

method getDependencyVersion ($package) {
    $self->logDebug("package", $package);
    
    my $dependencies = $self->opsinfo()->dependencies();
    $self->logDebug("dependencies", $dependencies);

    foreach my $dependency ( @$dependencies ) {
        return $dependency->{version} if $dependency->{package} eq $package;
    }
    
    return undef;
}


1;
