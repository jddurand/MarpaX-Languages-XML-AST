package inc::MyDistMakeMaker;
use Moose;
use Config;
use Marpa::R2 2.084000;   # So that we are sure Marpa could build here
use Config::AutoConf;     # Just to make sure Config::AutoConf is loaded if Marpa needs it

extends 'Dist::Zilla::Plugin::MakeMaker::Awesome';

override _build_WriteMakefile_args => sub {
    +{
	# Add MYEXTLIB => to WriteMakefile() args
	%{ super() },
	MYEXTLIB => 'libmarpa' . $Config{lib_ext},
    }
};

override _build_MakeFile_PL_template => sub {
    my ($self) = @_;
    my $template = super();
 
    $template .= <<'TEMPLATE';
package MY;
use Config;

sub postamble {
    my $self = shift;
    my @ret = (
	$self->SUPER::postamble,
	'libmarpa' . $Config{lib_ext} . ' :',
	"\t" . '$(PERLRUN) BuildMarpa.pl Marpa-R2-2.084000.tar.gz',
	''
	);
    return join "\n", @ret;
}
TEMPLATE
 
    return $template;
};
