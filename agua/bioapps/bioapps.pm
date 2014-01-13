package bioapps;
use Moose::Role;
use Method::Signatures::Simple;

has 'installdir'=> ( isa => 'Str|Undef', is => 'rw', required	=>	0	);
has 'version'	=> ( isa => 'Str|Undef', is => 'rw', required	=>	0	);
has 'repotype'	=> ( isa => 'Str|Undef', is => 'rw', default	=> 'github'	);
has 'mountpoint'=> ( isa => 'Str|Undef', is => 'rw', required	=>	0	);

####///}}}}

method preInstall {
	$self->logDebug("");

	#### SET DEFAULTS
    $self->owner("agua") if not defined $self->owner();
    $self->login("agua") if not defined $self->login();
	$self->repository("agua") if not defined $self->repository();
	$self->package("bioapps") if not defined $self->package();
	$self->repotype("github") if not defined $self->repotype();
	$self->privacy("public");

	#### SET DATABASE HANDLE
	$self->setDbObject() if not defined $self->db();

	#### CHECK INPUTS
	$self->checkInputs();
	
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
	my 	$privacy 		= $self->privacy();
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
	$self->logDebug("privacy", $privacy);
	$self->logDebug("version", $version);
	$self->logDebug("random", $random);
}

method postInstall {
	my $username 	= 	$self->username();
	my $login 		= 	$self->login();
	my $package		=	$self->package();
	my $installdir	=	$self->installdir();
	my $opsdir		=	$self->opsdir();

	$package = $self->repository() if not defined $package;
	$self->logDebug("username", $username);
	$self->logDebug("package", $package);
	$self->logDebug("installdir", $installdir);

	#### LOAD app AND parameter TABLE ENTRIES	
	$self->loadApps($login, $package, $installdir, $opsdir);

	#### LOAD feature TABLE ENTRIES
	$self->loadFeatures ($installdir);
	
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
	
	#### LOAD SNAPSHOT IF NOT ALREADY LOADED
	my $snapshotid = $self->loadSnapshot($name, $id, $description);

	#### SET MOUNTPOINT	
	my $mountpoint = $self->mountpoint() || "/bioapps-$snapshotid";

	##### SET CONFIG FILE
	my $configfile = "$opsdir/conf/bioapps.conf";
	$self->logDebug("configfile", $configfile);
	return if not -f $configfile;
	
	#### LOAD CONFIG
	$self->loadConfig($configfile, $mountpoint, $installdir);
	
	return;
}

method loadApps ($login, $package, $installdir, $opsdir) {
#### LOAD app AND parameter TABLE ENTRIES
	$self->logDebug("login", $login);
	$self->logDebug("package", $package);

	my $appdir = "$opsdir/apps";
	$self->logDebug("appdir", $appdir);

	$self->updateReport(["Loading apps in appdir: $appdir"]);

	$self->logDebug("Doing loadAppFiles");
	$self->loadAppFiles($login, $package, $installdir, $appdir);
	$self->logDebug("Completed loadAppFiles");

	$self->updateReport(["Completed loading apps"]);
}

method loadFeatures ($installdir) {
#### LOAD feature TABLE ENTRIES

	my $featurefile = "$installdir/conf/tsv/feature.tsv";

	$self->updateReport(["Loading JBrowse features in featurefile: $featurefile"]);

	my $newfeaturefile = $featurefile . ".new";
	my $loadfeaturefile = $featurefile . ".load";
	`cp $featurefile $newfeaturefile`;
	my $datadir = $self->conf()->getKey("agua", "DATADIR");
	$datadir =~ s/\//\\\//g;
	my $command = "sed 's/<DATADIR>/$datadir/g' $newfeaturefile > $loadfeaturefile";
	$self->logDebug("command", $command);
	`$command`;

	#### LOAD FEATURES
	$self->logDebug("Doing loadTsvFile");
	$self->loadTsvFile("feature", $loadfeaturefile);

	$self->updateReport(["Completed loading features"]);
}

method getVolume ($snapshot) {
	my $query = qq{SELECT * FROM volume WHERE snapshot='$snapshot'};
	return $self->db()->queryhash($query);
}

1;