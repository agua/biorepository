#!/usr/bin/perl -w

=head2
	
APPLICATION 	test.t

PURPOSE

	Test Perl module
	
NOTES

	1. RUN AS ROOT
	
	2. BEFORE RUNNING, SET ENVIRONMENT VARIABLES, E.G.:
	
		export installdir=/aguadev

=cut

use Test::More 	tests => 4;
use Getopt::Long;
use FindBin qw($Bin);
use lib "$Bin/..";
use lib "$Bin/lib";
BEGIN
{
    my $installdir = $ENV{'installdir'} || "/a";
    unshift(@INC, "$installdir/lib");
    unshift(@INC, "$installdir/t/common/lib");
    unshift(@INC, "$installdir/t/unit/lib");
}
use_ok('Conf::Yaml');
use_ok('Test::pythia');

#### CREATE OUTPUTS DIR
my $outputsdir = "$Bin/outputs";
`mkdir -p $outputsdir` if not -d $outputsdir;

#### SET CONF FILE
my $installdir  =   $ENV{'installdir'} || "/a";
my $configfile	=   "$installdir/conf/config.yaml";

##### SET $Bin
#$Bin =~ s/^.+\/bin/$installdir\/t\/bin/;

#### GET OPTIONS
my $logfile 	= "/tmp/aguatest.login.log";
my $log     	=   2;
my $printlog    =   5;
my $help;
GetOptions (
    'log=i'     => \$log,
    'printlog=i'    => \$printlog,
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
	log     	=>  2,
	printlog    =>  5    
);
isa_ok($conf, "Conf::Yaml", "conf");

my $object = new Test::pythia(
    conf        =>  $conf,
    logfile     =>  $logfile,
	log     	=>  $log,
	printlog    =>  $printlog
);
isa_ok($object, "Test::pythia", "object");

#### TESTS
$object->testSetFileInfoUrl();

#### SATISFY Agua::Common::logger::logError CALL TO EXITLABEL
no warnings;
EXITLABEL : {};
use warnings;

#:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#                                    SUBROUTINES
#:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

sub usage {
    print `perldoc $0`;
}

