package blat;
use Moose::Role;
use Method::Signatures::Simple;

method doInstall ($installdir, $version) {
	$self->logDebug("version", $version);
	$self->logDebug("installdir", $installdir);

	$self->zipInstall($installdir, $version);

	$self->makeInstall($installdir, $version);
	
	$self->confirmInstall($installdir, $version);
	
	return 1;
}

method makeInstall ($installdir, $version) {
	$self->logDebug("version", $version);
	$self->logDebug("installdir", $installdir);
	
	#### CHANGE DIR
    $self->changeDir("$installdir/$version");

	#### EDIT FILE
	my $targetfile	=	"$installdir/$version/inc/common.mk";
	my $backupfile	=	"$installdir/$version/inc/common.mk.bkp";
	`mv $targetfile $backupfile` if -f $targetfile;
	my $command 	= 	"sed 's/\${HOME}\\/bin\\/\${MACHTYPE}/\\/usr\\/bin/' $backupfile > $targetfile";
	$self->logDebug("command", $command);
	`$command`;
	
	#### MAKE
	$self->runCommand("export MACHTYPE=x64_86; make");

	$self->runCommand("export MACHTYPE=x64_86; make ebseq");
	
	return 1;
}


1;
