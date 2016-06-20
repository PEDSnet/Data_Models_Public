# OHDSI Standard Vocabulary Base

PEDSnet vocabulary releases are based on a snapshot of the OHDSI standard vocabulary, to which PEDSnet-specific content is added as a series of supplements.  This is done within a relational schema from which the PEDSnet vocabulary release is dumped.

To set up the standard vocabulary base schema, do the following:

1. Obtain a vocabulary snapshot from OHDSI via [Athena](http://www.ohdsi.org/web/athena).   Include the vocabularies in[`standard_vocab_list.csv`](./standard_vocab_list.csv).
2. Execute the CPT4 regeneration procedure from the OHDSI download.
3. Create the vocabulary tables in a fresh relational schema using DDL from the [OHDSI Vocabulary repository](https://github.com/OHDSI/CommonDataModel). (Do **not** use the DDL from the PEDSnet Data Models service if you will bulk load using the \copy command below, as the two DDL sources order the columns in each table differently.  Alternatively, if you use DDL from a source other than OSDHI, you must specify column names, taken from the header of each CSV file, in the \copy command.)
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
4. Bulk load each table from the OHDSI vocabulary. Commands for the `psql` client reflecting the current structure of the OHDSI files are:
  1. `\copy vocabulary from './vocabulary.csv' with (format csv header delimiter E'\t' quote E'\b');`
  1. `\copy relationship from './relationship.csv' with (format csv header delimiter E'\t' quote E'\b');`
  1. `\copy domain from './domain.csv' with (format csv header delimiter E'\t' quote E'\b');`
  1. `\copy concept_class from './concept_class.csv' with (format csv header delimiter E'\t' quote E'\b');`
  1. `\copy concept from './concept.csv' with (format csv header delimiter E'\t' quote E'\b');`
  1. `\copy concept_relationship from './concept_relationship.csv' with (format csv header delimiter E'\t' quote E'\b');`
  1. `\copy concept_ancestor from './concept_ancestor.csv' with (format csv header delimiter E'\t' quote E'\b');`
  1. `\copy concept_synonym from './concept_synonym.csv' with (format csv header delimiter E'\t' quote E'\b');`
  1. `\copy source_to_concept_map from './source_to_concept_map.csv' with (format csv header delimiter E'\t' quote E'\b');`
  1. `\copy drug_strength from './drug_strength.csv' with (format csv header delimiter E'\t' quote E'\b');`

5. Apply constraints and construct indices for vocabulary tables using DDL from the OHDSI Vocabulary repository or the PEDSnet Data Models service.
