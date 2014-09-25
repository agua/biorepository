package pancancer;
use Moose::Role;
use Method::Signatures::Simple;

method doInstall ($installdir, $version) {
    $self->logDebug("version", $version);
    $self->logDebug("installdir", $installdir);
    $version = $self->version() if not defined $version;
    
    return 0 if not $self->gitInstall($installdir, $version);
    return 0 if not $self->loadWorkflow($installdir, $version);
    
    return 1;
}

method loadWorkflow ($installdir, $version) {
    # Delete old project entry if exists
    $self->runCommand("cd $installdir/$version/conf && /agua/bin/cli/flow.pl ./PanCancer.proj delete --username syoung");
    
    # Add project file to database
    $self->runCommand("cd $installdir/$version/conf && /agua/bin/cli/flow.pl ./PanCancer.proj save --username syoung");
    
    # Add workflows to project (and save to database)
    $self->runCommand("cd $installdir/$version/conf && /agua/bin/cli/flow.pl PanCancer.proj saveWorkflow --wkfile 1-Download.work --username syoung");
    $self->runCommand("cd $installdir/$version/conf && /agua/bin/cli/flow.pl PanCancer.proj saveWorkflow --wkfile 2-Split.work --username syoung");
    $self->runCommand("cd $installdir/$version/conf && /agua/bin/cli/flow.pl PanCancer.proj saveWorkflow --wkfile 3-Align.work --username syoung");

    return 1;
}


1;