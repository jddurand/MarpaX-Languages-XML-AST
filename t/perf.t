#!perl
use strict;
use warnings FATAL => 'all';
use Test::More;
use IO::String;
use File::Temp qw/tempfile/;
use Benchmark qw/:all/;

BEGIN {
    use_ok( 'MarpaX::Languages::XML::AST::StreamIn' ) || print "Bail out!\n";
}

#
# FILEHANDLE test
#
my $filename = shift;
my $fh;
if (! $filename) {
  ($fh, $filename) = tempfile();
  print STDERR "Filling $filename\n";
  foreach (0..1*1024*1024) {
    $fh->write(chr($_ % 255));
  }
  $fh->close();
}
print STDERR "Reading $filename\n";
cmpthese(3, {
               'StreamIn fetchc' => sub {
                 open(FILE, '<', $filename) || die "Cannot open $filename, $!";
                 my $stream = MarpaX::Languages::XML::AST::StreamIn->new(input => \*FILE, length => -s $filename);
                 my $pos = 0;
                 while (1) {
                   my $c = $stream->fetchc($pos++);
                   last if (! defined($c));
                 }
                 print STDERR "Streamin stopped at position $pos\n";
                 close(FILE) || warn "Cannot close $filename, $!";
               },
               'StreamIn fetchb one buffer' => sub {
                 open(FILE, '<', $filename) || die "Cannot open $filename, $!";
                 my $stream = MarpaX::Languages::XML::AST::StreamIn->new(input => \*FILE, length => -s $filename);
 		my $n;
 		my $buf;
 		my $realpos = 0;
 		while ($buf = $stream->fetchb($n++)) {
 		    my $pos = 0;
 		    my $length = length($buf);
 		    while ($pos < $length) {
 			$realpos++;
 			my $c = substr($buf, $pos++, 1);
 		    }
 		}
                 print STDERR "Streamin stopped at position $realpos\n";
                 close(FILE) || warn "Cannot close $filename, $!";
               },
              'StreamIn fetchb 1024 buffers' => sub {
                open(FILE, '<', $filename) || die "Cannot open $filename, $!";
                my $stream = MarpaX::Languages::XML::AST::StreamIn->new(input => \*FILE, length => 1024);
		my $buf;
		my $realpos = 0;
		while ($buf = $stream->getb()) {
		    my $pos = 0;
		    my $length = length($buf);
		    while ($pos < $length) {
			$realpos++;
			my $c = substr($buf, $pos++, 1);
		    }
		}
                print STDERR "Streamin stopped at position $realpos\n";
                close(FILE) || warn "Cannot close $filename, $!";
              },
              'built-in' => sub {
                use File::Slurp qw/read_file/;
                my $data = read_file($filename);
                my $pos = 0;
                my $length = length($data);
                while ($pos < $length) {
                  my $c = substr($data, $pos++, 1);
                }
                print STDERR "built-in stopped at position $pos\n";
              }
             }
);

done_testing(1);

__DATA__
0123
