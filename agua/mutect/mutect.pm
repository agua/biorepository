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

	$self->login($self->opsinfo()->login());
	$self->logDebug("self->opsinfo()->login()", $self->opsinfo()->login());
	
	return;
}

method doInstall ($installdir, $version) {
	$self->logDebug("version", $version);
	$self->logDebug("installdir", $installdir);

	$version 	= 	$self->gitInstall($installdir, $version);
	$self->makeInstall("$installdir/$version", $version);

	$self->confirmInstall($installdir, $version);
	
	return $version;
}


method checkInputs {
	$self->logDebug("");

	my 	$username 		= $self->username();
	my 	$version 		= $self->version();
	my  $package 		= $self->package();
	my  $repotype 		= $self->repotype();
	my 	$owner 			= $self->owner();
	my  $repository 	= $self->repository();
	my  $installdir 	= $self->installdir();

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
	$self->logDebug("version", $version);
}

1;