package agua;
use Moose::Role;
use Method::Signatures::Simple;

use Data::Dumper;

has 'installdir'=> ( isa => 'Str|Undef', is => 'rw', default	=>	'/agua'	);
has 'version'	=> ( isa => 'Str|Undef', is => 'rw', required	=>	0	);
has 'repo'		=> ( isa => 'Str|Undef', is => 'rw', default	=> 'github'	);
has 'conffile'	=> ( isa => 'Str|Undef', is => 'rw', required	=>	0	);
has 'tempconffile'	=> ( isa => 'Str|Undef', is => 'rw', required	=>	0	);

####///}}}}

#### PRE-INSTALL
method preInstall {
	$self->logDebug("");

	#### SET VARIABLES
    $self->owner("agua");
	$self->repository("agua");
	$self->package("agua");
	$self->repotype("github");
	$self->private(0);

	#### CHECK INPUTS
	$self->checkInputs();

	#### START LOGGING TO HTML FILE
	my  $package 		= $self->package();
	my 	$version 		= $self->version();
	my  $random 		= $self->random();
	$self->logDebug("version", $version);
	$self->logDebug("random", $random);

	#### SET HTML LOG FILE
	my $logfile = $self->setHtmlLogFile($package, $random);
	$self->logDebug("logfile", $logfile);

	#### START LOGGING TO HTML FILE
	$self->startHtmlLog($package, $version, $logfile);

	#### COPY CONF FILE
	$self->copyConf();

	#### REPORT PROGRESSS
	$self->updateReport(["Doing preInstall"]);
	my 	$aguaversion 	= $self->conf()->getKey('agua', 'VERSION');
	$self->updateReport(["Current version: $aguaversion"]);
	
	return "Completed preInstall";
}

method checkInputs {
	my 	$pwd 			= $self->pwd();
	my 	$username 		= $self->username();
	my 	$version 		= $self->version();
	my  $package 		= $self->package();
	my  $repotype 		= $self->repotype();
	my 	$owner 			= $self->owner();
	my 	$private 		= $self->private();
	my  $repository 	= $self->repository();	
	my 	$aguaversion 	= $self->conf()->getKey('agua', 'VERSION');

	$self->logError("owner not defined") and exit if not defined $owner;
	$self->logError("version not defined") and exit if not defined $version;
	$self->logError("package not defined") and exit if not defined $package;
	$self->logError("username not defined") and exit if not defined $username;
	$self->logError("repotype not defined") and exit if not defined $repotype;
	$self->logError("repository not defined") and exit if not defined $repository;
	$self->logError("aguaversion not defined") and exit if not defined $aguaversion;
	
	$self->logDebug("owner", $owner);
	$self->logDebug("package", $package);
	$self->logDebug("username", $username);
	$self->logDebug("repotype", $repotype);
	$self->logDebug("repository", $repository);
	$self->logDebug("aguaversion", $aguaversion);
	$self->logDebug("private", $private);
	$self->logDebug("version", $version);
}

method copyConf () {
	my $conffile 	=	$self->setConfFile();
	my $tempconf	=	$self->setTempConfFile();
	my $command = "cp -f $conffile $tempconf; chmod 600 $tempconf";
	$self->logDebug("command", $command);
	
	$self->runCommand($command);
}

method restoreConf {
	my $conffile 	=	$self->setConfFile();
	my $tempconf	=	$self->setTempConfFile();
	my $apacheuser	=	$self->conf()->getKey("agua", "APACHEUSER");
	my $command 	= "mv $tempconf $conffile; chown root:$apacheuser $conffile; chmod 660 $conffile";
	$self->logDebug("command", $command);

	$self->runCommand($command);
}

method setConfFile {
	return $self->conffile() if defined $self->conffile();
	my $installdir 	= 	$self->installdir();
	my $conffile 	=	"$installdir/conf/default.conf";
	$self->conffile($conffile);
	
	return $conffile;
}

method setTempConfFile {
	return $self->tempconffile() if defined $self->tempconffile();
	my $tempconffile 	=	"/tmp/agua-default.conf";
	$self->tempconffile($tempconffile);
	
	return $tempconffile;
}

#### POST-INSTALL
method postInstall {
	$self->logDebug("");
	
	#### RESTORE CONFIG FILE
	$self->restoreConf();
	
	#### UPDATE AGUA VERSION IN CONFIG
	my $version = $self->version();
	$self->logDebug("version", $version);
	$self->conf()->setKey("agua", "VERSION", $version);

	#### RUN INSTALL TO SET PERMISSIONS, ETC.
	$self->runUpgrade();

	return "Completed postInstall";
}

method runUpgrade {
	my $installdir	=	$self->installdir();
	$installdir = "/agua" if not defined $installdir;
	$self->logDebug("installdir", $installdir);


#### DEBUG 
#### DEBUG 
#### DEBUG 
	my $permsfile = "$installdir/bin/scripts/resources/agua/permissions.txt";
	`mv $permsfile $permsfile.safe`;
	`echo "#### DEBUG EMPTY PERMISSIONS" > $permsfile`;
#### DEBUG 
#### DEBUG 
#### DEBUG 

	my $logfile = $self->logfile();
	$self->changeDir("$installdir/bin/scripts");
	my $command = qq{$installdir/bin/scripts/install.pl \\
--mode upgrade \\
--installdir $installdir \\
--logfile $logfile
};
	$self->logDebug("command", $command);

	$self->runCommand($command);
}

1;
