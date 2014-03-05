package gatk;
use Moose::Role;
use Method::Signatures::Simple;

has 'installdir'=> ( isa => 'Str|Undef', is => 'rw', required	=>	0	);
has 'version'	=> ( isa => 'Str|Undef', is => 'rw', required	=>	0	);
has 'repotype'	=> ( isa => 'Str|Undef', is => 'rw', default	=> 'github'	);
has 'mountpoint'=> ( isa => 'Str|Undef', is => 'rw', required	=>	0	);

####///}}}}

method doInstall ($installdir, $version) {
	$self->logDebug("version", $version);
	$self->logDebug("installdir", $installdir);

	$version 	= 	$self->gitInstall($installdir, $version);
	
	$self->antInstall();
	
	$self->makeInstall("$installdir/$version", $version);
	$self->confirmInstall($installdir, $version);
	
	return $version;
}

method antInstall ($installdir, $version) {
	my $arch = $self->getArch();
	$self->runCommand("apt-get -y ant install") if $arch eq "ubuntu";
	$self->runCommand("yum -y ant install") if $arch eq "centos";	
}


1;