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
	
	$self->logDebug("owner", $owner);
	$self->logDebug("package", $package);
	$self->logDebug("username", $username);
	$self->logDebug("version", $version);
	$self->logDebug("random", $random);

	return;
}

method doInstall ($installdir, $version) {

	$self->logDebug("Doing self->zipInstall()");
	$version = $self->zipInstall($installdir, $version);
	
	$self->logDebug("Doing self->installDependencies()");
	$self->installDependencies();
	
	$self->logDebug("Doing self->configInstall()");
	$self->configInstall($installdir, $version);

	return 1;
}

method configInstall ($installdir, $version) {
	$self->logDebug("version", $version);
	$self->logDebug("installdir", $installdir);

	#### CHANGE DIR
    $self->changeDir("$installdir/$version");
	
	my $logfile	=	"/tmp/emboss-$$-make.log";
	$self->logDebug("logfile", $logfile);
	
	#### MAKE
	my $log	=	"";
	my ($output, $error) 	=	$self->runCommand("./configure --prefix=$installdir/$version");
	$log .= "CONFIGURE OUTPUT:\n$output\n";
	$log .= "CONFIGURE ERROR:\n$error\n";

	($output, $error) 	=	$self->runCommand("make");
	$log .= "MAKE OUTPUT:\n$output\n";
	$log .= "MAKE ERROR:\n$error\n";

	($output, $error) 	=	$self->runCommand("make install");
	$log .= "MAKE INSTALL OUTPUT:\n$output\n";
	$log .= "MAKE INSTALL ERROR:\n$error\n";

	$self->printToFile($logfile, $log);
}

method installDependencies {

	#### INSTALL X11 DEV LIBRARIES
	$self->logDebug("Installing X11 development libraries for EMBOSS");	
	my $arch = $self->getArch();
	$self->logDebug("arch", $arch);
	$self->runCommand("apt-get -y install libx11-dev") if $arch eq "ubuntu";
	$self->runCommand("yum -y install libx11-devel") if $arch eq "centos";
}

method postInstall ($installdir, $version) {
	$self->logDebug("installdir", $installdir);
	$self->logDebug("version", $version);

	require Agua::CLI::App;

	my $owner 		= 	$self->owner();
	my $username 	= 	$self->username();
	my $package		=	$self->package();
	my $opsdir		=	$self->opsdir();
	my $appdir 		= 	"$opsdir/apps";
	my $format		=	"yaml";

	$self->logDebug("owner", $owner);
	$self->logDebug("username", $username);
	$self->logDebug("package", $package);
	$self->logDebug("installdir", $installdir);

	#### LOAD APP TYPES
	my $apptypes	=	$self->loadAppTypes("$opsdir/tsv/apptypes.tsv");
	
	#### LOAD PARAM CATEGORY VS VALUETYPE
	my $paramtypes = $self->loadParamTypes("$opsdir/tsv/paramtypes.tsv");
	
	#### CREATE APP FILES
	my $bindir 	= 	"$installdir/$version/bin";
	$self->logDebug("bindir", $bindir);
	my $files 	=	$self->getFiles("$bindir");
	#$self->logDebug("files", $files);
	$self->logDebug("Doing createAppFiles");
	$self->createAppFiles($owner, $package, $installdir, $apptypes, $paramtypes, $appdir, $bindir, $files);
	$self->logDebug("Completed createAppFiles");
	
	#### SET DATABASE HANDLE
	$self->setDbObject() if not defined $self->db();
	
	#### LOAD APP FILES
	$self->logDebug("Doing loadAppFiles");
	$self->loadAppFiles($username, $package, $installdir, $appdir, $format);
	$self->logDebug("Completed loadAppFiles");
	
	return 1;
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
		next if $file eq "acdgalaxy"
		or $file eq "runJemboss.csh"
		or $file eq "jembossctl"
		or $file =~ "^acd";

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

		$self->logDebug("app", $app);
	
		
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