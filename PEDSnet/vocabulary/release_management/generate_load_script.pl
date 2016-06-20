#!/usr/bin/env perl

use strict;
use warnings;

our $VERSION = '1.00';

# Template for bulk loading command, with three %s patterns:
#  - the first is replaced with the name of the table
#  - the second is replaced with the names of columns,
#    in the order they appear in the CSV file
#  - the third is replaced with the name of the file

# Postgres
my $cmd = q[\\copy %s (%s) from '%s' with (format csv header] .
  q[ encoding 'UTF-8' delimiter ',' escape '"');];

use File::Basename qw(basename);

if (!@ARGV or $ARGV[0] =~ /^--?[h?]/) {
  die qq[Usage: $0 /path/to/file.csv /path/to/file.csv ...
  Construct a list of bulk loading commands for vocabulary data.

  More detailed information is available via
  perdoc $0
];
}


foreach my $path (@ARGV) {
  my $table = basename($path);
  $table =~ s/\.[ct]sv$//i;

  open my $fh, '<', $path or die "Can't read $path: $!";
  my $header = <$fh>;
  close $fh or die "Error reading $path: $!";
  chomp $header;
  # Make some very limiting assumptions about format of
  # data file and column names
  $header =~ s/[,\t]/,/g;
  printf "$cmd\n", $table, $header, $path;
}

=head1 NAME

generate_load_script.pl - Construct RDBMS bulk loading commands for
vocabulary data

=head1 SYNOPSIS

 generate_load_script.pl /path/to/file1.csv /path/to/file2.csv ...

=head1 DESCRIPTION

Vocabulary data for the PEDSnet CDM are released as a set of flat
(CSV) files to facilitate bulk loading into a relational database.

This script is intended to eliminate a bit of the tedium involved in
constructing appropriate bulk loading commands.  It makes a number of
assumptions about the structure of the data files in the interest of
brevity over robustness, so may not generalize well to other CSV files
(in particular, files whose column names would require quoting in the
bulk loading command).

The paths to data files to be loaded should be provided on the command
line; native filename syntax is fine.  The following conditions are
assumed (all true for PEDSnet vocabulary data files):

=over 4

=item *

All path names can be simply quoted in the bulk loading commands;
none contains any characters that would require escaping.

=item *

The base name of each data file, less its F<.csv> or F<.tsv>
extension, is the name of the table to populate.

=item *

The first line in each data file lists the column names for that
table. 

=item *

Either a comma or a TAB character is used as the field separator.

=back

=head2 RDBMS

As distributed, this utility generates loading commnads for a Postgres
RDBMS.  To use with a different RDBMS, edit the C<$cmd> template in
this file as described in the source.  If you have occasion to do so,
we'd appreciate it if you'd send us a patch or a note describing what
you did, so we can roll it into a future version.


The following command line options are available:

=head1 OPTIONS

=over 4

=item B<--help>, B<-h>, or B<-?>

Output a brief help message, then exit.

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

