package rabbitmqadmin;
use Moose::Role;
use Method::Signatures::Simple;

method doInstall ($installdir, $version) {
    $self->logDebug("version", $version);
    $self->logDebug("installdir", $installdir);
    $version = $self->version() if not defined $version;    

    #### 1. INSTALL PLUGIN rabbitmq_management
    $self->runCommand("rabbitmq-plugins enable rabbitmq_management");

    #### 2. RESTART RABBITMQ
    $self->runCommand("service rabbitmq-server restart");

	#### 3. COPY TO /usr/bin
    my $opsdir = $self->opsdir();
    if ( not defined $opsdir ) {
    my $opsfile = $self->opsfile();
    $self->logDebug("opsfile", $opsfile);
 	($opsdir) = $opsfile =~ /^(.+?)\/[^\/]+$/;
    }
    $self->logDebug("opsdir", $opsdir);
	my $filepath = "$opsdir/rabbitmqadmin.txt";
    $self->logDebug("filepath", $filepath);
    $self->runCommand("cp $filepath /usr/bin/rabbitmqadmin");
    $self->runCommand("chmod 755 /usr/bin/rabbitmqadmin");
    
    return $version;
}


1;