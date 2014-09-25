package pip;
use Moose::Role;
use Method::Signatures::Simple;

method doInstall ($installdir, $version) {
	$self->logDebug("version", $version);
	$self->logDebug("installdir", $installdir);
	$version = $self->version() if not defined $version;

	$version = $self->zipInstall($installdir, $version);

	$self->confirmInstall($installdir, $version);

	return $version;
}

1;