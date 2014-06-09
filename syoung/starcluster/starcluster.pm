package starcluster;
use Moose::Role;
use Method::Signatures::Simple;

has 'installdir'=> ( isa => 'Str|Undef', is => 'rw', required	=>	0	);
has 'version'	=> ( isa => 'Str|Undef', is => 'rw', required	=>	0	);
has 'repotype'	=> ( isa => 'Str|Undef', is => 'rw', default	=> 'github'	);

####///}}}}

method preInstall {
	$self->logDebug("");

	$self->updateReport(["Began preInstall"]);

	#### SET DEFAULTS
    $self->owner("agua") if not defined $self->owner();
	$self->repository("StarCluster") if not defined $self->repository();
	$self->package("StarCluster") if not defined $self->package();
	$self->repotype("github") if not defined $self->repotype();
	$self->privacy("public");

	#### SET DATABASE HANDLE
	$self->setDbObject() if not defined $self->db();

	#### CHECK INPUTS
	$self->checkInputs();
	
	$self->updateReport(["Completed preInstall"]);

	return;
}

method postInstall ($installdir, $version) {
	$self->logDebug("installdir", $installdir);
	$self->logDebug("version", $version);

	my $username 	= 	$self->username();
	my $package		=	$self->package();
	my $opsdir		=	$self->opsdir();
	$self->logDebug("installdir", $installdir);

	$self->updateReport(["Began postInstall"]);

	#### GET STARCLUSTER VERSION
	my $versionfile = "$installdir/STARCLUSTER-VERSION";
	$version = `cat $versionfile`;
	$version =~ s/\s+$//;
	$self->logDebug("FROM VERSION FILE version", $version);

	#### INSTALL (ASSUMES PYTHON 2.6)	
	$self->updateReport(["Installing StarCluster version $version"]);
	$self->runCommand("python setup.py install");

	#### SET STARCLUSTER BINARY LOCATION IN CONFIG
	my $binary = "$installdir/bin/starcluster";
	$self->updateReport(["Setting StarCluster binary in config file: $binary"]);
	$self->conf()->setKey("agua", "STARCLUSTER", $binary);
	
	return;
}


1;