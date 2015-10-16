package s3lib;
use Moose::Role;
use Method::Signatures::Simple;

method doInstall ($installdir, $version) {
	$self->logDebug("version", $version);
	$self->logDebug("installdir", $installdir);
	$version = $self->version() if not defined $version;

	$version = $self->gitInstall($installdir, $version);

	$self->installDependencies();
	
	$self->confirmInstall($installdir, $version);
	
	return $version;
}

method installDependencies {
	my $arch = $self->getArch();
	$self->logDebug("arch", $arch);

	if ( $arch eq "ubuntu" ) {
		my $commands = [ "apt-get install python-pip -y"];
		foreach my $command ( @$commands ) {
			my ($out, $err) = $self->runCommand($command);
			$self->logDebug("out", $out);
			$self->logDebug("err", $err);
		}
	}
	elsif ( $arch eq "centos" ) {
		my $commands = [ "yum install python-pip"];
		foreach my $command ( @$commands ) {
			my ($out, $err) = $self->runCommand($command);
			$self->logDebug("out", $out);
			$self->logDebug("err", $err);
		}
	}
	else {
		print "Architecture '$arch' is not supported yet. Please install pip manually\n";
	}

	my $commands = ["pip install boto", "pip install filechunkio"];
	foreach my $command ( @$commands ) {
		#$self->logDebug("command", $command);
		my ($out, $err) = $self->runCommand($command);
		$self->logDebug("out", $out);
		$self->logDebug("err", $err);
	}
}

1;