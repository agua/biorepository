package moores;
use Moose::Role;
use Method::Signatures::Simple;

method doInstall ($installdir, $version) {
    $self->logDebug("version", $version);
    $self->logDebug("installdir", $installdir);
    $version = $self->version() if not defined $version;
    
    return 0 if not $self->gitInstall($installdir, $version);

    return 0 if not $self->loadWorkflows($installdir, $version);

    return 0 if not $self->loadData($installdir, $version);
    
    return $version;
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

    print "...completed loading workflows\n";
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
    $command     =   "$basedir/bin/sample/loadSamples.pl --table samples --tsvfile $installdir/$version/data/samples.tsv --sqlfile $installdir/$version/data/samples.sql";
    $self->logDebug("command", $command);
    $self->runCommand($command);

    print "...completed loading data\n";
}



1;