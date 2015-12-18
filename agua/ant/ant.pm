package ant;
use Moose::Role;
use Method::Signatures::Simple;

method doInstall ($installdir, $version) {
    $self->logDebug("installdir", $installdir);
    $self->logDebug("version", $version);
    $version = $self->version() if not defined $version;
   
    return 0 if not $self->zipInstall($installdir, $version);

	$self->confirmInstall($installdir, $version);

    return $version;
}

1;