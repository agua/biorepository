package emboss;
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

	$self->logDebug("opsinfo", $self->opsinfo());

	#### SET VARIABLES
	my 	$username 		= $self->username();
	my 	$owner 			= $self->opsinfo()->owner();
	my 	$package 		= $self->opsinfo()->package();
	my 	$version 		= $self->opsinfo()->version();
	my  $random 		= $self->random();
	$self->logDebug("version", $version);

	if ( not defined $package or not $package ) {
		$package = $self->repository();
		$self->package($package);
	}
	
	#$self->logError("owner not defined") and exit if not defined $owner;
	#$self->logError("package not defined") and exit if not defined $package;
	#$self->logError("username not defined") and exit if not defined $username;
	#$self->logError("repotype not defined") and exit if not defined $repotype;
	#$self->logError("repository not defined") and exit if not defined $repository;
	
	$self->logDebug("owner", $owner);
	$self->logDebug("package", $package);
	$self->logDebug("username", $username);
	$self->logDebug("version", $version);
	$self->logDebug("random", $random);

	#### START LOGGING TO HTML FILE
	my $logfile = $self->setHtmlLogFile($package, $random);
	$self->logDebug("logfile", $logfile);
	$self->startHtmlLog($package, $version, $logfile);

	$self->updateReport(["Completed preInstall"]);

	return;
}

method runInstall {
	$self->logDebug("OVERRIDING Install::runInstall");

	#### PRE-INSTALL
	$self->preInstall();

	#### SET USER AND REPO NAMES
	my $selectedversion	=	$self->version();
	my $installdir		=	$self->installdir();
	my $package			=	$self->package();

	#### CREATE INSTALLDIR (E.G., /agua/apps/emboss)
	`mkdir -p $installdir` if not -d $installdir;
	$self->logError("Can't create installdir: $installdir") and exit if not -d $installdir;

	#### DOWNLOAD EMBOSS .tar.gz
	$self->updateReport(["Downloading EMBOSS"]);
	my $download 	=	$self->opsinfo()->download();
	$self->logDebug("download", $download);
	my $tempdir = "/tmp/emboss";
	#print `mkdir -p $tempdir`;
	#print `rm -fr $tempdir/*`;
	#print `cd $tempdir; wget $download`;
	#
	##### UNZIP AND CD
	#print `cd $tempdir; tar xvfz *.tar.gz`;
	my ($directory) = $download =~ /([^\/]+)\.orig\.tar\.gz$/;
	$directory =~ s/_/-/;
	$self->logDebug("directory", $directory);

	#### INSTALL X11 DEV LIBRARIES
	$self->updateReport(["Installing X11 development libraries for EMBOSS"]);
	#print `cd $tempdir/$directory; apt-get -y install libx11-dev;`;
	
	#### INSTALL EMBOSS
	$self->updateReport(["Installing EMBOSS"]);
	$self->updateReport(["Running: ./configure --prefix=$installdir"]);
	#print `cd $tempdir/$directory; ./configure --prefix=$installdir;`;
	$self->updateReport(["Running make"]);
	#print `cd $tempdir/$directory; make;`;
	$self->updateReport(["Running make install"]);
	#print `cd $tempdir/$directory; make install;`;
	
	#### POST-INSTALL
	$self->postInstall();

	return;
}

method postInstall {
	require Agua::CLI::App;

	my $owner 		= 	$self->owner();
	my $username 	= 	$self->username();
	my $package		=	$self->package();
	my $installdir	=	$self->installdir();
	my $opsdir		=	$self->opsdir();
	my $appdir 		= 	"$opsdir/apps";

	$self->logDebug("owner", $owner);
	$self->logDebug("username", $username);
	$self->logDebug("package", $package);
	$self->logDebug("installdir", $installdir);

	#### LOAD APP TYPES
	my $apptypes	=	$self->loadAppTypes("$opsdir/tsv/apptypes.tsv");
	
	#### LOAD PARAM CATEGORY VS VALUETYPE
	my $paramtypes = $self->loadParamTypes("$opsdir/tsv/paramtypes.tsv");
	
	#### CREATE APP FILES
	my $bindir 	= 	"$installdir/bin";
	$self->logDebug("bindir", $bindir);
	my $files 	=	$self->getFiles("$bindir");
	#$self->logDebug("files", $files);
	$self->logDebug("Doing createAppFiles");
	$self->updateReport(["Creating apps in appdir: $appdir"]);
	$self->createAppFiles($owner, $package, $installdir, $apptypes, $paramtypes, $appdir, $bindir, $files);
	$self->updateReport(["Completed creating apps"]);
	$self->logDebug("Completed createAppFiles");
	
	#### SET DATABASE HANDLE
	$self->setDbObject() if not defined $self->db();
	
	#### LOAD APP FILES
	$self->updateReport(["Loading apps in appdir: $appdir"]);
	$self->logDebug("Doing loadAppFiles");
	$self->loadAppFiles($username, $package, $installdir, $appdir);
	$self->updateReport(["Completed loading apps"]);
	$self->logDebug("Completed loadAppFiles");
	
	#### UPDATE PACKAGE TABLE
	$self->updateReport(["Updating 'package' table"]);
	$self->updatePackageTable($username, $package, $installdir, $opsdir, $appdir);
	
	return;
}
method loadAppTypes ($tsvfile) {
	$self->logDebug("tsvfile", $tsvfile);
	my $lines 	=	$self->fileLines($tsvfile);
	#$self->logDebug("lines", $lines);

	my $apptypes;
	%$apptypes = map {
		my ($app, $type, $description)	= $_ =~ /^(\S+)\s+(\S+)\s+(.+)$/;
		#$self->logDebug("app", $app);
		#$self->logDebug("apptype", $apptype);
		$app =>	{
			name		=>	$app,
			type		=>	$type,
			description	=>	$description
		};
	} @$lines;
	#$self->logDebug("apptypes", $apptypes);

	return $apptypes;	
}
method loadParamTypes ($tsvfile) {
	$self->logDebug("tsvfile", $tsvfile);
	my $lines 	=	$self->fileLines($tsvfile);
	#$self->logDebug("lines", $lines);

	my $paramtypes;
	%$paramtypes = map {
		my ($name, $category, $valuetype)	= $_ =~ /^(\S+)\s+(\S+)\s+(\S+)$/;
		$name =>	{
			name		=>	$name,
			category	=>	$category,
			valuetype	=>	$valuetype
		};
	} @$lines;
	#$self->logDebug("paramtypes", $paramtypes);

	return $paramtypes;	
}
method createAppFiles ($owner, $package, $installdir, $apptypes, $paramtypes, $appdir, $bindir, $files) {
	require Agua::CLI::App;

	my $url		=	$self->opsinfo()->url();
	my $linkurl	=	$self->opsinfo()->linkurl();
	
	foreach my $file ( @$files ) {
		$self->logDebug("file", $file);

		#### SKIP NON-COMMAND LINE APPLICATIONS
		next if $file eq "acdgalaxy" or $file eq "runJemboss.csh" or $file eq "jembossctl";

		#### GET -help OUTPUT
		my $filepath 	= 	"$bindir/$file";
		my $command 	=	"$filepath --help";
		my ($out, $help)=	$self->runCommand($command);
		#$self->logDebug("help", $help);
		next if $help =~ /^Error/;
		my $type	=	$apptypes->{$file}->{type};
		$self->logDebug("type", $type);

		#### CHECK FOR ERROR - TYPE NOT DEFINED
		$self->logDebug("type not defined for file: $file") and next if not defined $type;
		
		my $outputdir	=	"$appdir/$type";
		
		my $app 		=	$apptypes->{$file};
		$app->{owner}		=	$owner;
		$app->{package}		=	$package;
		$app->{installdir}	=	$installdir;
		$app->{location}	=	"bin/$file";
		$app->{url}			=	$url;

		#### ADD LINK IF PROVIDED
		my $link	=	$self->setLink($linkurl, $file, $type);
		if ( defined $link and $link ne "" ) {
			$app->{linkurl}	=	$link;
		}
		$self->logDebug("app", $app);

		my $parameters	=	{};
		($app, $parameters)	=	$self->parseEmboss($help, $app, $paramtypes);
		$self->logDebug("app", $app);
		$self->logDebug("parameters", $parameters);
		
		my $application = Agua::CLI::App->new($app);
		$self->logNote("application", $application);
	
		foreach my $parameter ( @$parameters ) {
			$parameter->{param} = $parameter->{name};
			$parameter->{inputArgs} = $parameter->{args};
			$application->loadParam($parameter);
		}

		#### CREATE APP SUBDIR
		my $apptypedir = "$appdir/$app->{type}";
		File::Path::mkpath($apptypedir) if not -d $apptypedir;
		$self->logError("Can't create apptypedir: $apptypedir") and exit if not -d $apptypedir;

		#### SET APP FILE
		my $appfile = "$apptypedir/$app->{name}.app";
		$self->logDebug("appfile", $appfile);
		
		#### PRINT APP FILE
		$application->exportApp($appfile);
	}
}

method setLink ($linkurl, $appname, $apptype) {
	return if not defined $linkurl or $linkurl eq "";
	my $link	=	$linkurl;
	$link		=~ s/<APP>/$appname/;
	$link		=~ s/<APPTYPE>/$apptype/;
	
	return $link;
}

method updatePackageTable ($username, $package, $installdir, $opsdir, $appdir) {	
	$self->logDebug("username", $username);
	$self->logDebug("package", $package);
	$self->logDebug("installdir", $installdir);
	$self->logDebug("appdir", $appdir);
		
	#### GET FIRST APP
	my $typedirs = $self->getDirs($appdir);
	@$typedirs = sort @$typedirs;
	$self->logDebug("typedirs", $typedirs);
	my $typedir = $$typedirs[0];
	my $subdir = "$appdir/$typedir";
	my $appfiles = $self->getFiles($subdir);
	@$appfiles 	=	sort @$appfiles;
	$self->logDebug("typedir '$typedir' appfiles: @$appfiles") if defined $appfiles;	
	my $appfile = 	"$subdir/$$appfiles[0]";
	my $app		=	$self->jsonFileToObject($appfile);
	#$self->logDebug("app", $app);

	#### SET PACKAGE TO APP
	$app->{username}	=	$username;
	$app->{opsdir}		=	$opsdir;
	$app->{url}			=	$self->opsinfo()->url();
	$app->{description}	=	$self->opsinfo()->description();
	$app->{status}		=	"ready";

	$self->logDebug("FINAL APP to load as PACKAGE", $app);
	
	$self->_removePackage($app);
	
	$self->_addPackage($app);
}

method getVolume ($snapshot) {
	my $query = qq{SELECT * FROM volume WHERE snapshot='$snapshot'};
	return $self->dbobject()->queryhash($query);
}

method  checkInputs {
	$self->logDebug("self->username", $self->username());
	$self->logDebug("self->version", $self->version());

	#$self->logCritical("self->username not defined") and return 0 if not defined $self->username();
	#$self->logCritical("self->owner not defined") and return 0 if not defined $self->owner();
	#$self->logCritical("self->repository not defined") and return 0 if not defined $self->repository();
	$self->logCritical("self->installdir not defined") and return 0 if not defined $self->installdir();
}

##############################################################################
#							PARSE help OUTPUT
##############################################################################
method parseEmboss ($contents, $app, $paramtypes) {
    $contents =~ s/^[^\n]+\-\-help\s*\n//ms;
    $self->logDebug("contents", $contents);
    my ($description)	=	$contents =~ /^([^\n]+)\n/ms;
    $self->logDebug("description", $description);
	$app->{description}	=	$description;
	
    my ($version)	=	$contents =~ /Version:\s*EMBOSS:([^\n]+)\n/ms;
    $self->logDebug("version", $version);
	$app->{version}	=	$version;

    #### GET REQUIRED PARAMETERS	
	my $parameters	=	[];
    my ($standard) 	=	$contents	=~ /Standard \(Mandatory\) qualifiers[^:^\n]*:\s*\n(.+?)\n\s+Additional \(Optional\) qualifiers/ms;
    my $options = {	discretion	=> "required"	};
    my $standardparameters = $self->parseEmbossSection($standard, $options, $paramtypes);
    #$self->logDebug("standard", "\n" . $standard . "***");
    $self->logDebug("standardparameters", $standardparameters);
	@$parameters 	=	(@$parameters, @$standardparameters);
    
    #### Additional (Optional) qualifiers
    my ($additional) 	=	$contents	=~ /Additional \(Optional\) qualifiers[^:^\n]*:\s*\n(.+?)\n\s+Advanced \(Unprompted\) qualifiers/ms;
    $options = {	discretion	=> "optional"	};
    my $additionalparameters = $self->parseEmbossSection($additional, $options, $paramtypes);
    #$self->logDebug("additional", "\n" . $additional . "***");
    $self->logDebug("additionalparameters", $additionalparameters);
	@$parameters 	=	(@$parameters, @$additionalparameters);
	
    #### Advanced (Unprompted) qualifiers
    my ($advanced) 	=	$contents	=~ /Advanced \(Unprompted\) qualifiers[^:^\n]*:\s*\n(.+?)\n\s+General qualifiers/ms;
    $options = {	discretion	=> "optional"	};
    my $advancedparameters = $self->parseEmbossSection($advanced, $options, $paramtypes);
    #$self->logDebug("advanced", "\n" . $advanced . "***");
    $self->logDebug("advancedparameters", $advancedparameters);
	@$parameters 	=	(@$parameters, @$advancedparameters);
    
    #### General qualifiers
    my ($general) 	=	$contents	=~ /General qualifiers[^:^\n]*:\s*\n(.+)/ms;
    $options = {	discretion	=> "optional"	};
    my $generalparameters = $self->parseEmbossSection($general, $options, $paramtypes);
    #$self->logDebug("general", "\n" . $general . "***");
    $self->logDebug("generalparameters", $generalparameters);
	@$parameters 	=	(@$parameters, @$generalparameters);

	return ($app, $parameters);
}

method parseEmbossSection ($section, $options, $paramtypes) {
#### FORMAT
#### <2-3 space>argument
#### <24 characters>paramtype
#### <35 characters>[default value]? description    
	return [] if not defined $section;
	$options = {} if
    my $lines;
    @$lines = split "\n", $section;
    $self->logDebug("lines", $lines);
    my $parameters = [];
    for ( my $i = 0; $i < @$lines; $i++ ) {
		my $entry = $$lines[$i];
		$self->logDebug("line", $entry);
	
		if ( $entry =~ /^\*?\s{2,3}/ ) {	
			$i++;
			if ( $$lines[$i]) {
				$self->logDebug("lines[$i]", $$lines[$i]);
		
				while ( $$lines[$i] and $$lines[$i] !~ /^\*?\s{2,3}\S+/ ) {
					$$lines[$i] =~ s/\s+/ /;
					$self->logDebug("lines[$i]", $$lines[$i]);
					$entry .= $$lines[$i];
					$i++;
				}
				$i--;
			}

			my $parameter = $self->parseEmbossEntry($entry, $paramtypes);
			$self->logDebug("parameter", $parameter);

			#### SKIP HELP
			next if $parameter->{name} eq "help";

			foreach my $key ( keys %$options ) {
				$self->logDebug("Adding key $key->value", $options->{$key});
				$parameter->{$key} = $options->{$key};
			}
			
			push(@$parameters, $parameter);
		}
    }

    return $parameters;
}

method parseEmbossEntry ($entry, $paramtypes) {
	my ($argument) = $entry =~ /\*?.{2,3}?(\S+)/;
	$self->logDebug("argument", $argument);
	$argument =~ s/[\[\]]+//g;
	$self->logDebug("argument", $argument);
	my ($name) = $argument;
	$name =~ s/^\-//;
	$self->logDebug("name", $name);
	my ($valuetype) = $entry =~ /^\*?\s*\S+\s+(\S+)/;
	$self->logDebug("valuetype", $valuetype);

	my ($description)	=	$entry =~ /.{34}(.+)/;
	$self->logDebug("description", $description);
	my ($value) = $description =~ /^\[([^\]]+)\]/;
	$value = "" if not defined $value;
	$description 	=~	s/^\[[^\]]+\]\s+//;
	$description	=~	s/"/'/g;
	$self->logDebug("value", $value);
	$self->logDebug("description", $description);
	
	#### SET PARAMETER
	my $parameter = {
		name 		=>	$name,
		argument 	=>	$argument,
		valuetype	=>	$paramtypes->{$valuetype}->{valuetype},
		category	=>	$paramtypes->{$valuetype}->{category},
		paramtype	=>	"input",
		value		=>	$value,
		description	=>	$description
	};
	$self->logDebug("parameter", $parameter) if $name eq "outseq";

	return $parameter;
}








1;