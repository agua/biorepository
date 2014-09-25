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

	$self->gitInstall($installdir, $version);

	$self->antInstall($installdir, $version);

	$self->confirmInstall($installdir, $version);

	return $version;
}

method antInstall ($installdir, $version) {
	$self->logDebug("installdir", $installdir);
	$self->logDebug("version", $version);

	my $ant	=	"/usr/bin/ant";
	$self->installAnt() if not -f $ant;	

	my $dependencies	=	$self->opsinfo()->dependencies();
	$self->logDebug("dependencies", $dependencies);
	my $javaversion	=	$$dependencies[0]->{version};
	my $gatkversion	=	$$dependencies[1]->{version};

	my ($basedir) 	= 	$installdir	=~	/^(.+?)\/[^\/]+$/;
	$self->logDebug("basedir", $basedir);
	
	#### CLEAN THEN BUILD
	$self->changeDir("$installdir/$version");
	$self->runCommand("ant clean");
	my ($out, $err) = $self->runCommand("export JAVA_HOME=$basedir/java/$javaversion; ant");
	$self->logDebug("out", $out);
	$self->logDebug("err", $err);
}


1;