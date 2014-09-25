package aspera;
use Moose::Role;
use Method::Signatures::Simple;

method doInstall ($installdir, $version) {
    $self->logDebug("version", $version);
    $self->logDebug("installdir", $installdir);
    $version = $self->version() if not defined $version;
    
    return 0 if not $self->zipInstall($installdir, $version);
    
    return 0 if not $self->scriptInstall($installdir, $version);

    $self->confirmInstall($installdir, $version);
    
    return $version;
}

method scriptInstall ($installdir, $version) {
    $self->logDebug("installdir", $installdir);
    $self->logDebug("version", $version);
    
    my ($script)    =   $self->opsinfo()->url()   =~  /^.+?\/([^\/]+)\.tar\.gz/;
    $script         .=  ".sh";
    $self->logDebug("script", $script);
    $script         =~  s/\$version/$version/;
    
    #### RUN SCRIPT
    my $command     =   "$installdir/$script";
    $self->runCommand($command);
    
    #### COPY INSTALLATION TO installdir
    my $homedir     =   $ENV{'HOME'};
    $self->logDebug("homedir", $homedir);    
    my $sourcedir  =   "$homedir/.aspera/connect";
    $command        =   "cp -r $sourcedir   $installdir/$version";
    $self->runCommand($command);
    
    return 1;
}


1;