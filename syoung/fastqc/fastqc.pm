package fastqc;
use Moose::Role;
use Method::Signatures::Simple;

method doInstall ($installdir, $version) {
	$self->logDebug("version", $version);
	$self->logDebug("installdir", $installdir);
	$version = $self->version() if not defined $version;

	$self->zipInstall($installdir, $version);

	$self->setPermissions($installdir, $version);
	
	$self->confirmInstall($installdir, $version);
	
	return $version;
}

method setPermissions ($installdir, $version) {
	my $opsdir		=	$self->opsdir();
	$self->logDebug("opsdir", $opsdir);
	my $permfile	=	"$opsdir/permissions.txt";

	$self->logDebug("-f permfile: $permfile", -f $permfile);

	return if not -f $permfile;
	
	my $lines		=	$self->getLines($permfile);
	$self->logDebug("lines", $lines);
	foreach my $line ( @$lines ) {
		next if $line =~ /^#/;
		next if $line =~ /^\s*$/;
		
		my ($file, $permission)	=	$line	=~ /^(\S+)\s+(\S+)/;
		$self->logDebug("file", $file);
		$self->logDebug("permission", $permission);
		
		`chmod $permission $installdir/$version/$file`;
	}	
}

1;