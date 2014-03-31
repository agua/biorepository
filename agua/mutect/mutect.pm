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

	$self->downloadInstall($installdir, $version);
	
	$self->confirmInstall($installdir, $version);

	return 1;
}

method confirmInstall ($installdir, $version) {
	$self->logDebug("version", $version);
	$self->logDebug("installdir", $installdir);
	
	my $opsdir		=	$self->opsdir();
	$self->logDebug("opsdir", $opsdir);
	my $file		=	"$opsdir/t/$version/output.txt";
	$self->logDebug("file", $file);
	return 1 if not -f $file;

	my $lines		=	$self->fileLines($file);
	shift @$lines;
	shift @$lines;

	my $command	=	"./muTect.jar -h";
	$self->logDebug("command", $command);
	
	#### GET DEPENDENCY VERSIONS
	my $dependencies	=	$self->opsinfo()->dependencies();
	$self->logDebug("dependencies", $dependencies);
	my $javaversion	=	$$dependencies[0]->{version};

	my $basedir		=	$self->getBaseDir($installdir);
	my $executor	=	"$basedir/java/$javaversion/bin/java -jar";
	$self->logDebug("executor", $executor);

	$command 	=	"cd $installdir/$version; $executor $command";
	$self->logDebug("FINAL command", $command);

	my ($output, $error)	=	$self->runCommand($command);
	$output		=	$error if not defined $output or $output eq "";
	my $actual;
	@$actual	=	split "\n", $output;
	#print "actual: ", join "\n", @$actual, "\n";

	for ( my $i = 0; $i < @$lines; $i++ ) {
		my $got	=	$$actual[$i] || ""; #### EXTRA EMPTY LINES
		my $expected	=	$$lines[$i];
		next if $expected =~ /^SKIP/;
		
		if ( $got ne $expected ) {
			$self->logDebug("FAILED TO INSTALL. Mismatch between expected and actual output!\nExpected:\n$expected\n\nGot:\n$got\n\n");
			return 0;
		}
	}
	$self->logDebug("**** CONFIRMED INSTALLATION ****");
	
	return 1;
}


1;