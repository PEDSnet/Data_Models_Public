# PEDSnet Vocabulary Release

### Background 
The files in this directory constitute a release of the core vocabulary data for the PEDSnet common data model.  [PEDSnet](http://www.pedsnet.info) is a PCORnet Clinical Data Research Network focussed on improving the health of children.  It includes a data sharing network currently comprising eight children's health systems.  Clinical data are integrated using the [PEDSnet common data model](https://github.com/PEDSnet/Data_Models/tree/master/PEDSnet), which is closely based on the [OHDSI/OMOP](http://www.ohdsi.org) common data model.  This model includes standardized vocabularies to facilitate cross-source queries; PEDSnet extends these vocabularies with terms necessary to address its requirements.

### Version

These files constitute release M.N.X of the PEDSnet vocabulary, compiled on DD-MON-YYYY.

Within the data, version information can be obtained from the `vocabulary_version` column in the `vocabulary` table.  The version information for the base OMOP vocabularies is associated with a `vocabulary_id` of 'None', while that for the PEDSnet release is associated with a `vocabulary_id` of 'PEDSnet'.

The `concept_id` for any term is guaranteed to be stable across all releases with the same major version number (first digit).  Within the same minor version number (second digit), terms may be added but will not be deleted.

### Format

Vocabulary data are provided as UTF-8 text in flat files.  The field separator within a row is a comma (,), and the quoting characer is a double-quote (").  The quoting character may be escaped within a quoted field by doubling ("").

Each file contains a header row indicating the order of columns.

### Use

The data files are intended for bulk loading into tables created using the PEDSnet CDM DDL.  As of PEDSnet CDM version 2, the vocabulary tables do not contain any elements or constraints beyond those defined in OMOP CDM v5.

The recommended process for loading the data is

1. Create the vocabulary tables using the PEDSnet CDM DDL for the table structure only.  You may use the OHDSI-distributed DDL as well, but be careful, as the order of columns will differ from that in the data files.
2. Use your RDBMS' bulk loading commands (e.g. Postgres' `copy` (or psql `\copy`) or Oracle `load data`) or similar utility to load data into each table.  **_BE CAREFUL_** that the order of columns in the command matches that in the CSV file.  (This will be the case if you created the vocabulary tables using the PEDSnet DDL for the same CDM version as this vocabulary release.)
3. Execute the DDL commands for constraint definition and index construction once data has been read into all tables.

### Questions?

The PEDSnet vocabulary files are released by the PEDSnet Data Coordinating Center.  If you have any questions, or encounter any difficulties using the data, please do not hesitate to contact the DCC at [pedsnetdcc@email.chop.edu](mailto:pedsnetdcc@email.chop.edu).
