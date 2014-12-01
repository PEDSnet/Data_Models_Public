
CREATE TABLE vocabulary (
	vocabulary_id INTEGER NOT NULL, 
	vocabulary_name VARCHAR(256) NOT NULL, 
	CONSTRAINT xpkvocabulary_ref PRIMARY KEY (vocabulary_id), 
	CONSTRAINT unique_vocabulary_name UNIQUE (vocabulary_name)
)

;

CREATE TABLE relationship (
	relationship_id INTEGER NOT NULL, 
	relationship_name VARCHAR(256) NOT NULL, 
	is_hierarchical INTEGER NOT NULL, 
	defines_ancestry INTEGER NOT NULL DEFAULT '1', 
	reverse_relationship INTEGER NULL, 
	CONSTRAINT xpkrelationship_type PRIMARY KEY (relationship_id)
)

;

CREATE TABLE drug_strength (
	drug_concept_id INTEGER NOT NULL, 
	ingredient_concept_id INTEGER NOT NULL, 
	amount_value NUMERIC(38) NULL, 
	amount_unit VARCHAR(60) NULL, 
	concentration_value NUMERIC(38) NULL, 
	concentration_enum_unit VARCHAR(60) NULL, 
	concentration_denom_unit VARCHAR(60) NULL, 
	valid_start_date DATE NOT NULL, 
	valid_end_date DATE NOT NULL, 
	invalid_reason VARCHAR(1) NULL CHECK (invalid_reason IN ('D', 'U')), 
	CONSTRAINT xpkdrug_strength PRIMARY KEY (drug_concept_id, ingredient_concept_id, valid_end_date)
)

;

CREATE TABLE drug_approval (
	ingredient_concept_id INTEGER NOT NULL, 
	approval_date DATE NOT NULL, 
	approved_by VARCHAR(20) NOT NULL DEFAULT 'FDA', 
	CONSTRAINT xpkdrug_approval PRIMARY KEY (ingredient_concept_id)
)

;

CREATE TABLE concept (
	concept_id INTEGER NOT NULL, 
	concept_name VARCHAR(256) NOT NULL, 
	concept_level NUMERIC(38) NOT NULL, 
	concept_class VARCHAR(60) NOT NULL, 
	vocabulary_id INTEGER NOT NULL, 
	concept_code VARCHAR(40) NOT NULL, 
	valid_start_date DATE NOT NULL, 
	valid_end_date DATE NOT NULL DEFAULT '31-Dec-2099', 
	invalid_reason VARCHAR(1) NULL CHECK (invalid_reason IN ('D', 'U')), 
	CONSTRAINT xpkconcept PRIMARY KEY (concept_id), 
	CONSTRAINT concept_vocabulary_ref_fk FOREIGN KEY(vocabulary_id) REFERENCES vocabulary (vocabulary_id)
)

;

CREATE TABLE source_to_concept_map (
	source_code VARCHAR(40) NOT NULL, 
	source_vocabulary_id INTEGER NOT NULL, 
	source_code_description VARCHAR(256) NULL, 
	target_concept_id INTEGER NOT NULL, 
	target_vocabulary_id INTEGER NOT NULL, 
	mapping_type VARCHAR(20) NULL, 
	primary_map VARCHAR(1) NULL CHECK (primary_map IN ('Y')), 
	valid_start_date DATE NOT NULL, 
	valid_end_date DATE NOT NULL DEFAULT '31-Dec-2099', 
	invalid_reason VARCHAR(1) NULL CHECK (invalid_reason IN ('D', 'U')), 
	CONSTRAINT xpksource_to_concept_map PRIMARY KEY (source_vocabulary_id, target_concept_id, source_code, valid_end_date), 
	CONSTRAINT source_to_concept_concept FOREIGN KEY(target_concept_id) REFERENCES concept (concept_id), 
	CONSTRAINT source_to_concept_source_vocab FOREIGN KEY(source_vocabulary_id) REFERENCES vocabulary (vocabulary_id), 
	CONSTRAINT source_to_concept_target_vocab FOREIGN KEY(target_vocabulary_id) REFERENCES vocabulary (vocabulary_id)
)

;
CREATE INDEX source_to_concept_source_idx ON source_to_concept_map (source_code);

CREATE TABLE concept_synonym (
	concept_synonym_id INTEGER NOT NULL, 
	concept_id INTEGER NOT NULL, 
	concept_synonym_name VARCHAR(1000) NOT NULL, 
	CONSTRAINT xpkconcept_synonym PRIMARY KEY (concept_synonym_id), 
	CONSTRAINT concept_synonym_concept_fk FOREIGN KEY(concept_id) REFERENCES concept (concept_id)
)

;

CREATE TABLE concept_relationship (
	concept_id_1 INTEGER NOT NULL, 
	concept_id_2 INTEGER NOT NULL, 
	relationship_id INTEGER NOT NULL, 
	valid_start_date DATE NOT NULL, 
	valid_end_date DATE NOT NULL DEFAULT '31-Dec-2099', 
	invalid_reason VARCHAR(1) NULL CHECK (invalid_reason IN ('D', 'U')), 
	CONSTRAINT xpkconcept_relationship PRIMARY KEY (concept_id_1, concept_id_2, relationship_id), 
	CONSTRAINT concept_rel_child_fk FOREIGN KEY(concept_id_2) REFERENCES concept (concept_id), 
	CONSTRAINT concept_rel_parent_fk FOREIGN KEY(concept_id_1) REFERENCES concept (concept_id), 
	CONSTRAINT concept_rel_rel_type_fk FOREIGN KEY(relationship_id) REFERENCES relationship (relationship_id)
)

;

CREATE TABLE concept_ancestor (
	ancestor_concept_id INTEGER NOT NULL, 
	descendant_concept_id INTEGER NOT NULL, 
	max_levels_of_separation NUMERIC(38) NULL, 
	min_levels_of_separation NUMERIC(38) NULL, 
	CONSTRAINT xpkconcept_ancestor PRIMARY KEY (ancestor_concept_id, descendant_concept_id), 
	CONSTRAINT concept_ancestor_fk FOREIGN KEY(ancestor_concept_id) REFERENCES concept (concept_id), 
	CONSTRAINT concept_descendant_fk FOREIGN KEY(descendant_concept_id) REFERENCES concept (concept_id)
)

;
