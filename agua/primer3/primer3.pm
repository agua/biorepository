package primer3;
use Moose::Role;
use Method::Signatures::Simple;

method doInstall ($installdir, $version) {
    $self->logDebug("version", $version);
    $self->logDebug("installdir", $installdir);
    $version = $self->version() if not defined $version;
    
    return 0 if not $self->zipInstall($installdir, $version);

    return 0 if not $self->makeInstall($installdir, $version);

    return $version;
}

method makeInstall ($installdir, $version) {
    print "Loading data\n";
    $self->logDebug("installdir", $installdir);
    $self->logDebug("version", $version);

	#### CHANGE DIR
    $self->changeDir("$installdir/$version/src");

	#### MAKE
	my ($out, $err) = $self->runCommand("make all");
	$self->logDebug("out", $out);
	$self->logDebug("err", $err);
	#($out, $err) = $self->runCommand("make test &> test.log");
	#$self->logDebug("out", $out);
	#$self->logDebug("err", $err);
    
    #### COPY EXECUTABLES
    my $source = "$installdir/$version/src";
    my $target = "$installdir/$version/bin";
	$self->runCommand("mkdir $target");
    my $files = [
        "primer3_core",
        "ntdpal",
        "ntthal",
        "oligotm",
        "long_seq_tm_test"
    ];
    foreach my $file ( @$files ) {
    	$self->runCommand("cp $source/$file $target/$file");
    }

}



1;