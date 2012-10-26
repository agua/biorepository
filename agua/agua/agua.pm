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
	$self->updateReport(["Doing preInstall"]);
	my 	$aguaversion 	= $self->conf()->getKey('agua', 'VERSION');
	$self->updateReport(["Current version: $aguaversion"]);
	
	return "Completed preInstall";
}

#### POST-INSTALL
method postInstall {
	$self->logDebug("");

	#### RESTORE CONFIG FILE
	$self->restoreConf();
	
	#### UPDATE CONFIG WITH NEW ENTRIES IF NOT PRESENT
	my $confdir		=	$self->setConfDir();
	my $conffile 	=	"$confdir/default.conf";
	my $installdir 	= 	$self->installdir();
	my $distroconfig= 	"$installdir/bin/scripts/resources/agua/conf/default.conf";
	$self->logDebug("DOING updateConfig($distroconfig, $conffile)");
	$self->updateConfig($distroconfig, $conffile);

	#### UPDATE AGUA VERSION IN CONFIG
	my $version = $self->version();
	$self->logDebug("version", $version);
	$self->conf()->setKey("agua", "VERSION", $version);

	#### RUN INSTALL TO SET PERMISSIONS, ETC.
	my $output = $self->runUpgrade();

	return "Completed postInstall. Reload browser after 'terminalInstall' to complete installation";
}

method terminalInstall  {
	$self->logDebug("");
	
	#### KILL EXISTING FCGI PROCESSES
	#### AND RESTART FCGI
	my $commands = [
"service apache2 restart",
"killall admin.pl",
"killall sharing.pl",
"killall folders.pl",
"killall package.pl",
"killall view.pl",
"killall workflow.pl"
	];
	foreach my $command ( @$commands ) {
		$self->logDebug("command", $command);
		`$command`;
	}		

	return "Apache and FastCGI processes restarted. Reload this web page to complete installation"
}

#### UTILS
method runUpgrade {
	my $installdir	=	$self->installdir();
	$installdir = "/agua" if not defined $installdir;
	$self->logDebug("installdir", $installdir);

	$self->changeDir("$installdir/bin/scripts");
	my $command = qq{$installdir/bin/scripts/install.pl \\
--mode upgrade \\
--installdir $installdir
};
	$self->logDebug("command", $command);

	$self->runCommand($command);
	my $logfile = "/tmp/agua-install.log";
	my $output = `cat $logfile`;
	
	return "ERROR running upgrade during postInstall:\n\n$output" if $output !~ /Completed \S+\/install.pl/ms;

	return $output;
}

method checkInputs {
	my 	$pwd 			= $self->pwd();
	my 	$username 		= $self->username();
	my 	$version 		= $self->version();
	my  $package 		= $self->package();
	my  $hubtype 		= $self->hubtype();
	my 	$owner 			= $self->owner();
	my 	$privacy 		= $self->privacy();
	my  $repository 	= $self->repository();	
	my 	$aguaversion 	= $self->conf()->getKey('agua', 'VERSION');

	$self->logError("owner not defined") and exit if not defined $owner;
	$self->logError("version not defined") and exit if not defined $version;
	$self->logError("package not defined") and exit if not defined $package;
	$self->logError("username not defined") and exit if not defined $username;
	$self->logError("hubtype not defined") and exit if not defined $hubtype;
	$self->logError("repository not defined") and exit if not defined $repository;
	$self->logError("aguaversion not defined") and exit if not defined $aguaversion;
	
	$self->logDebug("owner", $owner);
	$self->logDebug("package", $package);
	$self->logDebug("username", $username);
	$self->logDebug("hubtype", $hubtype);
	$self->logDebug("repository", $repository);
	$self->logDebug("aguaversion", $aguaversion);
	$self->logDebug("privacy", $privacy);
	$self->logDebug("version", $version);
}

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
