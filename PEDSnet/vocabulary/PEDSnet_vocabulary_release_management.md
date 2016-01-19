# PEDSnet Vocabulary Assembly

The PEDSnet vocabulary is closely based on the OMOP CDM v5 standard vocabulary, with two content modifications:

* adding PEDSnet-specific terms and vocabularies not yet included in the standard OMOP releases
* creating snapshots for common use with each update cycle, rather than OHDSI's continuous release process

A PEDSnet vocabulary release is assembled in several steps:

1. Obtain a vocabulary snapshot from OHDSI via [Athena](http://www.ohdsi.org/web/athena).   Include the vocabularies [`standard_vocab_list.csv`](./standard_vocab_list.csv).
2. Execute the CPT4 regeneration procedure from the OHDSI download.
3. Create the vocabulary tables using DDL from the [OHDSI Vocabulary  repository](https://github.com/OHDSI/CommonDataModel) (Do **not** use the DDL from the PEDSnet Data Models service if you will bulk load using the \copy command below, as the two DDL sources order the columns in each table differently.  Alternatively, if you use DDL from a source other than OSDHI, you must specify column names, taken from the header of each CSV file, in the \copy command.)
  * vocabulary
  * relationship
  * domain
  * concept_class
  * concept
  * concept_relationship
  * concept_ancestor
  * concept_synonym
  * drug_strength
  * source\_to\_concept_map
4. Bulk load the OHDSI vocabulary (e.g. via psql `\copy ` _table_ ` from ./'`_file_`' with csv header delimiter E'\t' quote E'\b'`)
5. Apply constraints and construct indices for vocabulary tables using DDL from OHDSI or the PEDSnet Data Models service.
6. Merge PEDSnet-specific additions from the `vocabulary_pedsnet_addon` schema, as described in the [PEDSnet vocabulary addon guide](./PEDSnet_vocabulary_addons.md).
7. Create CSV files for each table (in practice, you may want to use the client-side `\copy` rather than the server-side `copy`:
  1. `copy vocabulary to './vocabulary.csv' with (format csv encoding 'UTF-8' header delimiter ',' quote '"' force_quote *);`
  2. `copy relationship to './relationship.csv' with (format csv encoding 'UTF-8'  header delimiter ',' quote '"' force_quote *);`
  3. `copy domain to './domain.csv' with (format csv encoding 'UTF-8'  header delimiter ',' quote '"' force_quote *);`
  4. `copy concept_class to './concept_class.csv' with (format csv encoding 'UTF-8' ) header delimiter ',' quote '"' force_quote *);`
  5. `copy concept to './concept.csv' with (format csv encoding 'UTF-8'  header delimiter ',' quote '"' force_quote *);`
  6. `copy concept_relationship to './concept_relationship.csv' with (format csv encoding 'UTF-8'  header delimiter ',' quote '"' force_quote *);`
  7. `copy concept_ancestor to './concept_ancestor.csv' with (format csv encoding 'UTF-8'  header delimiter ',' quote '"' force_quote *);`
  8. `copy concept_synonym to './concept_synonym.csv' with (format csv encoding 'UTF-8'  header delimiter ',' quote '"' force_quote *);`
  9. `copy source_to_concept_map to './source_to_concept_map.csv' with (format csv encoding 'UTF-8'  header delimiter ',' quote '"' force_quote *);`
  10. `copy drug_strength to './drug_strength.csv' with (format csv encoding 'UTF-8'  header delimiter ',' quote '"' force_quote *);`
8. Create a new schema using the **PEDSnet DDL** and test the flat files:
   *  Load into the schema using `copy` or `\\copy`.
   *  Apply schema constraints and build indices using the PEDSnet DDL.
9. Use [the generator](generate_metadata_csv.pl) to generate a `metadata.csv` file describing the vocabulary only. 
10. Using the [core readme template](./core_release_readme_template.md), create release-specific readme files (typically HTML and PDF).
11. Place the data files and the readme files in a directory named for the release.  Use this directory to create a compressed archive for distribution. (We typically produce a zipfile for the convenience of Wondows users.)
10. Upload the archive to the DCC Box space, and announce.

A similar procedure should be followed for each supplement.
