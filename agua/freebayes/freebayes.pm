package freebayes;
use Moose::Role;
use Method::Signatures::Simple;

has 'installdir'=> ( isa => 'Str|Undef', is => 'rw', required	=>	0	);
has 'version'	=> ( isa => 'Str|Undef', is => 'rw', required	=>	0	);
has 'repotype'	=> ( isa => 'Str|Undef', is => 'rw', default	=> 'github'	);
has 'mountpoint'=> ( isa => 'Str|Undef', is => 'rw', required	=>	0	);

####///}}}}

method preInstall {
	$self->logDebug("");

	#### CHECK INPUTS
	$self->checkInputs();
	
	$self->updateReport(["Completed preInstall"]);

	$self->login($self->opsinfo()->login());
	$self->logDebug("self->opsinfo()->login()", $self->opsinfo()->login());
	
	return;
}

method doInstall ($installdir, $version) {
	$self->logDebug("version", $version);
	$self->logDebug("installdir", $installdir);

	print "Git install failed\n" and exit if not $self->gitInstall($installdir, $version);

	$self->makeInstall($installdir, $version);

	$self->confirmInstall($installdir, $version);
	
	return $version;
}


1;