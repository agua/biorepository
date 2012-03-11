package biorepository;
use Moose::Role;
use Method::Signatures::Simple;

use Data::Dumper;
use Agua::Package;

has 'sessionId'	=> ( isa => 'Str|Undef', is => 'rw', required	=>	0	);
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
	$self->repository("biorepository");
	$self->package("biorepository");
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

	#### REPORT PROGRESSS
	$self->updateReport(["Doing preInstall"]);
	
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
#### POST-INSTALL
method postInstall {
	$self->logDebug("");
	
	#### RUN INSTALL TO SET PERMISSIONS, ETC.
	$self->logDebug("Doing loadProjects()");
	$self->loadProjects();

	return "Completed postInstall";
}

method loadProjects {
	my $installdir  =   $self->conf()->getKey("biorepository", "INSTALLDIR");
	my $basedir 	=	$self->conf()->getKey("agua", "INSTALLDIR");
	$self->logDebug("installdir", $installdir);
	$self->logDebug("basedir", $basedir);

	#### SET OPSDIR FOR APPDIR AND TO RETRIEVE DB ENTRY
	my $opsdir = "$basedir/repos/public/agua/biorepository";
	$self->logDebug("opsdir", $opsdir);
	
	### SET WORKFLOW DIR
	my $workflowdir = 	$self->setWorkflowDir($opsdir, "agua");
	$self->logDebug("workflowdir", $workflowdir);


#my $message = "Sync agua workflows: loadProjects";
#$self->_syncWorkflows($type, $message);

	my $username = $self->username();
	$self->logDebug("username", $username);
	my $sessionId = $self->sessionId();
	$self->logDebug("sessionId", $sessionId);

	my $loader = Agua::Package->new({
		logfile		=>	$self->logfile(),
		SHOWLOG		=>	$self->SHOWLOG(),
		PRINTLOG	=>	$self->PRINTLOG(),
		
		username	=>	$self->username(),
		sessionId	=>	$self->sessionId(),
		installdir	=>	$installdir,
			
		opsdir		=>	$opsdir,
		workflowdir	=>	$workflowdir,
		conf		=>	$self->conf()
	});
	
	#### SET agua AS USERNAME AND OWNER
	$loader->username("agua");
	$loader->owner("agua");
	
	my $package = "workflows";
	$loader->loadProjectFiles ("agua", $package, $installdir, $workflowdir)  
}

1;
