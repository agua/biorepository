package dnaseq;
use Moose::Role;
use Method::Signatures::Simple;

method doInstall ($installdir, $version) {
    $self->logDebug("version", $version);
    $self->logDebug("installdir", $installdir);
    $version = $self->version() if not defined $version;
    
    return 0 if not $self->gitInstall($installdir, $version);

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
    
    return 0 if not $self->loadSamples($installdir, $version);
    
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
                "All"
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
        my $projectdir = lc($projectname);
        foreach my $workflow ( @$workflows ) {
            $self->runCommand("cd $installdir/$version/conf/work/$projectdir && $flow addWorkflow --project $projectname --wkfile $workflow.work --username $username");
            $counter++;
        }
        print "Completed loading workflows for project '$projectname'\n\n";
    }
}

method loadSamples ($installdir, $version) {
    print "Loading samples\n";
    $self->logDebug("installdir", $installdir);
    $self->logDebug("version", $version);

    my $basedir =   $self->conf()->getKey("agua", "INSTALLDIR");
    my $username    =   $self->username();
    $self->logDebug("basedir", $basedir);
    $self->logDebug("username", $username);

    my $tables   =   {
        clinical97    => [
            {
                project => "QC",
                workflow => "All"
            }
        ]
    };
    foreach my $table ( keys %$tables ) {
        $self->logDebug("table", $table);
        
        my $projects = $tables->{$table};
        foreach my $project ( @$projects ) {
            my $projectname = $project->{project};
            my $workflowname = $project->{workflow};
            
            #### LOAD
            my $command     =   "$basedir/bin/sample/loadSamples.pl --username $username --project $projectname --table $table --tsvfile $installdir/$version/data/tsv/$table.tsv --sqlfile $installdir/$version/data/sql/$table.sql";
            $self->logDebug("command", $command);
            $self->runCommand($command);    
        }
    }

    print "Completed loading samples\n\n";
}

method loadData ($installdir, $version) {
    print "Loading samples\n";
    $self->logDebug("installdir", $installdir);
    $self->logDebug("version", $version);

    my $basedir =   $self->conf()->getKey("agua", "INSTALLDIR");
    my $username    =   $self->username();
    $self->logDebug("basedir", $basedir);
    $self->logDebug("username", $username);

    my $database    =   $self->conf()->getKey("database", "DATABASE");
    my $tables   =   [
        "cluster",
        "instancetype"
    ];
    foreach my $table ( @$tables ) {
        $self->logDebug("table", $table);
        my $tsvfile = "$installdir/$version/data/tsv/$table.tsv";
        
        #### LOAD SAMPLES
        my $command     =   "$basedir/bin/scripts/loadTable.pl --db $database --table $table --tsvfile $installdir/$version/data/tsv/$table.tsv";
        $self->logDebug("command", $command);
        $self->runCommand($command);
    }

    print "Completed loading data\n\n";
}


1;