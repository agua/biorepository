package bioapps;
use Moose::Role;
use Method::Signatures::Simple;

has 'installdir'=> ( isa => 'Str|Undef', is => 'rw', required	=>	0	);
has 'version'	=> ( isa => 'Str|Undef', is => 'rw', required	=>	0	);
has 'repotype'	=> ( isa => 'Str|Undef', is => 'rw', default	=> 'github'	);

####///}}}}

method preInstall {
	$self->logDebug("");
	$self->checkInputs();
	my $pwd = $self->pwd();
	
	my 	$username 		= $self->username();
	my 	$version 		= $self->version();
	my  $package 		= $self->package();
	my  $repotype 		= $self->repotype();
	my 	$owner 			= $self->owner();
	my 	$private 		= $self->private();
	my  $repository 	= $self->repository();
	
	my $currentversion = $self->conf()->getKey('agua', 'VERSION');
	$self->logDebug("currentversion", $currentversion);

	$self->logError("owner not defined") and exit if not defined $owner;
	$self->logError("package not defined") and exit if not defined $package;
	$self->logError("username not defined") and exit if not defined $username;
	$self->logError("repotype not defined") and exit if not defined $repotype;
	$self->logError("repository not defined") and exit if not defined $repository;
	$self->logError("currentversion not defined") and exit if not defined $currentversion;
	
	$self->logDebug("owner", $owner);
	$self->logDebug("package", $package);
	$self->logDebug("username", $username);
	$self->logDebug("repotype", $repotype);
	$self->logDebug("repository", $repository);
	$self->logDebug("currentversion", $currentversion);
	$self->logDebug("private", $private) if defined $private;
	$self->logDebug("version", $version) if defined $version;

	#### SET HTML LOGFILE
	my $logfile = $self->setLogfile($package);

	#### SEND STATUS
	print "{ status: 'installing', url: '$logfile', version: '$version' }";


$self->logDebug("DEBUG EXIT") and exit;

	#### FAKE TERMINATION
	$self->fakeTermination(5);
	$self->logDebug("AFTER fakeTermination");

	#### START LOGGING TO HTML FILE
	$self->logDebug("logfile", $logfile);
	$self->startHtmlLog($package, $version, $logfile);

	$self->updateReport(["Doing preInstall"]);
	$self->updateReport(["Current version: $currentversion"]);	
}

method postInstall {
	my $username = 	$self->username();
	my $package	=	$self->package();
	my $installdir	=	$self->installdir();
	my $opsdir		=	$self->opsdir();

	$package = $self->repository() if not defined $package;
	$self->logDebug("username", $username);
	$self->logDebug("package", $package);
	$self->logDebug("installdir", $installdir);

	my $appdir = $self->setAppDir($opsdir, $username, $package);
	$self->logDebug("appdir", $appdir);
	
	#$self->logDebug("Doing loadAppFiles");
	#$self->loadAppFiles($username, $package, $installdir, $appdir);
	#$self->logDebug("Completed loadAppFiles");

	#$self->logDebug("self->opsinfo", $self->opsinfo());
	$self->logDebug("self->opsinfo: ". $self->opsinfo());
	my $resources 	= $self->opsinfo()->resources();
	my $version = $self->opsinfo()->version();
	$self->logDebug("version", $version);
	
	#### LOAD SNAPSHOT IF NOT FOUND
	my $datavolume 	= 	$resources->{datavolume};
	my $snapshot	=	$datavolume->{id};
	my $name		=	$datavolume->{name};
	my $id			=	$datavolume->{id};
	my $description	=	$datavolume->{description};
	$self->logDebug("name", $name);
	$self->logDebug("id", $id);
	$self->logDebug("description", $description);
	
	#### LOADED BY DEFAULT
	#$self->loadSnapshot($name, $id, $description);

	#### GET DATA VOLUME MOUNT POINT
	my $volumeobject = $self->getVolume($snapshot);
	$self->logDebug("volumeobject", $volumeobject);
	my $mountpoint = $volumeobject->{mountpoint};
	$self->logDebug("mountpoint", $mountpoint);
	
	#### LOAD CONFIG FILE
	my $config = $resources->{configfile};
	my $configfile = "$mountpoint/$config";
	$self->logDebug("configfile", $configfile);
	
	return if not -f $configfile;
	$self->loadConfig($configfile, $mountpoint);
	
}

method getVolume ($snapshot) {
	my $query = qq{SELECT * FROM volume WHERE snapshot='$snapshot'};
	return $self->dbobject()->queryhash($query);
}

method  checkInputs {
	$self->logDebug("self->username", $self->username());
	$self->logDebug("self->version", $self->version());

	$self->logCritical("self->username not defined") and return 0 if not defined $self->username();
	$self->logCritical("self->owner not defined") and return 0 if not defined $self->owner();
	$self->logCritical("self->repository not defined") and return 0 if not defined $self->repository();
	$self->logCritical("self->version not defined") and return 0 if not defined $self->version();
	$self->logCritical("self->installdir not defined") and return 0 if not defined $self->installdir();
}

1;