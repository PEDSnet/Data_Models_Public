#!/usr/bin/env perl

use strict;
use warnings;
use 5.014;

our $VERSION = '1.00';

use Digest::SHA;
use File::Basename qw(basename);

use Getopt::Long qw(GetOptions);

sub cdm_default {
  my $vocab = (grep { /vocabulary\.[ct]sv$/i } @ARGV)[0];
  my $cdm;

  open my $fh, '<', $vocab;
  while (<$fh>) {
    next unless /PEDSnet/;
    ($cdm) = /.+,([0-9.]+)/;
    last if $cdm;
  }
  close $fh;
  $cdm;
}

sub org_default { 'PEDSnet' }

sub commit_default {
  my $hash = `git log --pretty=\%H -n 1`;
  chomp $hash;
  $hash;
}

GetOptions('help' => \my $help,
	   'cdm_version=n' => \my $cdm,
	   'organization=s' => \my $org,
	   'commit_hash=s' => \my $commit);

die "Try perldoc $0 for usage info" if $help or !@ARGV;

$cdm = cdm_default() unless $cdm;
$commit = commit_default() unless $commit;
$org = org_default() unless $org;

my $sha = Digest::SHA->new(256);

say join ',', map { qq["$_"] }
  qw/organization filename checksum cdm table etl /;

foreach my $path (@ARGV) {
  my $file = basename($path);
  my $table = $file;
  $table =~ s/\.[ct]sv$//i;
  $sha->addfile($path);
  chomp(my $sum = $sha->hexdigest);

  say join ',', map { '"' . s/"/""/gr . '"'; }
    'PEDSnet', $file, $sum, $cdm, $table, $commit;
}

=head1 NAME

generate_metadata_csv.pl - Write a metadata.csv for vocabulary data

=head1 SYNOPSIS

 generate_metadata_csv.pl /path/to/file1.csv /path/to/file2.csv ...

=head1 DESCRIPTION

Vocabulary data for the PEDSnet CDM are released as a set of flat
(CSV) files to facilitate bulk loading into a relational database.
These files can be loaded manually or via the PEDSnet DCC loader,
which uses a F<metadata.csv> file for guidance.

This script generates a F<metadata.csv> file for a set of CSV data
files.  The paths to data files to be loaded should be provided on the
command line; native filename syntax is fine.

THe content of the F<metadata.csv> is written to STDOUT.

=head2 OPTIONS

The following command-line options are provided to permit
specification of metadata that are independent of file content:

=over 4

=item B<--help>

Output a brief usage message and exit

=item B<--cdm_version>=I<n>

Use I<n> as the C<cdm> attribute in F<metadata.csv>.

If this is not provided, the list of files is searched for a
F<vocabulary.csv> file.  If one is found, an attempt is made to
extract a version number from the entry for the C<PEDSnet> vocabulary.

B<N.B.:> The default may not be what you want for the CDM version.

=item B<--organization>=I<name>

Use I<name> as the C<organization> attribute in F<metadata.csv>.

If this is not provided, the string C<PEDSnet> is used.  That's ok for
testing, but will not do what you want if you're creating a
F<metadata.csv> to describe in anstitutional dataset.

=item B<--commit_hash>=I<string>

Use I<string> as the C<etl> attribute in F<metadata.csv>.

If this is not provided, the commit hash for C<HEAD> of the current
git repository is used.  Again, this is probably ok for testing, but
not what you want if you're wrapping up an institutional data snapshot
for the DCC loader.

=back

=head1 SEE ALSO

L<https://github.com/PEDSnet/Data_Models/tree/master/PEDSnet>

=head1 BUGS AND CAVEATS

Are there, for certain, but have yet to be cataloged.

=head1 VRESION

1.00

=head1 AUTHOR

Charles Bailey, E<lt>baileyc@email.chop.eduE<gt>

=cut

