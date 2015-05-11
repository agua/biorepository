use Moose::Util::TypeConstraints;
use MooseX::Declare;
use Method::Signatures::Modifiers;

class Test::pythia extends Agua::Ops with (pythia, Logger, Test::Agua::Common::Database, Test::Agua::Common::Util, Agua::Common::Database) {

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
has 'opsinfo'	=> ( isa => 'Agua::OpsInfo', is => 'rw', required	=>	0	);

# OBJECTS
has 'db'		=> ( isa => 'Agua::DBase::MySQL', is => 'rw', required => 0 );
has 'conf' 	=> (
	is 		=>	'rw',
	isa 	=> 	'Conf::Yaml|Undef'
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

method testSetFileInfoUrl {
	diag("setFileInfoUrl");
	print "self->log()", $self->log(), "\n";
	
	my $tests = [
		{
			name	=>	"url 1.0.1",
			version	=>	"1.0.1",
			installdir=>	"/a/apps/pythia",
			fileurl	=>	"http://sourceforge.net/projects/pythia/files/pythia/\$versiondir/pythia-\$version.tar.gz/download",
			expected=>	"http://sourceforge.net/projects/pythia/files/pythia/pythia_1_0_1/pythia-1.0.1.tar.gz/download"
		}
	];
	
	foreach my $test ( @$tests ) {
		print "test: $test->{name}\n";
		my $name 	= 	$test->{name};
		my $installdir 	= 	$test->{installdir};
		my $version 	= 	$test->{version};
		my $fileurl 	= 	$test->{fileurl};
		my $expected 	= 	$test->{expected};

		$self->logDebug("name", $name);
		$self->logDebug("installdir", $installdir);
		$self->logDebug("version", $version);
		$self->logDebug("fileurl", $fileurl);
		$self->logDebug("expected", $expected);
		
		$self->opsinfo(new Agua::OpsInfo());
		$self->opsinfo()->url($fileurl);
		$self->logDebug("self->opsinfo()->url()", $self->opsinfo()->url());
		

		my $result	=	$self->setFileInfoUrl($installdir, $version);
		$self->logDebug("result", $result);

		is_deeply($result, $expected, $test->{test});
	}
}

}	