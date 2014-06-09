package java;
use Moose::Role;
use Method::Signatures::Simple;

method doInstall ($installdir, $version) {
	$self->logDebug("version", $version);
	$self->logDebug("installdir", $installdir);
	
	$version 	= 	$self->version() if not defined $version;

	
	my ($major, $minor)	=	$version	=~ /1\.(\d+).+?_(\d+)/;
	$self->logDebug("major", $major);
	$self->logDebug("minor", $minor);
	my $url		=	$self->opsinfo()->url();
	$self->logDebug("url", $url);
	my $insert	=	$major . "u" . $minor;
	$url	=~	s/\$version/$insert/;
	$self->opsinfo()->url($url);
	$self->logDebug("AFTER url", $url);
	
	$version 	= 	$self->zipInstall($installdir, $version);

	$self->confirmInstall($installdir, $version);
	
	return 1;
}


1;
