package dnaseqref;
use Moose::Role;
use Method::Signatures::Simple;

method doInstall ($installdir, $version) {
    $self->logDebug("version", $version);
    $self->logDebug("installdir", $installdir);
    $version = $self->version() if not defined $version;
    
    return 0 if not $self->loadReferences($installdir, $version);
    
    return $version;
}

method loadReferences ($installdir, $version) {
    print "Loading references\n";

    my $resources = $self->opsinfo()->resources();
    $self->logDebug("resources", $resources);

    my $urls = $resources->{urls};
    $installdir = $resources->{installdir};
    
    $version = $self->opsinfo()->version() if not defined $version;
    $self->logDebug("version", $version);
    
    #### CREATE DIR
    my $basedir     = "$installdir/$version";
    `mkdir -p $basedir` if not -d $basedir;
    
    #### DOWNLOAD AND UNZIP FILES
    foreach my $url ( @$urls ) {
        my $command = "cd $basedir; wget $url";
        $self->logDebug("command", $command);
        $self->runCommand($command);

        my ($file)  =   $url    =~ /^.+?\/([^\/]+)$/;
        $command = "cd $basedir; gunzip $file";
        $self->logDebug("command", $command);
        $self->runCommand($command);
    }

    print "Completed loading references\n";
}

method loadData ($installdir, $version) {
    print "Loading data\n";
    $self->logDebug("installdir", $installdir);
    $self->logDebug("version", $version);

    my $basedir =   $self->conf()->getKey("agua", "INSTALLDIR");
    my $project     =   $self->project();
    my $username    =   $self->username();
    $self->logDebug("basedir", $basedir);
    $self->logDebug("project", $project);
    $self->logDebug("username", $username);

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