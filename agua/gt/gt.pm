package gt;
use Moose::Role;
use Method::Signatures::Simple;

method doInstall ($installdir, $version) {
    $self->logDebug("version", $version);
    $self->logDebug("installdir", $installdir);
    $version = $self->version() if not defined $version;
    
    return 0 if not $self->gitInstall($installdir, $version);

    #### GENERATE MAKEFILE
    $self->changeDir("$installdir/$version");
	my ($out, $err) = $self->runCommand("perl Makefile.PL");
	$self->logDebug("out", $out);
	$self->logDebug("err", $err);

    return 0 if not $self->makeInstall($installdir, $version);

    return $version;
}

1;