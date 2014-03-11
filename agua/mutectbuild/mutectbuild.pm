package mutectbuild;
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

	return 1;
}

#method doInstall ($installdir, $version) {
#	$self->logDebug("version", $version);
#	$self->logDebug("installdir", $installdir);
#
#	print "Git download failed\n" and return 0 if not $self->gitInstall($installdir, $version);
#
#	print "Ant install failed\n" and return 0 if not $self->antInstall("$installdir/$version", $version);
#
#	print "Confirm install failed\n" and return 0 if not $self->confirmInstall($installdir, $version);
#	
#	return 1;
#}

method gitInstall ($installdir, $version) {
	$self->logDebug("version", $version);
	$self->logDebug("installdir", $installdir);

	#### RESOURCES
	my $resources	=	$self->opsinfo()->resources();
	$self->logDebug("resources", $resources);
	my $gatkversion	=	$resources->{"gatk-protected"}->{version};
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
	my $cnt = `cd $mutectdir/mutect; git tag | grep -r "^$version\$" | wc -l`;
	chomp($cnt);
	if ($cnt == 0) { die("ERROR: release tag $version does not exist!\n"); }
	
	#### RESET MUTECT TO version
	system("cd $mutectdir/mutect && git reset --hard $version") == 0 or die();
	
	#### CLONE GATK-protected
	chdir($basedir);
	system("git clone https://github.com/broadgsa/gatk-protected.git") == 0 or die();
	chdir($gatkdir);
	system("git reset --hard $gatkversion") == 0 or die();

	return 1;
}

method antInstall ($installdir, $version) {
	$self->logDebug("installdir", $installdir);
	$self->logDebug("version", $version);
	
	my $antfile	=	"/usr/bin/ant";
	$self->installAnt() if not -f $antfile;

	my $arch 	=	$self->getArch();
	$self->logDebug("arch", $arch);
	if ( $arch eq "centos" ) {
		$self->runCommand("yum -y install ant-nodeps");
		$self->runCommand("yum -y install ant-trax");
	}
	else {
		$self->runCommand("apt-get -y install ant-nodeps");	
		$self->runCommand("apt-get -y install ant-optional");	
	}	
	
	#### MAKE /root/.ant/lib
	my $antlib	=	"/root/.ant/lib";
	`mkdir -p $antlib` if not -d $antlib;
	
	#### DOWNLOAD ant-apache-bcel
	$self->changeDir($antlib);
	$self->runCommand("wget  http://repo1.maven.org/maven2/ant/ant-apache-bcel/1.6.5/ant-apache-bcel-1.6.5.jar");

	#### GET DEPENDENCY VERSIONS
	my $dependencies	=	$self->opsinfo()->dependencies();
	$self->logDebug("dependencies", $dependencies);
	my $javaversion	=	$$dependencies[0]->{version};
	my $gatkversion	=	$$dependencies[1]->{version};

	#### COPY BUILD gatk-protected AND COPY bcel
	my $gatkdir 	= 	"/tmp/mutect-dist/gatk-protected";
	my ($basedir) 	= 	$installdir	=~	/^(.+?)\/[^\/]+\/[^\/]+$/;
	$self->logDebug("basedir", $basedir);

	my ($out, $err);

	($out, $err) = $self->runCommand("export JAVA_HOME=$basedir/java/$javaversion && ant");
	$self->logDebug("out", $out);
	$self->logDebug("err", $err);
	$self->runCommand("cp $gatkdir/lib/bcel-*.jar $antlib");

$self->logDebug("DEBUG EXIT") and exit;

	#### COMMENT OUT XSL OUTPUT LINE IN CreatePackager.xsl
	my $source 	=	qq{<xsl:output method="xml" indent="yes"/>}; 
	my $target	=	qq{<!-- <xsl:output method="xml" indent="yes"/> -->};
	my $xslfile	=	"$gatkdir/public/packages/CreatePackager.xsl";
	$self->replaceInFile($xslfile, [$source], [$target]);

$self->logDebug("DEBUG EXIT") and exit;

	#### CLEAN THEN BUILD
	$self->changeDir($gatkdir);
	$self->runCommand("ant clean");
	($out, $err) = $self->runCommand("export JAVA_HOME=$basedir/java/$javaversion && ant -Dexternal.dir=/tmp/mutect-dist/mutect-src -Dexecutable=mutect package");
	$self->logDebug("out", $out);
	$self->logDebug("err", $err);

	#### CREATE INSTALL TARGET DIR
	`mkdir -p $installdir` if not -d $installdir;
	
	#### COPY EXECUTABLE
	$self->runCommand("cp $gatkdir/dist/packages/muTect-*/muTect.jar $installdir");

	#### COPY LICENSE
	$self->runCommand("cp $gatkdir/../mutect-src/mutect/mutect.LICENSE.txt $installdir/LICENSE");

}

1;
