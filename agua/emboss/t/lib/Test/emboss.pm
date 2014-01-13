use Moose::Util::TypeConstraints;
use MooseX::Declare;
use Method::Signatures::Modifiers;

class Test::emboss extends Agua::Ops with (emboss, Agua::Common::Logger, Agua::Common::Util, Test::Agua::Common::Database, Test::Agua::Common::Util, Agua::Common::Database) {

use Data::Dumper;

use Test::More;
use FindBin qw($Bin);
use JSON;

# STRINGS
has 'dumpfile'		=>  ( isa => 'Str|Undef', is => 'rw' );
has 'username'		=>  ( isa => 'Str|Undef', is => 'rw' );
has 'password'		=>  ( isa => 'Str|Undef', is => 'rw' );
has 'database'		=>  ( isa => 'Str|Undef', is => 'rw' );
has 'logfile'		=>  ( isa => 'Str|Undef', is => 'rw' );
has 'requestor'		=> 	( isa => 'Str|Undef', is => 'rw' );

# OBJECTS
has 'db'		=> ( isa => 'Agua::DBase::MySQL', is => 'rw', required => 0 );
has 'conf' 	=> (
	is 		=>	'rw',
	isa 	=> 	'Conf::Agua|Undef'
);

#####/////}}}}}

method BUILD ($args) {
	if ( defined $args ) {
		foreach my $arg ( $args ) {
			$self->$arg($args->{$arg}) if $self->can($arg);
		}
	}
	$self->logDebug("args", $args);
}

method testParseEmbossEntry {
	diag("parseEmbossEntry");
	my $tests = [
		{
			test	=>	"nodefault",
			file	=>	"$Bin/inputs/embossentry/nodefault",
			expected=>	"$Bin/inputs/embossentry/nodefault.expected"
		}
		,
		{
			test	=>	"default",
			file	=>	"$Bin/inputs/embossentry/default",
			expected=>	"$Bin/inputs/embossentry/default.expected"
		}
		,
		{
			test	=>	"oversize",
			file	=>	"$Bin/inputs/embossentry/oversize",
			expected=>	"$Bin/inputs/embossentry/oversize.expected"
		}
		,
		{
			test	=>	"oversize2",
			file	=>	"$Bin/inputs/embossentry/oversize2",
			expected=>	"$Bin/inputs/embossentry/oversize2.expected"
		}
	];
	
	#### LOAD PARAM CATEGORY VS VALUETYPE
	my $paramtypes = $self->loadParamTypes("$Bin/../tsv/paramtypes.tsv");
	
	foreach my $test ( @$tests ) {
		my $inputfile 	= 	$test->{file};
		my $entry 	=	$self->getFileContents($inputfile);
		$self->logDebug("entry", $entry);
	
		my $parameter	=	$self->parseEmbossEntry($entry, $paramtypes);
		$self->logDebug("parameter", $parameter);
		
		my $expectedfile 	= 	$test->{expected};
		my $json			=	$self->getFileContents($expectedfile);
		my $expected		=	$self->jsonparser()->decode($json);
		$self->logDebug("expected", $expected);
		
		is_deeply($parameter, $expected, $test->{test});
	}
}

method testParseEmbossSection {
	diag("parseEmbossSection");
	my $tests = [
		{
			test	=>	"basic",
			options	=>	{	discretion	=>	"required"	},
			file	=>	"$Bin/inputs/embosssection/basic",
			expected=>	"$Bin/inputs/embosssection/basic.expected"
		}
		,
		{
			test	=>	"asterisk",
			file	=>	"$Bin/inputs/embosssection/asterisk",
			expected=>	"$Bin/inputs/embosssection/asterisk.expected"
		}
	];
	
	#### LOAD PARAM CATEGORY VS VALUETYPE
	my $paramtypes = $self->loadParamTypes("$Bin/../tsv/paramtypes.tsv");

	foreach my $test ( @$tests ) {
		my $inputfile 	= 	$test->{file};
		my $section 	=	$self->getFileContents($inputfile);
		$self->logDebug("section", $section);
	
		my $options = $test->{options};
		my $parameters	=	$self->parseEmbossSection($section, $options, $paramtypes);
		$self->logDebug("parameters", $parameters);
		
		my $expectedfile 	= 	$test->{expected};
		my $json			=	$self->getFileContents($expectedfile);
		my $expected		=	$self->jsonparser()->decode($json);
		$self->logDebug("expected", $expected);
		
		is_deeply($parameters, $expected, $test->{test});
	}
}

method testParseEmboss {
	diag("parseEmboss");
	my $tests = [
		{
			test		=>	"transeq",
			file		=>	"$Bin/inputs/emboss/transeq.help",
			expected	=>	"$Bin/inputs/emboss/transeq.expected",
			appexpected	=>	"$Bin/inputs/emboss/transeq.app.expected"
		}
		,
		{
			test		=>	"whichdb",
			file		=>	"$Bin/inputs/emboss/whichdb.help",
			expected	=>	"$Bin/inputs/emboss/whichdb.expected",
			appexpected	=>	"$Bin/inputs/emboss/whichdb.app.expected"
		}
		,
		{
			test		=>	"psiphi",
			file		=>	"$Bin/inputs/emboss/psiphi.help",
			expected	=>	"$Bin/inputs/emboss/psiphi.expected",
			appexpected	=>	"$Bin/inputs/emboss/psiphi.app.expected"
		}
	];
	
	#### LOAD PARAM CATEGORY VS VALUETYPE
	my $paramtypes = $self->loadParamTypes("$Bin/../tsv/paramtypes.tsv");
	
	foreach my $test ( @$tests ) {
		my $inputfile 	= 	$test->{file};
		my $help 		=	$self->getFileContents($inputfile);
		$self->logDebug("help", $help);

		my ($appname)	=	$inputfile =~ /([^\.^\/]+)\.[^\/]+$/;
		$self->logDebug("appname", $appname);
		
		my $options = $test->{options};
		my $app	=	{
			name	=>	$appname
		};

		my $parameters;
		($app, $parameters)	=	$self->parseEmboss($help, $app, $paramtypes);
		$self->logDebug("parameters", $parameters);
		$self->logDebug("app", $app);
		
		my $expectedfile 	= 	$test->{expected};
		my $appexpectedfile = 	$test->{appexpected};
		my $json			=	$self->getFileContents($expectedfile);
		my $expected		=	$self->jsonparser()->decode($json);
		$self->logDebug("expected", $expected);
		$json			=	$self->getFileContents($appexpectedfile);
		my $appexpected		=	$self->jsonparser()->decode($json);
		$self->logDebug("appexpected", $appexpected);
		
		is_deeply($parameters, $expected, "$test->{test} parameters");
		is_deeply($app, $appexpected, "$test->{test} app");
	}
}





method testLoadAppFiles {
	my $username 	= 	"admin";
	my $package 	=	"emboss";
	my $installdir	=	$self->installdir();
	$installdir		=	$ENV{'installdir'} if not defined $installdir;
	$installdir		.=	"/apps/emboss";
	my $opsdir 		=	"$Bin/..";
	my $appdir 		= 	"$opsdir/apps";
	$self->logDebug("installdir", $installdir);
	
	#### LOAD --no-data DATABASE DUMP 
	my $dumpfile	=	"$Bin/inputs/loadappfiles/agua.dump";
	$self->dumpfile($dumpfile);
	$self->setUpTestDatabase();

	#$self->setTestDbh();
	
	#### LOAD APP FILES
	$self->logDebug("Doing loadAppFiles");
	$self->loadAppFiles($username, $package, $installdir, $appdir);
	$self->logDebug("Completed loadAppFiles");

	#### TSV FILES
	my $appfile			=	"$Bin/inputs/loadappfiles/app.tsv";
	my $parameterfile	=	"$Bin/inputs/loadappfiles/parameter.tsv";
	
	#### VERIFY
	diag("Testing loaded apps");
	$self->checkTsvLines("app", $appfile, "loadAppFiles    app values");
	diag("Testing loaded parameters");
	$self->checkTsvLines("parameter", $parameterfile, "loadAppFiles    parameter values");
}

#### UTIL
method setJsonParser {
	my $jsonparser = JSON->new->allow_nonref;
	$self->jsonparser($jsonparser);
	
	return $self->jsonparser();
}

}	####	Agua::Login::Common
