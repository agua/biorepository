package dnaseq;
use Moose::Role;
use Method::Signatures::Simple;

method doInstall ($installdir, $version) {
    $self->logDebug("version", $version);
    $self->logDebug("installdir", $installdir);
    $version = $self->version() if not defined $version;
    
    return 0 if not $self->gitInstall($installdir, $version);

$self->version("0.0.1");
    $version = $self->version();
    $self->logDebug("AFTER gitInstall    version", $version);

	#### LOAD APP FILES
    my $username    =   $self->username();
    my $package    =   $self->package();
    my $appdir      =   "$installdir/$version/conf/app";
    my $format      =   "yaml";
	$self->logDebug("Doing loadAppFiles");
	$self->loadAppFiles($username, $package, $installdir, $appdir, $format);
	$self->logDebug("Completed loadAppFiles");

    return 0 if not $self->loadWorkflows($installdir, $version);
    
    return 0 if not $self->loadData($installdir, $version);
    
    return $version;
}

method loadWorkflows ($installdir, $version) {
    print "Loading workflows\n";
    $self->logDebug("installdir", $installdir);
    $self->logDebug("version", $version);
    
    my $basedir =   $self->conf()->getKey("agua", "INSTALLDIR");
    my $username    =   $self->username();
    $self->logDebug("basedir", $basedir);
    $self->logDebug("username", $username);

    #### DELETE EXISTING project ENTRY
    $self->runCommand("cd $installdir/$version/conf && /agua/bin/cli/flow.pl ./CU.proj delete --username $username");
    
    #### ADD project
    $self->runCommand("cd $installdir/$version/conf && /agua/bin/cli/flow.pl ./CU.proj save --username $username");
    
    #### ADD WORKFLOWS
    my $projects = [
        {
            project =>  "Align",
            workflows   =>  [
                "Bwa"
            ]
        }
        ,
        {
            project =>  "DnaSeq",
            workflows   =>  [
                "FixMates",
                "FilterReads",
                "MarkDuplicates",
                "AddReadGroups",
                "QualityFilter",
                "IndelRealignment",
                "BaseRecalibration",
                "HaplotypeCaller",
                "Varscan",
                "FreeBayes"
            ]
        }
        ,
        {
            project =>  "FastQC",
            workflows   =>  [
                "FastQC"
            ]
        }
        ,
        {
            project =>  "Fork",
            workflows   =>  [
                "FastQcFork",
                "HetHomFork",
                "TsTvFork",
                "RelatednessFork"
            ]
        }
        ,
        {
            project =>  "QC",
            workflows   =>  [
                "DownloadClinQC",
                "DownloadQC",
                "Download",
                "QCFork",
                "QC"
            ]
        }
        ,
        {
            project =>  "Variant",
            workflows   =>  [
                "FreeBayes",
                "Varscan"
            ]
        }
    ];
    
    my $flow = "/a/bin/cli/flow";
    foreach my $project ( @$projects ) {
        my $projectname     =   $project->{project};
        print "Loading workflows for project '$projectname'\n";
        $self->logDebug("projectname", $projectname);

        #### CREATE PROJECT
        $self->runCommand("/a/bin/cli/flow deleteProject --project $projectname --username admin");
        $self->runCommand("/a/bin/cli/flow addProject --project $projectname --username admin");

        #### ADD WORKFLOWS TO PROJECT
        my $workflows   =   $project->{workflows};
        my $counter =   1;
        foreach my $workflow ( @$workflows ) {
            $self->runCommand("cd $installdir/$version/conf/work/$projectname && $flow addWorkflow --project $projectname --wkfile $workflow.work --username $username");
            $counter++;
        }
        print "Completed loading workflows for project '$projectname'\n\n";
    }
}

method loadData ($installdir, $version) {
    print "Loading samples\n";
    $self->logDebug("installdir", $installdir);
    $self->logDebug("version", $version);

    my $basedir =   $self->conf()->getKey("agua", "INSTALLDIR");
    my $username    =   $self->username();
    $self->logDebug("basedir", $basedir);
    $self->logDebug("username", $username);

    my $table   =   "samples";

    ##### LOAD SAMPLES IDs
    #my $command     =   "$basedir/bin/sample/loadSamples.pl --username $username --project $project --workflow loadSamples --workflownumber 1 --file $installdir/$version/data/$table.tsv";
    #$self->logDebug("command", $command);
    #$self->runCommand($command);
    #
    ##### LOAD SAMPLES FILE NAMES AND SIZES
    #$command     =   "$basedir/bin/sample/loadTable.pl --table $table --tsvfile $installdir/$version/data/$table.tsv --sqlfile $installdir/$version/data/$table.sql";
    #$self->logDebug("command", $command);
    #$self->runCommand($command);

    print "Completed loading samples\n\n";
}



1;