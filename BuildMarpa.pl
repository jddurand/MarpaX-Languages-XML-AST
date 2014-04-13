#!env perl
use strict;
use diagnostics;
use File::Spec;
use Archive::Extract;
use Config::AutoConf;        # Just to make sure Config::AutoConf is loaded if Marpa needs it
use POSIX qw/EXIT_SUCCESS/;
use File::Find;
use File::Basename;
use Config;
use Cwd;
use File::Copy qw/move/;

my $targz = shift;

print "\n";
print "*** Extracting $targz\n";
print "\n";

my $ae = Archive::Extract->new(archive => $targz);
my $ok = $ae->extract() || die "Failed to extract $targz, $ae->error";
my $outdir = $ae->extract_path();

print "\n";
print "*** Building libmarpa in $outdir\n";
print "\n";

my $olddir = cwd();
chdir($outdir) || die "Failed to chdir to $outdir, $!";

system($^X, File::Spec->catfile(File::Spec->curdir, 'Build.PL'));
system(File::Spec->catfile(File::Spec->curdir, 'Build'));

chdir($olddir) || die "Failed to chdir to $olddir, $!";

my $wanteddir = File::Spec->catdir($outdir, 'libmarpa_build');
my $quotemetalib_ext=quotemeta($Config{lib_ext});
my $libmarpa = '';
find({wanted => \&wanted, no_chdir => 1}, $wanteddir);
die "Cannot find libmarpa$Config{lib_ext}" if (! $libmarpa);

my $copylibmarpa = File::Spec->catfile($olddir, basename($libmarpa));
print "\n";
print "*** Moving $libmarpa to $copylibmarpa\n";
print "\n";
move($libmarpa, $copylibmarpa) || die "Cannot move $libmarpa to $copylibmarpa, $!";

my $copydir = File::Spec->catfile($olddir, 'libmarpa_build');   # Pretend destination is a file instead of a dir, to avoir eventual dir suffix
print "\n";
print "*** Moving $wanteddir to $copydir\n";
print "\n";
move($wanteddir, $copydir) || die "Cannot move $wanteddir to $copydir, $!";

exit(EXIT_SUCCESS);

sub wanted {
    if (-f $_ && $_ =~ /$quotemetalib_ext$/) {
	$libmarpa = $_;
    }
}
