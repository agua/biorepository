package gatk;
use Moose::Role;
use Method::Signatures::Simple;

has 'installdir'=> ( isa => 'Str|Undef', is => 'rw', required	=>	0	);
has 'version'	=> ( isa => 'Str|Undef', is => 'rw', required	=>	0	);
has 'repotype'	=> ( isa => 'Str|Undef', is => 'rw', default	=> 'github'	);
has 'mountpoint'=> ( isa => 'Str|Undef', is => 'rw', required	=>	0	);

####///}}}}

method doInstall ($installdir, $version) {
	$self->logDebug("version", $version);
	$self->logDebug("installdir", $installdir);

	$self->zipInstall($installdir, $version);

	$self->makeInstallDir($installdir, $version);

	return $version;
}

method makeInstallDir ($installdir, $version) {
#### UNZIPPED RESULT: GenomeAnalysisTK.jar AND A resources FOLDER WITH TEST FILES
	my $targetdir = "$installdir/$version";
	`mkdir -p $targetdir`;
	$self->logCritical("Can't create targetdir: $targetdir") and exit if not -d $targetdir;
	my $files = [
		"GenomeAnalysisTK.jar",
		"resources"
	];
	foreach my $file ( @$files ) {
		$self->runCommand("mv $file $targetdir");
	}
}

1;