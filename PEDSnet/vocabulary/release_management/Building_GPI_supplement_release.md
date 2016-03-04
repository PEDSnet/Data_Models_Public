# GPI Vocabulary Supplement Assembly

Due to concern about licensing restrictions, the contents of the [GPI addon](../dcc_maintenance/GPI_vocabulary_addon.md) are released as a separate supplement, to be applied over the main vocabulary release.  The supplement is assembled in several steps:

1. Dump CSV files for each table in the `pedsnet_gpi_addon` schema into a clean directory (in practice, you may want to use the client-side `\copy` rather than the server-side `copy`:
  1. `copy vocabulary to './vocabulary.csv' with (format csv encoding 'UTF-8' header delimiter ',' quote '"' force_quote *);`
  1. `copy concept to './concept.csv' with (format csv encoding 'UTF-8'  header delimiter ',' quote '"' force_quote *);`
  1. `copy concept_relationship to './concept_relationship.csv' with (format csv encoding 'UTF-8'  header delimiter ',' quote '"' force_quote *);`

1. Use [the load script generator](generate_load_script.pl) to generate a series of `psql` commands that will bulk load the flat files.  (Hint: `(export SD="$PWD"; cd `_release\_dir_`; "$SD"/generate_load_script.pl [cdsrv]*.csv >|load_vocabulary_files.sql)`)
1. Create a new test schema either by copying a schema containng the main PEDSnet vocabulary, or by using the **PEDSnet DDL** and loading the main PEDSnet vocabulary, and test the flat files:
   * If your test schema has constraints active, you may wish to drop them in order to improve loading time.
   *  Load into the schema using the load script you just generated, or individual `copy` or `\copy` commands.
   *  Apply schema constraints, and build indices using the PEDSnet DDL.
1. Use [the metadata generator](generate_metadata_csv.pl) to generate a `metadata.csv` file describing the vocabulary flat files. (Hint: `(export SD="$PWD"; cd `_release\_dir_`; "$SD"/generate_metadata_csv.pl [cdsrv]*.csv >|metadata.csv)`
1. Using the [GPI supplement readme template](./GPI_supplement_readme_template.md), create release-specific readme files (typically HTML and PDF) in the release directory.
1. Create a compressed archive of the release directory for distribution. (We typically produce a zipfile for the convenience of Windows users.)
1. Upload the archive to the DCC Box space, and announce.  You may need to provide copies to some sites via sftp.
