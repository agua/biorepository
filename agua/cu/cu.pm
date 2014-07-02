package cu;
use Moose::Role;
use Method::Signatures::Simple;

method doInstall ($installdir, $version) {
    $self->logDebug("version", $version);
    $self->logDebug("installdir", $installdir);
    $version = $self->version() if not defined $version;
    
    return 0 if not $self->gitInstall($installdir, $version);
    
    return 0 if not $self->loadWorkflows($installdir, $version);
    
    return 0 if not $self->loadData($installdir, $version);
    
    return 0 if not $self->setRabbitMq($installdir, $version);
    
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
    
    if ( defined $user ) {
        print "Missing RabbitMQ authentication info: pass\n" and return if not defined $pass;
        print "Missing RabbitMQ authentication info: vhost\n" and return if not defined $vhost;

        #### SET AUTHENTICATION ON master
        $self->runCommand("sudo rabbitmqctl add_user $user $pass");
        $self->runCommand("sudo rabbitmqctl add_vhost $vhost");
        $self->runCommand(qq{sudo rabbitmqctl set_permissions -p $vhost $user ".*" ".*" ".*"});
        
        #### SET AUTHENTICATION ON master
        my $extra =   qq{
sudo rabbitmqctl add_user $user $pass
sudo rabbitmqctl add_vhost $vhost
sudo rabbitmqctl set_permissions -p $vhost $user ".*" ".*" ".*"
service rabbitmq-server restart
};
        $self->logDebug("extra", $extra);
        
        $self->printToFile($extrafile, $extra);
    }
    else {
        #### INSERTED INTO userdata.tmpl COMMANDS USING extra
        print "user is defined: $user\n";
    }

   return 1;
}

method loadWorkflows ($installdir, $version) {
    print "Loading workflows\n";
    $self->logDebug("installdir", $installdir);
    $self->logDebug("version", $version);
    
    my $basedir =   $self->conf()->getKey("agua", "INSTALLDIR");
    $self->logDebug("basedir", $basedir);
    my $project     =   "CU";
    my $username    =   "syoung";
    $version        =   $self->version() if not defined $version;
    $self->logDebug("FINAL version", $version);
    
    my $filedir     =   "$installdir/$version/conf";
    my $name        =   "CU";
    $self->loadProject($filedir, $name, $username);

    my $filedir     =   "$installdir/$version/conf/Load";
    my $name        =   "Load";
    $self->loadProject($filedir, $name, $username);

    my $filedir     =   "$installdir/$version/conf/Run";
    my $name        =   "Run";
    $self->loadProject($filedir, $name, $username);
    
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
    print "Loading data\n";
    $self->logDebug("installdir", $installdir);
    $self->logDebug("version", $version);

    my $basedir     =   $self->conf()->getKey("agua", "INSTALLDIR");
    my $username    =   $self->username();
    my $project     =   $self->package();
    $self->logDebug("basedir", $basedir);
    $self->logDebug("username", $username);
    $self->logDebug("project", $project);
    
    $version        =   $self->version() if not defined $version;
    $self->logDebug("FINAL version", $version);
    
    #### LOAD SAMPLES IDs
    my $command     =   "$basedir/bin/sample/loadSamples.pl --username $username --project $project --workflow loadSamples --workflownumber 1 --file $installdir/$version/data/samples.tsv";
    $self->logDebug("command", $command);
    $self->runCommand($command);
    
    #### LOAD SAMPLES FILE NAMES AND SIZES
    $command     =   "$basedir/bin/sample/loadTable.pl --table sample --tsvfile $installdir/$version/data/tsv/sample.tsv --sqlfile $installdir/$version/data/sql/sample.sql";
    $self->logDebug("command", $command);
    $self->runCommand($command);

    return 1;
}


1;