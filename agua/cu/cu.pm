package cu;
use Moose::Role;
use Method::Signatures::Simple;

method doInstall ($installdir, $version) {
    $self->logDebug("version", $version);
    $self->logDebug("installdir", $installdir);
    $version = $self->version() if not defined $version;
    
#    return 0 if not $self->gitInstall($installdir, $version);
#	$version	=	$self->version();
	
    return 0 if not $self->setExtra($installdir, $version);
    
    #return 0 if not $self->loadWorkflows($installdir, $version);
    #
    #return 0 if not $self->loadData($installdir, $version);

    return 1;
}

method setExtra ($installdir, $version) {
    #### extra FILE WILL BE ADDED TO USERDATA WHEN VM IS LAUNCHED

	my $extra		=	$self->setRabbitMq($installdir, $version);
	$self->logDebug("rabbitmq extra", $extra);
	
	$extra			.=	$self->setOpenstackCredentials($installdir, $version);
	$self->logDebug("FINAL extra", $extra);

	return 0 if not defined $extra;
	
    my $extrafile  =   "$installdir/$version/data/sh/extra";
    $self->logDebug("extrafile", $extrafile);

	$self->printToFile($extrafile, $extra);

   return 1;
}

method setRabbitMq ($installdir, $version) {
    my $user        =   $self->conf()->getKey("queue", "user");
    my $pass        =   $self->conf()->getKey("queue", "pass");
    my $vhost       =   $self->conf()->getKey("queue", "vhost");
    $self->logDebug("user", $user);
    $self->logDebug("pass", $pass);
    $self->logDebug("vhost", $vhost);
    
    #### master: AUTHENTICATE WITH RabbitMQ AND ADD TO extra FILE.
    #### extra FILE WILL BE ADDED TO USERDATA WHEN VM IS LAUNCHED
    my $extrafile  =   "$installdir/$version/data/sh/extra";
    $self->logDebug("extrafile", $extrafile);
    
    return "" if not defined $user;

	print "Missing RabbitMQ authentication info: pass\n" and return if not defined $pass;
	print "Missing RabbitMQ authentication info: vhost\n" and return if not defined $vhost;

	#### SET AUTHENTICATION ON master
	$self->runCommand("sudo rabbitmqctl add_user $user $pass");
	$self->runCommand("sudo rabbitmqctl add_vhost $vhost");
	$self->runCommand(qq{sudo rabbitmqctl set_permissions -p $vhost $user ".*" ".*" ".*"});
	
	#### SET AUTHENTICATION ON master
	my $extra =   qq{
echo "SETTING RABBITMQ AUTHENTICATION"
sudo rabbitmqctl add_user $user $pass
sudo rabbitmqctl add_vhost $vhost
sudo rabbitmqctl set_permissions -p $vhost $user ".*" ".*" ".*"
service rabbitmq-server restart

};
	$self->logDebug("extra", $extra);

   return $extra;
}

method setOpenstackCredentials ($installdir, $version) {

	my $basedir		=   $self->conf()->getKey("agua:INSTALLDIR", undef);	
	$self->logDebug("basedir", $basedir);

	my $extra		=	qq{echo "SETTING OPENSTACK CREDENTIALS"\n};
	my $credentials	=	["authurl", "password", "tenantid", "tenantname", "username"];
	foreach my $credential ( @$credentials ) {
	    my $value	=   $self->conf()->getKey("openstack", $credential);
		$extra		.=	qq{$basedir/bin/openstack/config.pl --mode setKey --section "openstack:$credential" --value $value\n};
	}
	$extra	.=	"\n";
	$self->logDebug("extra", $extra);

   return $extra;
}

method loadWorkflows ($installdir, $version) {
    print "Loading workflows\n";
    
    $version 	= 	$self->version() if $version eq "max";
    $version	=   $self->version() if not defined $version;
    $self->logDebug("installdir", $installdir);
    $self->logDebug("version", $version);
    
    my $basedir 	=   $self->conf()->getKey("agua", "INSTALLDIR");
    my $project     =   "CU";
    my $username    =   "syoung";
    	
	#### LOAD 'CU' PROJECT
    print "Loading CU project\n";
	$self->loadProject("$installdir/$version/conf", "CU", $username);
    
	#### LOAD 'SRA' PROJECT
    print "Loading SRA project\n";
    $self->loadProject("$installdir/$version/conf/sra", "SRA", $username);
    $self->loadProject("$installdir/$version/conf/sra/LoadSRA", "LoadSRA", $username);
    $self->loadProject("$installdir/$version/conf/sra/RunSRA", "RunSRA", $username);

	#### LOAD 'TCGA' PROJECT
    print "Loading TCGA project\n";
    $self->loadProject("$installdir/$version/conf/tcga", "TCGA", $username);
    $self->loadProject("$installdir/$version/conf/tcga/LoadTCGA", "LoadTCGA", $username);
    $self->loadProject("$installdir/$version/conf/tcga/LoadTCGA", "RunTCGA", $username);

    return 1;
}

method loadProject ($filedir, $name, $username) {
    #### DELETE EXISTING project ENTRY
    $self->runCommand("cd $filedir && /agua/bin/cli/flow.pl ./$name.proj delete --username $username");
    
    #### ADD project
    $self->runCommand("cd $filedir && /agua/bin/cli/flow.pl ./$name.proj save --username $username");
    
    #### ADD WORKFLOWS
    my $workfiles   =   $self->getWorkFiles($filedir);
    $self->logDebug("workfiles", $workfiles);
    foreach my $workfile ( @$workfiles ) {
        $self->runCommand("cd $filedir && /agua/bin/cli/flow.pl $name.proj saveWorkflow --wkfile $workfile --username $username");
    }
}

method getWorkFiles ($directory) {
	my $regex	=	"\\.work\$";
	
	my $workfiles   =   $self->getFilesByRegex($directory, $regex);    
    $workfiles      =   $self->sortByRegex($workfiles, "^(\\d+)");

    return $workfiles;
}

method loadData ($installdir, $version) {
    $version = $self->version() if $version eq "max";
    $self->logDebug("installdir", $installdir);
    $self->logDebug("version", $version);

    my $basedir     =   $self->conf()->getKey("agua", "INSTALLDIR");
    my $username    =   $self->username();
    my $project     =   $self->package();
    $self->logDebug("basedir", $basedir);
    $self->logDebug("username", $username);
    $self->logDebug("project", $project);
    
	#### LOAD SRA DATA
    print "Loading SRA data\n";
	$self->loadProjectData($installdir, $version, "sra");

	#### LOAD TCGA DATA
    print "Loading TCGA data\n";
	$self->loadProjectData($installdir, $version, "tcga");
	
    return 1;
}

method loadProjectData ($installdir, $version, $group) {
	my $table		=	$group . "sample";
	my $sqlfile		=	"$installdir/$version/data/$group/sql/$table.sql";
	my $tsvfile		=	"$installdir/$version/data/$group/tsv/$table.tsv";
	$self->logDebug("sqlfile", $sqlfile);
	$self->logDebug("tsvfile", $tsvfile);
	$self->logDebug("table", $table);
	
	#### CREATE TABLE
	$self->loadSqlFile($sqlfile);
	
	#### LOAD TCGA DATA
	$self->db()->load($table, $tsvfile, undef);	
}


method loadSqlFile ($sqlfile) {
	#### LOAD SQL
	my $query	=	$self->fileContents($sqlfile);
	$self->logDebug("query", $query);
	$self->db()->do($query);
}


1;