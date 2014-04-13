#!env perl
use File::Spec;
use Archive::Extract;
use Config::AutoConf;        # Just to make sure Config::AutoConf is loaded if Marpa needs it
use POSIX /EXIT_SUCCESS/;

my ($targz, $workdir) = @ARGV;

my $ae = Archive::Extract->new(archive => $targz);
my $ok = $ae->extract(to => $workdir) || die "Failed to extract $targz, $ae->error";

my $olddir = chdir($workdir) || die "Failed to chdir to $workdir, $!";

system($^X, 'Build.PL', 'make') || die "Failed to do perl Build.PL make, $?";

chdir($olddir) || die "Failed to chdir to $olddir, $!";

open(PHONY, '>', 'marpa.PHONY') || die "Failed to open marpa.PHONY, $!";
close(PHONY) || warn "Failed to close marpa.PHONY, $!";

exit(EXIT_SUCCESS);
