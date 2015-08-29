package bedtools2;
use Moose::Role;
use Method::Signatures::Simple;

method doInstall ($installdir, $version) {
	$self->logDebug("version", $version);
	$self->logDebug("installdir", $installdir);
	$version 	= 	$self->version() if not defined $version;
	
	print "Failed to download version: $version\n" and exit if not $self->zipInstall($installdir, $version);
	
	return $version;
}

1;
