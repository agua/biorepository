package sra;
use Moose::Role;
use Method::Signatures::Simple;

method doInstall ($installdir, $version) {
    $self->logDebug("version", $version);
    $self->logDebug("installdir", $installdir);
    $version = $self->version() if not defined $version;
    
    my $arch    =   $self->getArch();
    $self->logDebug("arch", $arch);
    
    if ( $arch eq "centos" ) {
        $self->opsinfo()->url("http://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/$version/sratoolkit.$version-centos_linux64.tar.gz");
        $self->opsinfo()->unzipped("sratoolkit.$version-centos_linux64");
    }
    elsif ( $arch eq "centos" ) {
        $self->opsinfo()->url("http://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/$version/sratoolkit.$version-ubuntu64.tar.gz");
        $self->opsinfo()->unzipped("sratoolkit.$version-centos_linux64");
    }
    elsif ( $arch eq "osc" ) {
        $self->opsinfo()->url("http://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/$version/sratoolkit.$version-mac64.tar.gz");
        $self->opsinfo()->unzipped("sratoolkit.$version-centos_linux64");
    }
    else {
        $self->logDebug("architecture not supported", $arch);
    }

    return 0 if not $self->zipInstall($installdir, $version);

    return $version;
}


1;