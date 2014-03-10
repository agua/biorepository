#!/usr/bin/perl -w

=head2
	
APPLICATION 	Deploy.t

PURPOSE

	Test Agua::Deploy module
	
NOTES

	1. RUN AS ROOT
	
	2. BEFORE RUNNING, SET ENVIRONMENT VARIABLES, E.G.:
	
		export installdir=/aguadev

=cut

use Test::More 	tests => 2102;
use Getopt::Long;
use FindBin qw($Bin);
use lib "$Bin/..";
use lib "$Bin/lib";
BEGIN
{
    my $installdir = $ENV{'installdir'} || "/agua";
    unshift(@INC, "$installdir/lib");
    unshift(@INC, "$installdir/t/lib");
}

#### CREATE OUTPUTS DIR
my $outputsdir = "$Bin/outputs";
`mkdir -p $outputsdir` if not -d $outputsdir;


use_ok('Conf::Agua');
use_ok('Test::emboss');


#### SET CONF FILE
my $installdir  =   $ENV{'installdir'} || "/agua";
my $configfile	=   "$installdir/conf/default.conf";

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

my $conf = Conf::Agua->new(
    inputfile	=>	$configfile,
    backup	    =>	1,
    separator	=>	"\t",
    spacer	    =>	"\\s\+",
    logfile     =>  $logfile,
	SHOWLOG     =>  2,
	PRINTLOG    =>  5    
);
isa_ok($conf, "Conf::Agua", "conf");

my $object = new Test::emboss(
    conf        =>  $conf,
    logfile     =>  $logfile,
	SHOWLOG     =>  $SHOWLOG,
	PRINTLOG    =>  $PRINTLOG
);
isa_ok($object, "Test::emboss", "object");

#### TESTS
$object->testParseEmbossEntry();
$object->testParseEmbossSection();
$object->testParseEmboss();
$object->testLoadAppFiles();

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

