
CREATE TABLE drug_approval (
	ingredient_concept_id NUMBER(10) NOT NULL, 
	approval_date DATE NOT NULL, 
	approved_by VARCHAR2(20 CHAR) DEFAULT 'FDA' NOT NULL, 
	CONSTRAINT xpkdrug_approval PRIMARY KEY (ingredient_concept_id)
)


CREATE TABLE vocabulary (
	vocabulary_id NUMBER(10) NOT NULL, 
	vocabulary_name VARCHAR2(256 CHAR) NOT NULL, 
	CONSTRAINT xpkvocabulary_ref PRIMARY KEY (vocabulary_id), 
	CONSTRAINT unique_vocabulary_name UNIQUE (vocabulary_name)
)


CREATE TABLE drug_strength (
	drug_concept_id NUMBER(10) NOT NULL, 
	ingredient_concept_id NUMBER(10) NOT NULL, 
	amount_value NUMERIC(38), 
	amount_unit VARCHAR2(60 CHAR), 
	concentration_value NUMERIC(38), 
	concentration_enum_unit VARCHAR2(60 CHAR), 
	concentration_denom_unit VARCHAR2(60 CHAR), 
	valid_start_date DATE NOT NULL, 
	valid_end_date DATE NOT NULL, 
	invalid_reason VARCHAR2(1 CHAR) CHECK (invalid_reason IN ('D', 'U')), 
	CONSTRAINT xpkdrug_strength PRIMARY KEY (drug_concept_id, ingredient_concept_id, valid_end_date)
)


CREATE TABLE relationship (
	relationship_id NUMBER(10) NOT NULL, 
	relationship_name VARCHAR2(256 CHAR) NOT NULL, 
	is_hierarchical NUMBER(10) NOT NULL, 
	defines_ancestry NUMBER(10) DEFAULT '1' NOT NULL, 
	reverse_relationship NUMBER(10), 
	CONSTRAINT xpkrelationship_type PRIMARY KEY (relationship_id)
)


CREATE TABLE concept (
	concept_id NUMBER(10) NOT NULL, 
	concept_name VARCHAR2(256 CHAR) NOT NULL, 
	concept_level NUMERIC(38) NOT NULL, 
	concept_class VARCHAR2(60 CHAR) NOT NULL, 
	vocabulary_id NUMBER(10) NOT NULL, 
	concept_code VARCHAR2(40 CHAR) NOT NULL, 
	valid_start_date DATE NOT NULL, 
	valid_end_date DATE DEFAULT '31-Dec-2099' NOT NULL, 
	invalid_reason VARCHAR2(1 CHAR) CHECK (invalid_reason IN ('D', 'U')), 
	CONSTRAINT xpkconcept PRIMARY KEY (concept_id), 
	CONSTRAINT concept_vocabulary_ref_fk FOREIGN KEY(vocabulary_id) REFERENCES vocabulary (vocabulary_id)
)


CREATE TABLE source_to_concept_map (
	source_code VARCHAR2(40 CHAR) NOT NULL, 
	source_vocabulary_id NUMBER(10) NOT NULL, 
	source_code_description VARCHAR2(256 CHAR), 
	target_concept_id NUMBER(10) NOT NULL, 
	target_vocabulary_id NUMBER(10) NOT NULL, 
	mapping_type VARCHAR2(20 CHAR), 
	primary_map VARCHAR2(1 CHAR) CHECK (primary_map IN ('Y')), 
	valid_start_date DATE NOT NULL, 
	valid_end_date DATE DEFAULT '31-Dec-2099' NOT NULL, 
	invalid_reason VARCHAR2(1 CHAR) CHECK (invalid_reason IN ('D', 'U')), 
	CONSTRAINT xpksource_to_concept_map PRIMARY KEY (source_vocabulary_id, target_concept_id, source_code, valid_end_date), 
	CONSTRAINT source_to_concept_concept FOREIGN KEY(target_concept_id) REFERENCES concept (concept_id), 
	CONSTRAINT source_to_concept_source_vocab FOREIGN KEY(source_vocabulary_id) REFERENCES vocabulary (vocabulary_id), 
	CONSTRAINT source_to_concept_target_vocab FOREIGN KEY(target_vocabulary_id) REFERENCES vocabulary (vocabulary_id)
)

CREATE INDEX source_to_concept_source_idx ON source_to_concept_map (source_code)
CREATE TABLE concept_synonym (
	concept_synonym_id NUMBER(10) NOT NULL, 
	concept_id NUMBER(10) NOT NULL, 
	concept_synonym_name VARCHAR2(1000 CHAR) NOT NULL, 
	CONSTRAINT xpkconcept_synonym PRIMARY KEY (concept_synonym_id), 
	CONSTRAINT concept_synonym_concept_fk FOREIGN KEY(concept_id) REFERENCES concept (concept_id)
)


CREATE TABLE concept_ancestor (
	ancestor_concept_id NUMBER(10) NOT NULL, 
	descendant_concept_id NUMBER(10) NOT NULL, 
	max_levels_of_separation NUMERIC(38), 
	min_levels_of_separation NUMERIC(38), 
	CONSTRAINT xpkconcept_ancestor PRIMARY KEY (ancestor_concept_id, descendant_concept_id), 
	CONSTRAINT concept_ancestor_fk FOREIGN KEY(ancestor_concept_id) REFERENCES concept (concept_id), 
	CONSTRAINT concept_descendant_fk FOREIGN KEY(descendant_concept_id) REFERENCES concept (concept_id)
)


CREATE TABLE concept_relationship (
	concept_id_1 NUMBER(10) NOT NULL, 
	concept_id_2 NUMBER(10) NOT NULL, 
	relationship_id NUMBER(10) NOT NULL, 
	valid_start_date DATE NOT NULL, 
	valid_end_date DATE DEFAULT '31-Dec-2099' NOT NULL, 
	invalid_reason VARCHAR2(1 CHAR) CHECK (invalid_reason IN ('D', 'U')), 
	CONSTRAINT xpkconcept_relationship PRIMARY KEY (concept_id_1, concept_id_2, relationship_id), 
	CONSTRAINT concept_rel_child_fk FOREIGN KEY(concept_id_2) REFERENCES concept (concept_id), 
	CONSTRAINT concept_rel_parent_fk FOREIGN KEY(concept_id_1) REFERENCES concept (concept_id), 
	CONSTRAINT concept_rel_rel_type_fk FOREIGN KEY(relationship_id) REFERENCES relationship (relationship_id)
)

