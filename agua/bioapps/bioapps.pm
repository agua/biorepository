package bioapps;
use Moose::Role;
use Method::Signatures::Simple;

has 'installdir'=> ( isa => 'Str|Undef', is => 'rw', required	=>	0	);
has 'version'	=> ( isa => 'Str|Undef', is => 'rw', required	=>	0	);
has 'repotype'	=> ( isa => 'Str|Undef', is => 'rw', default	=> 'github'	);

####///}}}}

method preInstall {
	$self->logDebug("");

	#### SET DEFAULTS
    $self->owner("agua") if not defined $self->owner();
	$self->repository("agua") if not defined $self->repository();
	$self->package("bioapps") if not defined $self->package();
	$self->repotype("github") if not defined $self->repotype();
	$self->private(0);

	#### CHECK INPUTS
	$self->checkInputs();
	
	my  $package 		= $self->package();
	my 	$version 		= $self->version();
	my  $random 		= $self->random();

	#### START LOGGING TO HTML FILE
	my $logfile = $self->setHtmlLogFile($package, $random);
	$self->logDebug("logfile", $logfile);
	$self->startHtmlLog($package, $version, $logfile);

	$self->updateReport(["Completed preInstall"]);

	return;
}

method checkInputs {
	$self->logDebug("");

	my 	$username 		= $self->username();
	my 	$version 		= $self->version();
	my  $package 		= $self->package();
	my  $repotype 		= $self->repotype();
	my 	$owner 			= $self->owner();
	my 	$private 		= $self->private();
	my  $repository 	= $self->repository();
	my  $installdir 	= $self->installdir();
	my  $random 		= $self->random();

	if ( not defined $package or not $package ) {
		$package = $self->repository();
		$self->package($package);
	}
	$self->logError("owner not defined") and exit if not defined $owner;
	$self->logError("package not defined") and exit if not defined $package;
	$self->logError("version not defined") and exit if not defined $version;
	$self->logError("username not defined") and exit if not defined $username;
	$self->logError("repotype not defined") and exit if not defined $repotype;
	$self->logError("repository not defined") and exit if not defined $repository;
	$self->logError("installdir not defined") and exit if not defined $installdir;
	
	$self->logDebug("owner", $owner);
	$self->logDebug("package", $package);
	$self->logDebug("username", $username);
	$self->logDebug("repotype", $repotype);
	$self->logDebug("repository", $repository);
	$self->logDebug("installdir", $installdir);
	$self->logDebug("private", $private);
	$self->logDebug("version", $version);
	$self->logDebug("random", $random);
}

method postInstall {
	my $username 	= 	$self->username();
	my $package		=	$self->package();
	my $installdir	=	$self->installdir();
	my $opsdir		=	$self->opsdir();

	$package = $self->repository() if not defined $package;
	$self->logDebug("username", $username);
	$self->logDebug("package", $package);
	$self->logDebug("installdir", $installdir);

	my $appdir = "$opsdir/apps";
	$self->logDebug("appdir", $appdir);
	
	$self->updateReport(["Loading apps in appdir: $appdir"]);
	$self->logDebug("Doing loadAppFiles");
	$self->loadAppFiles($username, $package, $installdir, $appdir);
	$self->logDebug("Completed loadAppFiles");

	$self->logDebug("self->opsinfo", $self->opsinfo());
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
	
	#### NOTE: SKIP BECAUSE LOADED BY DEFAULT
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
	
	return;
}

method getVolume ($snapshot) {
	my $query = qq{SELECT * FROM volume WHERE snapshot='$snapshot'};
	return $self->dbobject()->queryhash($query);
}

1;