# PEDSnet Vocabulary: vocabulary\_pedsnet\_addon

The `vocabulary_pedsnet_addon` schema is the source of truth for PEDSnet-specific single terms added to the OHDSI standard vocabulary.  In particular, we add concepts to several tables in the standard fashion rather than using `source_to_concept_map` because we need to use the concepts to cover needs not addressed by the existing OHDSI standard vocabularies, rather than mapping the terms to existing standard concepts.

The tables in this schema mirror in their structure those in the OMOP CDM v5.  Although this requires copying some standard OMOP metadata concepts into the `vocabulary_pedsnet_addon` schema in order to insure new terms will meet the requirements of the CDM, the gain in safety is considered worth the required effort.  This does imply, however, that updates to the core vocabulary may need to be propagated to this schema across major OMOP releases.

Concept IDs added by PEDSnet will be in the interval [2,000,000,000-3,000,00,000).  It follows from the structure of the vocabulary tables that the next available concept ID will be one greater than  `select max(concept_id) from concept where concept_id >= 2000000000 and concept_id < 3000000000;`.

### To add a term to the vocabulary:

1. Insure that appropriate concepts for `vocabulary_id`, `domain_id`, and `concept_class_id` exist in the `concept` table and in the appropriate metadata table.  If not, recurse.
2. Insert a row with appropriate values into the `concept` table.
3. Iff the new concept is a standard concept, insert identity mappings into `concept_relationship`:
 * `insert into concept_relationship (concept_id_1, concept_id_2, relationship_id, invalid_reason, valid_start_date, valid_end_date) select concept_id, concept_id, 'Maps to', NULL, valid_start_date, valid_end_date from concept where concept_id = `_n_`;`
 * `insert into concept_relationship (concept_id_1, concept_id_2, relationship_id, invalid_reason, valid_start_date, valid_end_date) select concept_id, concept_id, 'Mapped from', NULL, valid_start_date, valid_end_date from concept where concept_id = `_n_`;`
4. Iff the new concept is **not** a standard concept or a metadata concept (and you're just not using `source_to_concept_map` so everything is in one place), insert the appropriate 'Maps to'/'Mapped from' rows into `concept_relationship`.
5. Insert other optional mappings into `concept_relationship` as appropriate.
6. Iff the new concept is a standard concept, insert at least an identity mapping into `concept_ancestor`: `insert into concept_ancestor (ancestor_concept_id, descendant_concept_id, min_levels_of_separation, max_levels_of_separation) select concept_id, concept_id, 0, 0 from concept where concept_id = `n`;`.  You may also want to include other mappings if the new concept is part of a hierarchy.
