package biobambam;
use Moose::Role;
use Method::Signatures::Simple;

method doInstall ($installdir, $version) {
	$self->logDebug("version", $version);
	$self->logDebug("installdir", $installdir);

	#$self->gitInstall($installdir, $version);
	$self->makeInstall($installdir, $version);	
	
	$self->confirmInstall($installdir, $version);
	
	return 1;
}

method makeInstall ($installdir, $version) {
	$self->logDebug("version", $version);
	$self->logDebug("installdir", $installdir);
	#####
	#####my $query = "SELECT version, installdir FROM package WHERE package='libmaus'";
	#####my $libmaus	=	$self->db()->queryhash($query);
	#####$self->logDebug("libmaus", $libmaus);
	#####my $libmausversion	=	$libmaus->{version};	
	#####my $libmausinstalldir	=	$libmaus->{installdir};	
	#####$self->logDebug("libmausversion", $libmausversion);
	#####$self->logDebug("libmausinstalldir", $libmausinstalldir);
	######### MAKE
	#####$self->runCommand("autoreconf -i -f");
	#####$self->runCommand("./configure --with-libmaus=$libmausinstalldir/$libmausversion --prefix=$installdir/$version");
	#####$self->runCommand("make");
	#####

	`mkdir -p $installdir` if not -d $installdir;
	
	my $processors = `cat /proc/cpuinfo | grep processor | wc -l`;
	$processors		=~	s/\s+$//;
	$processors-- if $processors > 1;
	
	#### CHANGE DIR
    $self->changeDir("$installdir");
	
	#### INSTALL SNAPPY
	$self->runCommand("wget -nv -O snappy-1.1.1.tar.gz https://snappy.googlecode.com/files/snappy-1.1.1.tar.gz");
	$self->runCommand("tar zxf snappy-1.1.1.tar.gz");
    $self->changeDir("$installdir/snappy-1.1.1");
	#$self->runCommand("cd snappy-1.1.1");
	$self->runCommand("./configure --prefix=/usr");
	$self->runCommand("make -j$processors;");
	$self->runCommand("make -j$processors install");

	##### INSTALL IO-LIB
    $self->changeDir("$installdir");
	$self->runCommand("wget -nv -O io_lib-1.13.4.tar.gz http://downloads.sourceforge.net/project/staden/io_lib/1.13.4/io_lib-1.13.4.tar.gz;");
	$self->runCommand("tar zxf io_lib-1.13.4.tar.gz;");
    $self->changeDir("$installdir/io_lib-1.13.4");
	$self->runCommand("./configure --prefix=/usr");
	$self->runCommand("make -j$processors;");
	$self->runCommand("make -j$processors install;");


#0.0.108-release-20140319092837
# https://github.com/gt1/libmaus/archive/0.0.108-release-20140319092837.tar.gz

	##### INSTALL LIBMAUS
    $self->changeDir("$installdir");
	$self->runCommand("wget -nv -O 0.0.108-release-20140319092837.tar.gz https://github.com/gt1/libmaus/archive/0.0.108-release-20140319092837.tar.gz;");
	$self->runCommand("tar zxf 0.0.108-release-20140319092837.tar.gz");
    $self->changeDir("$installdir/0.0.108-release-20140319092837.tar.gz");
	$self->runCommand("autoreconf -i -f");
	$self->runCommand(qq{export LD_LIBRARY_PATH=/usr/lib; export LDFLAGS="-Wl,-rpath=/usr/lib"; ./configure --prefix=/usr --with-snappy=/usr --with-io_lib=/usr});
	$self->runCommand("make -j$processors");
	$self->runCommand("make -j$processors install");

#	
#	##### INSTALL LIBMAUS
#    $self->changeDir("$installdir");
#	$self->runCommand("wget -nv -O libmaus-0.0.104-release-20140221093548.tar.gz https://github.com/gt1/libmaus/archive/0.0.104-release-20140221093548.tar.gz;");
#	$self->runCommand("tar zxf libmaus-0.0.104-release-20140221093548.tar.gz");
#    $self->changeDir("$installdir/libmaus-0.0.104-release-20140221093548");
#	$self->runCommand("autoreconf -i -f");
#	$self->runCommand(qq{export LD_LIBRARY_PATH=/usr/lib; export LDFLAGS="-Wl,-rpath=/usr/lib"; ./configure --prefix=/usr --with-snappy=/usr --with-io_lib=/usr});
#	$self->runCommand("make -j$processors");
#	$self->runCommand("make -j$processors install");
	
	##### INSTALL BIOBAMBAM
    $self->changeDir("$installdir");
	$self->runCommand("wget -nv -O 0.0.125-release-20140221093621.tar.gz https://github.com/gt1/biobambam/archive/0.0.125-release-20140221093621.tar.gz");
	$self->runCommand("tar zxf 0.0.125-release-20140221093621.tar.gz");
	$self->runCommand("mv biobambam-0.0.125-release-20140221093621 0.0.125");
    $self->changeDir("$installdir/0.0.125");
	$self->runCommand("autoreconf -i -f");
	$self->runCommand(qq{export LD_LIBRARY_PATH=/usr/lib; export LDFLAGS="-Wl,-rpath=/usr/lib"; ./configure --with-libmaus=/usr --prefix=/usr});
	$self->runCommand("make -j$processors");
	$self->runCommand("make -j$processors install");
	
	return 1;
}


1;
