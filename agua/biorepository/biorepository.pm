package biorepository;
use Moose::Role;
use Method::Signatures::Simple;

use Data::Dumper;
use Agua::Package;

has 'sessionId'	=> ( isa => 'Str|Undef', is => 'rw', required	=>	0	);
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
    $self->owner("agua");
	$self->repository("biorepository");
	$self->package("biorepository");
	$self->hubtype("github");
	$self->privacy("public");

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

#### POST-INSTALL
method postInstall {
	$self->logDebug("");
	$self->logDebug("biorepository    self->dbobject()", $self->dbobject());

	##### RUN INSTALL TO SET PERMISSIONS, ETC.
	#$self->logDebug("Doing loadProjects()");
	#$self->loadProjects();
	
	#### SET ACCESS
	$self->logDebug("Doing setAccess()");
	$self->setAccess();
	$self->logDebug("Completed setAccess()");

	return "Completed postInstall";
}

method loadProjects {
	my $installdir  =   $self->conf()->getKey("biorepository", "INSTALLDIR");
	my $basedir 	=	$self->conf()->getKey("agua", "INSTALLDIR");
	$self->logDebug("installdir", $installdir);
	$self->logDebug("basedir", $basedir);
	$self->logDebug("self->dbobject()", $self->dbobject());

	#### SET OPSDIR FOR APPDIR AND TO RETRIEVE DB ENTRY
	my $opsdir = "$basedir/repos/public/agua/biorepository";
	$self->logDebug("opsdir", $opsdir);
	
	### SET WORKFLOW DIR
	my $workflowdir = 	$self->setWorkflowDir($opsdir, "agua");
	$self->logDebug("workflowdir", $workflowdir);

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
		conf		=>	$self->conf(),
		dbobject	=>	$self->dbobject()
	});
	
	#### SET agua AS USERNAME AND OWNER
	$loader->username("agua");
	$loader->owner("agua");

	#### COPY FROM login WORKFLOWS IF login IS NOT agua
	my $login = $self->login();
	$self->logDebug("login", $login);
	$self->copyLoginWorkflows($login) if $login ne "agua";

	#### LOAD WORKFLOWS INTO DATABASE
	my $package = "workflows";
	$loader->loadProjectFiles ("agua", $package, $installdir, $workflowdir);
}

method copyLoginWorkflows ($login) {
	$self->logDebug("login", $login);

	#### SET SOURCE DIR
	my $opsdir 	=	$self->opsdir();
	$self->logDebug("opsdir", $opsdir);	
	my $sourcedir = 	"$opsdir/workflows";
	$self->logDebug("sourcedir", $sourcedir);

	#### SET WORKFLOW DIR
	my $targetdir = 	$sourcedir;
	$targetdir =~ s/$login/agua/g;
	$self->logDebug("targetdir", $targetdir);

	#### CREATE TARGET DIR
	`mkdir -p $targetdir` if not -d $targetdir;
	$self->logCritical("Can't create targetdir", $targetdir) and exit if not -d $targetdir;;

	return if not -d $sourcedir;
	my $command = "cp -fr $sourcedir/* $targetdir";
	$self->logDebug("command", $command);
	`$command`;
}

method setAccess {

	#### ADD TO access
	my $table = "access";
	my $required = ["owner", "groupname"];
	my $hash = {
		owner   =>  "agua",
		groupname   =>  "projects",
		groupwrite  =>  1,
		groupcopy   =>  1,
		groupview   =>  1,
		worldwrite  =>  1,
		worldcopy   =>  1,
		worldview   =>  1
	};
	#### insert into access values ('agua','projects', 1,1,1,1,1,1);
	$self->_addToTable($table, $hash, $required);


	#### GET PROJECT OBJECTS
	my $projectobjects = $self->getProjectObjects();
	$self->logDebug("no. projectobjects", scalar(@$projectobjects));
	
	#### ADD TO groupmember
	$table = "groupmember";
	$required = ["owner", "groupname"];
	foreach my $projectobject ( @$projectobjects ) {
		$hash = {
			owner		=>	"agua",
			groupname	=>	"projects",
			groupdesc	=>	"Open-source bioinformatics workflows",
			type		=>	"project",
			name		=>	$projectobject->name(),
			description	=>	$projectobject->description(),
			location	=>	''
		};
		#### insert into groupmember values('agua','projects','Description of ','Project2','project', '','');
		$self->_addToTable($table, $hash, $required);
	}
}

method 	getProjectObjects {
	my $username = $self->username();
	$self->logDebug("username", $username);

	my $package = "workflows";
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

	require Agua::CLI::Project;
	$self->logDebug("username", $username);
	$self->logDebug("workflowdir", $workflowdir);

	#### GET PROJECT DIRECTORIES
	my $projects = $self->getDirs("$workflowdir/projects");
	$self->logDebug("projects", $projects);
	
	my $projectobjects = [];
	foreach my $project ( @$projects ) {
		
		my $projectfile = "$workflowdir/projects/$project/$project.proj";
		$self->logDebug("projectfile", $projectfile);
		$self->logCritical("projectfile not found", $projectfile) if not -f $projectfile;
	
		$self->logDebug("Doing Agua::CLI::Project->new()");	
		my $projectobject = Agua::CLI::Project->new(
			inputfile	=>	$projectfile,
			logfile		=>	$self->logfile(),
			SHOWLOG		=>	$self->SHOWLOG(),
			PRINTLOG	=>	$self->PRINTLOG()
		);
		$projectobject->workflows([]);

		push @$projectobjects, $projectobject;	
	}
	
	$self->logDebug("FINAL no. projectsobjects", scalar(@$projectobjects));
	
	return $projectobjects;
}

1;
