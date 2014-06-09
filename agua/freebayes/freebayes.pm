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
	
	return 1;
}

method doInstall ($installdir, $version) {
	$self->logDebug("version", $version);
	$self->logDebug("installdir", $installdir);

	return 0 if not $self->gitInstall($installdir, $version);
	
	return 0 if not $self->makeInstall($installdir, $version);

	return 0 if not $self->confirmInstall($installdir, $version);
	
	return 1;
}


1;