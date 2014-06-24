CREATE TABLE concept (
    concept_id integer PRIMARY KEY,
    concept_name varchar(256) NOT NULL,
    concept_level integer NOT NULL,
    concept_class varchar(60) NOT NULL,
    vocabulary_id integer NOT NULL,
    concept_code varchar(40) NOT NULL,
    valid_start_date timestamp with time zone NOT NULL,
    valid_end_date timestamp with time zone NOT NULL,
    invalid_reason char(1)
);
COMMENT ON TABLE concept IS 'A list of all valid terminology concepts across domains and their attributes. Concepts are derived from existing standards.';
COMMENT ON COLUMN concept.concept_id IS 'A system-generated identifier to uniquely identify each concept across all concept types.';
COMMENT ON COLUMN concept.concept_name IS 'An unambiguous, meaningful and descriptive name for the concept.';
COMMENT ON COLUMN concept.concept_level IS 'The level of hierarchy associated with the concept. Different concept levels are assigned to concepts to depict their seniority in a clearly defined hierarchy, such as drugs, conditions, etc. A concept level of 0 is assigned to concepts that are not part of a standard vocabulary, but are part of the vocabulary for reference purposes (e.g. drug form).';
COMMENT ON COLUMN concept.concept_class IS 'The category or class of the concept along both the hierarchical tree as well as different domains within a vocabulary. Examples are ''Clinical Drug'', ''Ingredient'', ''Clinical Finding'' etc.';
COMMENT ON COLUMN concept.vocabulary_id IS 'A foreign key to the vocabulary table indicating from which source the concept has been adapted.';
COMMENT ON COLUMN concept.concept_code IS 'The concept code represents the identifier of the concept in the source data it originates from, such as SNOMED-CT concept IDs, RxNorm RXCUIs etc. Note that concept codes are not unique across vocabularies.';
COMMENT ON COLUMN concept.valid_start_date IS 'The date when the was first recorded.';
ALTER TABLE concept ALTER COLUMN valid_end_date SET DEFAULT '31-Dec-2099';
COMMENT ON COLUMN concept.valid_end_date IS 'The date when the concept became invalid because it was deleted or superseded (updated) by a new concept. The default value is 31-Dec-2099.';
COMMENT ON COLUMN concept.invalid_reason IS 'Concepts that are replaced with a new concept are designated "Updated" (U) and concepts that are removed without replacement are "Deprecated" (D).';
ALTER TABLE concept ADD CHECK (invalid_reason IN ('D', 'U'));

CREATE TABLE concept_ancestor (
    ancestor_concept_id integer NOT NULL,
    descendant_concept_id integer NOT NULL,
    max_levels_of_separation integer,
    min_levels_of_separation integer,
    PRIMARY KEY (ancestor_concept_id, descendent_concept_id)
);
COMMENT ON TABLE concept_ancestor IS 'A specialized table containing only hierarchical relationship between concepts that may span several generations.';
COMMENT ON COLUMN concept_ancestor.ancestor_concept_id IS 'A foreign key to the concept code in the concept table for the higher-level concept that forms the ancestor in the relationship.';
COMMENT ON COLUMN concept_ancestor.descendant_concept_id IS 'A foreign key to the concept code in the concept table for the lower-level concept that forms the descendant in the relationship.';
COMMENT ON COLUMN concept_ancestor.max_levels_of_separation IS 'The maximum separation in number of levels of hierarchy between ancestor and descendant concepts. This is an optional attribute that is used to simplify hierarchic analysis. ';
COMMENT ON COLUMN concept_ancestor.min_levels_of_separation IS 'The minimum separation in number of levels of hierarchy between ancestor and descendant concepts. This is an optional attribute that is used to simplify hierarchic analysis.';

CREATE TABLE concept_relationship (
    concept_id_1 integer NOT NULL,
    concept_id_2 integer NOT NULL,
    relationship_id integer NOT NULL,
    valid_start_date timestamp with time zone NOT NULL,
    valid_end_date timestamp with time zone NOT NULL,
    invalid_reason char(1),
    PRIMARY KEY (concept_id_1, concept_id_2, relationship_id)
);
COMMENT ON TABLE concept_relationship IS 'A list of relationship between concepts. Some of these relationships are generic (e.g. ''Subsumes'' relationship), others are domain-specific.';
COMMENT ON COLUMN concept_relationship.concept_id_1 IS 'A foreign key to the concept in the concept table associated with the relationship. Relationships are directional, and this field represents the source concept designation.';
COMMENT ON COLUMN concept_relationship.concept_id_2 IS 'A foreign key to the concept in the concept table associated with the relationship. Relationships are directional, and this field represents the destination concept designation.';
COMMENT ON COLUMN concept_relationship.relationship_id IS 'The type of relationship as defined in the relationship table.';
COMMENT ON COLUMN concept_relationship.valid_start_date IS 'The date when the the relationship was first recorded.';
ALTER TABLE concept_relationship ALTER COLUMN valid_end_date SET DEFAULT '31-Dec-2099';
COMMENT ON COLUMN concept_relationship.valid_end_date IS 'The date when the relationship became invalid because it was deleted or superseded (updated) by a new relationship. Default value is 31-Dec-2099.';
COMMENT ON COLUMN concept_relationship.invalid_reason IS 'Reason the relationship was invalidated. Possible values are D (deleted), U (replaced with an update) or NULL when valid_end_date has the default value.';
ALTER TABLE concept_relationship ADD CHECK ( invalid_reason IN ('D', 'U'));

CREATE TABLE concept_synonym (
    concept_synonym_id integer PRIMARY KEY,
    concept_id integer NOT NULL,
    concept_synonym_name varchar(1000) NOT NULL
);
COMMENT ON TABLE concept_synonym IS 'A table with synonyms for concepts that have more than one valid name or description.';
COMMENT ON COLUMN concept_synonym.concept_synonym_id IS 'A system-generated unique identifier for each concept synonym.';
COMMENT ON COLUMN concept_synonym.concept_id IS 'A foreign key to the concept in the concept table. ';
COMMENT ON COLUMN concept_synonym.concept_synonym_name IS 'The alternative name for the concept.';

CREATE TABLE drug_approval (
    ingredient_concept_id integer PRIMARY KEY,
    approval_date timestamp with time zone NOT NULL,
    approved_by varchar(20) NOT NULL
);
ALTER TABLE drug_approval ALTER COLUMN approved_by SET DEFAULT 'FDA';

CREATE TABLE drug_strength (
    drug_concept_id integer NOT NULL,
    ingredient_concept_id integer NOT NULL,
    amount_value numeric(50),
    amount_unit varchar(60),
    concentration_value numeric(50),
    concentration_enum_unit varchar(60),
    concentration_denom_unit varchar(60),
    valid_start_date timestamp with time zone NOT NULL,
    valid_end_date timestamp with time zone NOT NULL,
    invalid_reason varchar(1)
);

CREATE TABLE relationship (
    relationship_id integer PRIMARY KEY,
    relationship_name varchar(256) NOT NULL,
    is_hierarchical integer NOT NULL,
    defines_ancestry integer NOT NULL,
    reverse_relationship integer
);
COMMENT ON TABLE relationship IS 'A list of relationship between concepts. Some of these relationships are generic (e.g. "Subsumes" relationship), others are domain-specific.';
COMMENT ON COLUMN relationship.relationship_id IS 'The type of relationship captured by the relationship record.';
COMMENT ON COLUMN relationship.relationship_name IS 'The text that describes the relationship type.';
COMMENT ON COLUMN relationship.is_hierarchical IS 'Defines whether a relationship defines concepts into classes or hierarchies. Values are Y for hierarchical relationship or NULL if not';
ALTER TABLE relationship ALTER COLUMN defines_ancestry SET DEFAULT 1;
COMMENT ON COLUMN relationship.defines_ancestry IS 'Defines whether a hierarchical relationship contributes to the concept_ancestor table. These are subsets of the hierarchical relationships. Valid values are Y or NULL.';
COMMENT ON COLUMN relationship.reverse_relationship IS 'Relationship ID of the reverse relationship to this one. Corresponding records of reverse relationships have their concept_id_1 and concept_id_2 swapped.';

CREATE TABLE source_to_concept_map (
    source_code varchar(40) NOT NULL,
    source_vocabulary_id integer NOT NULL,
    source_code_description varchar(256),
    target_concept_id integer NOT NULL,
    target_vocabulary_id integer NOT NULL,
    mapping_type varchar(20),
    primary_map char(1),
    valid_start_date timestamp with time zone NOT NULL,
    valid_end_date timestamp with time zone NOT NULL,
    invalid_reason char(1),
    PRIMARY KEY (source_vocabulary_id, target_concept_id, source_code, valid_end_date)
);
COMMENT ON TABLE source_to_concept_map IS 'A map between commonly used terminologies and the CDM Standard Vocabulary. For example, drugs are often recorded as NDC, while the Standard Vocabulary for drugs is RxNorm.';
COMMENT ON COLUMN source_to_concept_map.source_code IS 'The source code being translated into a standard concept.';
COMMENT ON COLUMN source_to_concept_map.source_vocabulary_id IS 'A foreign key to the vocabulary table defining the vocabulary of the source code that is being mapped to the standard vocabulary.';
COMMENT ON COLUMN source_to_concept_map.source_code_description IS 'An optional description for the source code. This is included as a convenience to compare the description of the source code to the name of the concept.';
COMMENT ON COLUMN source_to_concept_map.target_concept_id IS 'A foreign key to the concept to which the source code is being mapped.';
COMMENT ON COLUMN source_to_concept_map.target_vocabulary_id IS 'A foreign key to the vocabulary table defining the vocabulary of the target concept.';
COMMENT ON COLUMN source_to_concept_map.mapping_type IS 'A string identifying the observational data element being translated. Examples include ''DRUG'', ''CONDITION'', ''PROCEDURE'', ''PROCEDURE DRUG'' etc. It is important to pick the appropriate mapping record when the same source code is being mapped to different concepts in different contexts. As an example a procedure code for drug administration can be mapped to a procedure concept or a drug concept.';
COMMENT ON COLUMN source_to_concept_map.primary_map IS 'A boolean value identifying the primary mapping relationship for those sets where the source_code, the source_concept_type_id and the mapping type is identical (one-to-many mappings). The ETL will only consider the primary map. Permitted values are Y and null.';
COMMENT ON COLUMN source_to_concept_map.valid_start_date IS 'The date when the mapping instance was first recorded.';
ALTER TABLE source_to_concept_map ALTER COLUMN valid_end_date SET DEFAULT '31-Dec-2099';
COMMENT ON COLUMN source_to_concept_map.valid_end_date IS 'The date when the mapping instance became invalid because it was deleted or superseded (updated) by a new relationship. Default value is 31-Dec-2099.';
COMMENT ON COLUMN source_to_concept_map.invalid_reason IS 'Reason the mapping instance was invalidated. Possible values are D (deleted), U (replaced with an update) or NULL when valid_end_date has the default value.';
CREATE INDEX source_to_concept_source_idx ON source_to_concept_map (source_code ASC);
ALTER TABLE source_to_concept_map ADD CHECK (primary_map IN ('Y'));
ALTER TABLE source_to_concept_map ADD CHECK (invalid_reason IN ('D', 'U'));

CREATE TABLE vocabulary (
    vocabulary_id integer PRIMARY KEY,
    vocabulary_name varchar(256) NOT NULL
);
COMMENT ON TABLE vocabulary IS 'A combination of terminologies and classifications that belong to a vocabulary domain.';
COMMENT ON COLUMN vocabulary.vocabulary_id IS 'Unique identifier for each of the vocabulary sources used in the observational analysis.';
COMMENT ON COLUMN vocabulary.vocabulary_name IS 'Elaborative name for each of the vocabulary sources.';
ALTER TABLE vocabulary ADD CONSTRAINT unique_vocabulary_name UNIQUE (vocabulary_name);

ALTER TABLE concept ADD CONSTRAINT concept_vocabulary_ref_fk FOREIGN KEY (vocabulary_id) REFERENCES vocabulary (vocabulary_id);
ALTER TABLE concept_ancestor ADD CONSTRAINT concept_ancestor_fk FOREIGN KEY (ancestor_concept_id) REFERENCES concept (concept_id);
ALTER TABLE concept_ancestor ADD CONSTRAINT concept_descendant_fk FOREIGN KEY (descendant_concept_id) REFERENCES concept (concept_id);
ALTER TABLE concept_relationship ADD CONSTRAINT concept_rel_child_fk FOREIGN KEY (concept_id_2) REFERENCES concept (concept_id);
ALTER TABLE concept_relationship ADD CONSTRAINT concept_rel_parent_fk FOREIGN KEY (concept_id_1) REFERENCES concept (concept_id);
ALTER TABLE concept_relationship ADD CONSTRAINT concept_rel_rel_type_fk FOREIGN KEY (relationship_id) REFERENCES relationship (relationship_id);
ALTER TABLE concept_synonym ADD CONSTRAINT concept_synonym_concept_fk FOREIGN KEY (concept_id) REFERENCES concept (concept_id);
ALTER TABLE source_to_concept_map ADD CONSTRAINT source_to_concept_concept FOREIGN KEY (target_concept_id) REFERENCES concept (concept_id);
ALTER TABLE source_to_concept_map ADD CONSTRAINT source_to_concept_source_vocab FOREIGN KEY (source_vocabulary_id) REFERENCES vocabulary (vocabulary_id);
ALTER TABLE source_to_concept_map ADD CONSTRAINT source_to_concept_target_vocab FOREIGN KEY (target_vocabulary_id) REFERENCES vocabulary (vocabulary_id);
