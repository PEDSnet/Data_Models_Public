# PEDSnet Vocabulary Assembly

A PEDSnet core vocabulary release is assembled in several steps:

1. Create a base schema containing an OHDSI vocabulary snapshot (cf. [OHDSI_snapshot.md](../dcc_maintenance/OHDSI_snapshot.md)).
1. Merge PEDSnet-specific additions from the `vocabulary_pedsnet_addon` schema, as described in the [PEDSnet addon guide](./Adding_PEDSnet_addon.md).
1. Dump CSV files for each table into a clean directory (in practice, you may want to use the client-side `\copy` rather than the server-side `copy`:
  1. `copy vocabulary to './vocabulary.csv' with (format csv encoding 'UTF-8' header delimiter ',' quote '"' force_quote *);`
  1. `copy relationship to './relationship.csv' with (format csv encoding 'UTF-8'  header delimiter ',' quote '"' force_quote *);`
  1. `copy domain to './domain.csv' with (format csv encoding 'UTF-8'  header delimiter ',' quote '"' force_quote *);`
  1. `copy concept_class to './concept_class.csv' with (format csv encoding 'UTF-8' ) header delimiter ',' quote '"' force_quote *);`
  1. `copy concept to './concept.csv' with (format csv encoding 'UTF-8'  header delimiter ',' quote '"' force_quote *);`
  1. `copy concept_relationship to './concept_relationship.csv' with (format csv encoding 'UTF-8'  header delimiter ',' quote '"' force_quote *);`
  1. `copy concept_ancestor to './concept_ancestor.csv' with (format csv encoding 'UTF-8'  header delimiter ',' quote '"' force_quote *);`
  1. `copy concept_synonym to './concept_synonym.csv' with (format csv encoding 'UTF-8'  header delimiter ',' quote '"' force_quote *);`
  1. `copy source_to_concept_map to './source_to_concept_map.csv' with (format csv encoding 'UTF-8'  header delimiter ',' quote '"' force_quote *);`
  1. `copy drug_strength to './drug_strength.csv' with (format csv encoding 'UTF-8'  header delimiter ',' quote '"' force_quote *);`
1. Use [the load script generator](generate_load_script.pl) to generate a series of `psql` commands that will bulk load the flat files.  (Hint: `(export SD="$PWD"; cd `_release\_dir_`; "$SD"/generate_load_script.pl [cdsrv]*.csv >|load_vocabulary_files.sql)`)
1. Create a new schema using the **PEDSnet DDL** and test the flat files:
   *  Load into the schema using the load script you just generated, or individual `copy` or `\copy` commands.
   *  Apply schema constraints and build indices using the PEDSnet DDL.
1. Use [the metadata generator](generate_metadata_csv.pl) to generate a `metadata.csv` file describing the vocabulary flat files. (Hint: `(export SD="$PWD"; cd `_release\_dir_`; "$SD"/generate_metadata_csv.pl [cdsrv]*.csv >|metadata.csv)`
1. Using the [core readme template](./core_release_readme_template.md), create release-specific readme files (typically HTML and PDF) in the release directory.
1. Create a compressed archive of the release directory for distribution. (We typically produce a zipfile for the convenience of Windows users.)
1. Upload the archive to the DCC Box space, and announce.  You may need to provide copies to some sites via sftp.

A similar procedure should be followed for each supplement distributed separately (currently only the GPI supplement).
