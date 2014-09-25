package agua;
use Moose::Role;
use Method::Signatures::Simple;

use Data::Dumper;

has 'installdir'=> ( isa => 'Str|Undef', is => 'rw', default	=>	'/agua'	);
has 'version'	=> ( isa => 'Str|Undef', is => 'rw', required	=>	0	);
has 'repo'		=> ( isa => 'Str|Undef', is => 'rw', default	=> 'github'	);
has 'confdir'	=> ( isa => 'Str|Undef', is => 'rw', required	=>	0	);
has 'tempdir'	=> ( isa => 'Str|Undef', is => 'rw', required	=>	0	);

####///}}}}

#### PRE-INSTALL
method preInstall {
	$self->logDebug("");

	#### SET VARIABLES
    $self->owner("agua") if not $self->owner();
	$self->repository("agua");
	$self->package("agua");
	$self->hubtype("github");
	$self->privacy("public");

	$self->logDebug("self->owner()", $self->owner());
	$self->logDebug("self->repository()", $self->repository());
	$self->logDebug("self->package()", $self->package());
	$self->logDebug("self->hubtype()", $self->hubtype());
	$self->logDebug("self->privacy()", $self->privacy());
	$self->logDebug("self->tempdir()", $self->tempdir());
	
	#### CHECK INPUTS
	$self->checkInputs();

	#### STORE CONF IN MEMORY
	$self->conf()->memory(1);
	$self->conf()->read();

	#### MOVE CONF FILE
	$self->moveConf();

	#### REPORT PROGRESSS
	my 	$version 	= $self->conf()->getKey('agua', 'VERSION');
	$self->logDebug("current version", $version);

	return 1;
}

#### POST-INSTALL
method postInstall ($installdir, $version) {
	$self->logDebug("");

	#### RESTORE CONFIG FILE
	$self->restoreConf();
	
	#### UPDATE CONFIG WITH NEW ENTRIES IF NOT PRESENT
	my $confdir		=	$self->setConfDir();
	my $conffile 	=	"$confdir/config.yaml";
	my $distroconfig= 	"$installdir/bin/scripts/resources/agua/conf/config.yaml";
	$self->logDebug("DOING updateConfig($distroconfig, $conffile)");
	$self->updateConfig($distroconfig, $conffile);

	#### UPDATE AGUA VERSION IN CONFIG
	$self->logDebug("version", $version);
	$self->conf()->setKey("agua", "VERSION", $version);

	return "Completed postInstall. Reload browser after 'terminalInstall' to complete installation";
}


#### UTILS
method moveConf () {
	my $confdir 	=	$self->setConfDir();
	my $tempdir		=	$self->setTempDir();
	$self->logDebug("confdir", $confdir);
	$self->logDebug("tempdir", $tempdir);

	#### CREATE TEMP DIR IF NOT EXISTS
	`mkdir $tempdir` if not -d $tempdir;
	$self->logError("Can't create tempdir", $tempdir) and exit if not -d $tempdir;
	my $chmod = "chmod 700 $tempdir";
	$self->logDebug("chmod", $chmod);
	`$chmod`;

	#### MOVE FILES FROM CONF DIR TO TEMP DIR
	my $command = "mv -f $confdir/* $tempdir";
	$self->logDebug("command", $command);	
	$self->runCommand($command);
}

method restoreConf {
	my $confdir 	=	$self->setConfDir();
	my $tempdir		=	$self->setTempDir();
	$self->logDebug("confdir", $confdir);
	$self->logDebug("tempdir", $tempdir);

	#### CREATE CONF DIR IF NOT EXISTS
	`mkdir $confdir` if not -d $confdir;
	$self->logError("Can't create confdir", $confdir) and exit if not -d $confdir;
	my $chmod = "chmod 700 $confdir";
	$self->logDebug("chmod", $chmod);
	`$chmod`;

	#### COPY FROM TEMP TO CONFDIR
	my $command 	= "cp -fr $tempdir/* $confdir";
	$self->logDebug("command", $command);

	$self->runCommand($command);
}

method setConfDir {
	return $self->confdir() if defined $self->confdir();
	my $installdir 	= 	$self->installdir();
	my $confdir 	=	"$installdir/conf";
	$self->confdir($confdir);
	
	return $confdir;
}

method setTempDir {
	return $self->tempdir() if defined $self->tempdir();
	my $tempdir = "/tempconf";
	$self->tempdir($tempdir);
	
	return $tempdir;
}

1;
