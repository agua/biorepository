package minecraft;
use Moose::Role;
use Method::Signatures::Simple;

method doInstall ($installdir, $version) {
    $self->logDebug("installdir", $installdir);
    $self->logDebug("version", $version);
    $version = $self->version() if not defined $version;
   
    return 0 if not $self->downloadInstall($installdir, $version);
   
    return 0 if not $self->scriptInstall($installdir, $version);
   
	$self->confirmInstall($installdir, $version);

    return $version;
}

method scriptInstall ($installdir, $version) {
    $self->logDebug("installdir", $installdir);
    $self->logDebug("version", $version);

    my $basedir =   $self->conf()->getKey("agua", "INSTALLDIR");
    my $javaversion = $self->getDependencyVersion("java");
    $self->logDebug("javaversion", $javaversion);
    
    #### PRINT SCRIPT
    my $script = qq{#!/bin/sh

$basedir/apps/java/$javaversion/bin/java -Xmx1024M -Xms512M -jar $installdir/$version/Minecraft.jar
};
    my $scriptfile = "/usr/bin/minecraft";
    $self->printToFile($scriptfile, $script);
    
    `chmod 755 $scriptfile`;
}

method getDependencyVersion ($package) {
    $self->logDebug("package", $package);
    
    my $dependencies = $self->opsinfo()->dependencies();
    $self->logDebug("dependencies", $dependencies);

    foreach my $dependency ( @$dependencies ) {
        return $dependency->{version} if $dependency->{package} eq $package;
    }
    
    return undef;
}

1;