#!/usr/bin/perl -w

BEGIN {
    my $arch = $^O;
    if ( $arch eq "darwin" ) {
        my $installdir = $ENV{'installdir'} || "/a";
        unshift(@INC, "$installdir/extlib/osx/lib/perl5");
        unshift(@INC, "$installdir/extlib/osx/lib/perl5/x86_64-linux-gnu-thread-multi/");
        unshift(@INC, "$installdir/lib");
    }
    elsif ( $arch eq "linux" ) {
        my $installdir = $ENV{'installdir'} || "/a";
        unshift(@INC, "$installdir/extlib/linux/lib/perl5");
        unshift(@INC, "$installdir/extlib/linux/lib/perl5/x86_64-linux-gnu-thread-multi/");
        unshift(@INC, "$installdir/lib");
    }
    elsif ( $arch eq "MSWin32" ) {
        my $installdir = $ENV{'installdir'} || "/a";
        unshift(@INC, "$installdir/extlib/win/lib/perl5");
        unshift(@INC, "$installdir/extlib/win/lib/perl5/MSWin32-x86-multi-thread-64int/");
        unshift(@INC, "$installdir/lib");
    }
}

=head2
	
APPLICATION 	Deploy.t

PURPOSE

	Test Agua::Deploy module
	
NOTES

	1. RUN AS ROOT
	
	2. BEFORE RUNNING, SET ENVIRONMENT VARIABLES, E.G.:
	
		export installdir=/aguadev

=cut

use Test::More;
use Getopt::Long;
use FindBin qw($Bin);
use lib "$Bin/..";
use lib "$Bin/lib";

use_ok('Conf::Yaml');
use_ok('Agua::Ops');

#### SET CONF FILE
my $installdir  =   $ENV{'installdir'} || "/a";
my $configfile	=   "$installdir/conf/config.yaml";

#### SET $Bin
$Bin =~ s/^.+\/bin/$installdir\/t\/bin/;

#### GET OPTIONS
my $logfile 	= "/tmp/aguatest.login.log";
my $SHOWLOG     =   2;
my $PRINTLOG    =   5;
my $help;
GetOptions (
    'SHOWLOG=i'     => \$SHOWLOG,
    'PRINTLOG=i'    => \$PRINTLOG,
    'logfile=s'     => \$logfile,
    'help'          => \$help
) or die "No options specified. Try '--help'\n";
usage() if defined $help;

my $conf = Conf::Yaml->new(
    inputfile	=>	$configfile,
    backup	    =>	1,
    separator	=>	"\t",
    spacer	    =>	"\\s\+",
    logfile     =>  $logfile,
	SHOWLOG     =>  2,
	PRINTLOG    =>  5    
);
isa_ok($conf, "Conf::Yaml", "conf");

my $args	=	{
    conf        =>  $conf,
    logfile     =>  $logfile,
	SHOWLOG     =>  $SHOWLOG,
	PRINTLOG    =>  $PRINTLOG
};

my $object	=	Agua::Ops->new($args);
my $opsdir	=	"$Bin/..";
my $package	=	`ls $Bin/../*.pm`;
$package 	=~ 	s/^.+\///;
$package 	=~	s/\.pm\s*$//;
#print "package: $package\n";
$object->loadOpsModule($opsdir, $package);
$object->loadOpsInfo($opsdir, $package);
$object->opsdir($opsdir);

#### SET DATABASE HANDLE IF NOT DEFINED
$object->setDbObject();

my $installations = $object->installedVersions($package);
foreach my $installation ( @$installations ) {
	my $installdir	=	$installation->{installdir};
	my $version		=	$installation->{version};
	#print "installdir: $installdir\n";
	#print "version: $version\n";

	my $success = $object->confirmInstall($installdir, $version);
	#print "success: $success\n";

	ok($success == 1, "confirmed installation - $version, $installdir");
}

done_testing();

#### SATISFY Agua::Common::Logger::logError CALL TO EXITLABEL
no warnings;
EXITLABEL : {};
use warnings;

#:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#                                    SUBROUTINES
#:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

sub usage {
    print `perldoc $0`;
}

