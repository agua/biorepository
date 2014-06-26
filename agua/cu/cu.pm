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

    #### master: AUTHENTICATE WITH RabbitMQ AND ADD TO extra FILE.
    #### extra FILE WILL BE ADDED TO USERDATA WHEN VM IS LAUNCHED
    my $extrafile  =   "$installdir/$version/data/sh/extra";
    if ( defined $user ) {
        print "Missing RabbitMQ authentication info: pass\n" and return if not defined $pass;
        print "Missing RabbitMQ authentication info: vhost\n" and return if not defined $vhost;

        #### SET AUTHENTICATION ON master
        $self->runCommand("sudo rabbitmqctl add_user $user $pass");
        $self->runCommand("sudo rabbitmqctl add_vhost $vhost");
        $self->runCommand(qq{sudo rabbitmqctl set_permissions -p $vhost $user ".*" ".*" ".*"});
        
        #### SET AUTHENTICATION ON master
        my $content =   qq{
sudo rabbitmqctl add_user $user $pass
sudo rabbitmqctl add_vhost $vhost
sudo rabbitmqctl set_permissions -p $vhost $user ".*" ".*" ".*"
service rabbitmq-server restart
};
        
        
    }
    else {
        
    }
}

method loadWorkflows ($installdir, $version) {
    print "Loading workflows\n";
    $self->logDebug("installdir", $installdir);
    $self->logDebug("version", $version);
    
    my $basedir =   $self->conf()->getKey("agua", "INSTALLDIR");
    $self->logDebug("basedir", $basedir);
    my $project     =   "CU";
    my $username    =   "syoung";

    #### DELETE EXISTING project ENTRY
    $self->runCommand("cd $installdir/$version/conf && /agua/bin/cli/flow.pl ./CU.proj delete --username $username");
    
    #### ADD project
    $self->runCommand("cd $installdir/$version/conf && /agua/bin/cli/flow.pl ./CU.proj save --username $username");
    
    #### ADD WORKFLOWS
    $self->runCommand("cd $installdir/$version/conf && /agua/bin/cli/flow.pl CU.proj saveWorkflow --wkfile 1-LoadSamples.work --username $username");
    $self->runCommand("cd $installdir/$version/conf && /agua/bin/cli/flow.pl CU.proj saveWorkflow --wkfile 2-Download.work --username $username");
    $self->runCommand("cd $installdir/$version/conf && /agua/bin/cli/flow.pl CU.proj saveWorkflow --wkfile 3-Bwa.work --username $username");
    $self->runCommand("cd $installdir/$version/conf && /agua/bin/cli/flow.pl CU.proj saveWorkflow --wkfile 4-FreeBayes.work --username $username");
    $self->runCommand("cd $installdir/$version/conf && /agua/bin/cli/flow.pl CU.proj saveWorkflow --wkfile 5-Upload.work --username $username");
}

method loadData ($installdir, $version) {
    print "Loading data\n";
    $self->logDebug("installdir", $installdir);
    $self->logDebug("version", $version);

    #### LOAD SAMPLES IDs
    my $command     =   "$basedir/bin/sample/loadSamples.pl --username $username --project $project --workflow loadSamples --workflownumber 1 --file $installdir/$version/data/samples.tsv";
    $self->logDebug("command", $command);
    $self->runCommand($command);
    
    #### LOAD SAMPLES FILE NAMES AND SIZES
    $command     =   "$basedir/bin/sample/loadTable.pl --table sample --tsvfile $installdir/$version/data/tsv/sample.tsv --sqlfile $installdir/$version/data/sql/sample.sql";
    $self->logDebug("command", $command);
    $self->runCommand($command);
}


1;