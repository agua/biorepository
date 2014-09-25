package sra;
use Moose::Role;
use Method::Signatures::Simple;

method doInstall ($installdir, $version) {
    $self->logDebug("version", $version);
    $self->logDebug("installdir", $installdir);
    $version = $self->version() if not defined $version;
    
    my $arch    =   $self->getArch();
    $self->logDebug("arch", $arch);

    my $unzipped   =   undef;
    my $targetfile =   undef;

    if ( $arch eq "ubuntu" ) {
        $unzipped   =   "sratoolkit.$version-ubuntu64";
        $targetfile =   "$unzipped.tar.gz";
    }
    elsif ( $arch eq "centos" ) {
        $unzipped    =   "sratoolkit.$version-centos_linux64";
        $targetfile =   "$unzipped.tar.gz";
    }
    elsif ( $arch eq "osx" ) {
        $unzipped    =   "sratoolkit.$version-mac64";
        $targetfile =   "$unzipped.tar.gz";
    }
    else {
        $self->logDebug("architecture not supported", $arch);
        print "Architecture not supported: $arch\n";
        exit;
    }

    $self->opsinfo()->url("http://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/$version/$targetfile");
    $self->opsinfo()->unzipped($unzipped);
    
    return 0 if not $self->zipInstall($installdir, $version);

    return $version;
}




1;