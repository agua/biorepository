package pcap;
use Moose::Role;
use Method::Signatures::Simple;

method doInstall ($installdir, $version) {
    $self->logDebug("version", $version);
    $self->logDebug("installdir", $installdir);
    $version = $self->version() if not defined $version;
    
    return 0 if not $self->gitInstall($installdir, $version);
    return 0 if not $self->makeInstall($installdir, $version);
    return 0 if not $self->copyBwa($installdir, $version);

    return 1;
}

method makeInstall ($installdir, $version) {
    my $arch    =   $self->getArch();
    $self->logDebug("arch", $arch);
    
    if ( $arch eq "ubuntu" ) {
        $self->installPackage("dh-autoreconf");
        $self->installPackage("libgd-gd2-perl");
        $self->installPackage("libgd2-xpm-dev");
    }
    elsif ( $arch eq "centos" ) {
        $self->installPackage("autoconf");
        $self->installPackage("gd gd-devel");
    }
    else {
        print "Architecture not supported: $arch\n";
        $self->logDebug("arch not supported: $arch");
        exit;
    }
    
    #### REPLACE LINE IN bwa Makefile TO AVOID ERROR 'SSE2 instruction set not enabled'
    my $makefile    =   "$installdir/$version/install_tmp/bwa/Makefile";
    $self->logDebug("makefile", $makefile);
    
    my $replace     =   "perl -pi -e 's/^CFLAGS.+\$/CFLAGS=         -g -Wall -O2 -Wno-unused-function -msse -mmmx -msse2/' $makefile";
    $self->logDebug("replace", $replace);

    my $command     =   "cd $installdir/$version && $installdir/$version/setup.sh $installdir/apps-$version";
    $self->runCommand($command);
    
    return 1;
}

method copyBwa ($installdir, $version) {
    $self->logDebug("installdir", $installdir);

	#### GET OPSDIR
	my $opsdir = $self->opsdir(); 
	$self->logDebug("opsdir", $opsdir);

    $self->runCommand("mv $installdir/$version/bin/bwa_mem.pl $installdir/$version/bin/bwa_mem.pl.bkp");
    $self->runCommand("sudo cp $opsdir/templates/bwa_mem.pl $installdir/$version/bin/bwa_mem.pl");

    return 1;
}

1;