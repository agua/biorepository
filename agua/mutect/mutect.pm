package mutect;
use Moose::Role;
use Method::Signatures::Simple;

has 'installdir'=> ( isa => 'Str|Undef', is => 'rw', required	=>	0	);
has 'version'	=> ( isa => 'Str|Undef', is => 'rw', required	=>	0	);
has 'repotype'	=> ( isa => 'Str|Undef', is => 'rw', default	=> 'github'	);
has 'mountpoint'=> ( isa => 'Str|Undef', is => 'rw', required	=>	0	);

####///}}}}

method preInstall {
	$self->logDebug("");

	#### CHECK INPUTS
	$self->checkInputs();
	
	$self->updateReport(["Completed preInstall"]);

	$self->logDebug("self->opsinfo()->login()", $self->opsinfo()->login());
	$self->login($self->opsinfo()->login()) if not defined $self->login() or $self->login() eq "";
	
	return;
}

method doInstall ($installdir, $version) {
	$self->logDebug("version", $version);
	$self->logDebug("installdir", $installdir);

	$self->gitInstall($installdir, $version);

	$self->antInstall("$installdir/$version", $version);

	$self->confirmInstall($installdir, $version);
	
	return $version;
}

method gitInstall ($installdir, $version) {
	$self->logDebug("version", $version);
	$self->logDebug("installdir", $installdir);

	#### RESOURCES
	my $dependencies	=	$self->opsinfo()->dependencies();
	$self->logDebug("dependencies", $dependencies);
	my $gatkversion	=	$$dependencies[1]->{version};
	$self->logDebug("gatkversion", $gatkversion);
	my $tempdir	=	"/tmp";
	my $basedir = "$tempdir/mutect-dist";
	my $gatkdir = "$basedir/gatk-protected";
	my $tempdistro = "$tempdir/mutect-dist-zip";
	my $mutectdir = "$basedir/mutect-src";
	my $cwd = `pwd`;
	chomp($cwd);

	#### RECREATE TEMP DISTRO
	`rm -rf $tempdistro` if -e $tempdistro;
	`mkdir -p $tempdistro`;
	
	#### RECREATE BASEDIR
	`rm -rf $basedir` if -e $basedir;
	`mkdir -p $mutectdir`;
	
	#### CLONE mutect
	system("cd $mutectdir && git clone https://github.com/broadinstitute/mutect.git") == 0 or die();
	
	#### VERIFY tag EXISTS
	my $cnt = `cd $mutectdir/mutect && git ls-remote --tags -q | grep refs/tags/$version | wc -l`;
	chomp($cnt);
	if ($cnt == 0) { die("ERROR: release tag $version does not exist!\n"); }
	
	#### RESET MUTECT TO version
	system("cd $mutectdir/mutect && git reset --hard $version") == 0 or die();
	
	#### CLONE GATK-protected
	chdir($basedir);
	system("git clone https://github.com/broadgsa/gatk-protected.git") == 0 or die();
	chdir($gatkdir);
	system("git reset --hard $gatkversion") == 0 or die();
}

method antInstall ($installdir, $version) {
	$self->logDebug("installdir", $installdir);
	$self->logDebug("version", $version);

	my $dependencies	=	$self->opsinfo()->dependencies();
	$self->logDebug("dependencies", $dependencies);
	my $javaversion	=	$$dependencies[0]->{version};
	my $gatkversion	=	$$dependencies[1]->{version};

	my ($basedir) 	= 	$installdir	=~	/^(.+?)\/[^\/]+\/[^\/]+$/;
	$self->logDebug("basedir", $basedir);
	my $gatkdir 	= 	"/tmp/mutect-dist/gatk-protected";
	
	#### CLEAN THEN BUILD
	$self->changeDir($gatkdir);
	$self->runCommand("ant clean");
	my ($out, $err) = $self->runCommand("export JAVA_HOME=$basedir/java/$javaversion && ant -Dexternal.dir=/tmp/mutect-dist/mutect-src -Dexecutable=mutect package");
	$self->logDebug("out", $out);
	$self->logDebug("err", $err);

	#### CREATE INSTALL TARGET DIR
	`mkdir -p $installdir` if not -d $installdir;
	
	#### COPY EXECUTABLE
	$self->runCommand("cp $gatkdir/dist/packages/muTect-*/muTect.jar $installdir");
}

1;