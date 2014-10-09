CREATE TABLE CONCEPT (
  CONCEPT_ID		INTEGER		NOT NULL,
  CONCEPT_NAME		VARCHAR2(256)	NOT NULL,
  CONCEPT_LEVEL		NUMBER		NOT NULL,
  CONCEPT_CLASS		VARCHAR2(60)	NOT NULL,
  VOCABULARY_ID		INTEGER		NOT NULL,
  CONCEPT_CODE		VARCHAR2(40)	NOT NULL,
  VALID_START_DATE	DATE		NOT NULL,
  VALID_END_DATE	DATE		NOT NULL,
  INVALID_REASON	CHAR(1)		NULL)
LOGGING
MONITORING
;

COMMENT ON TABLE CONCEPT IS 'A list of all valid terminology concepts across domains and their attributes. Concepts are derived from existing standards.'
;
COMMENT ON COLUMN CONCEPT.CONCEPT_ID IS 'A system-generated identifier to uniquely identify each concept across all concept types.'
;
COMMENT ON COLUMN CONCEPT.CONCEPT_NAME IS 'An unambiguous, meaningful and descriptive name for the concept.'
;
COMMENT ON COLUMN CONCEPT.CONCEPT_LEVEL IS 'The level of hierarchy associated with the concept. Different concept levels are assigned to concepts to depict their seniority in a clearly defined hierarchy, such as drugs, conditions, etc. A concept level of 0 is assigned to concepts that are not part of a standard vocabulary, but are part of the vocabulary for reference purposes (e.g. drug form).'
;
COMMENT ON COLUMN CONCEPT.CONCEPT_CLASS IS 'The category or class of the concept along both the hierarchical tree as well as different domains within a vocabulary. Examples are ''Clinical Drug'', ''Ingredient'', ''Clinical Finding'' etc.'
;
COMMENT ON COLUMN CONCEPT.VOCABULARY_ID IS 'A foreign key to the vocabulary table indicating from which source the concept has been adapted.'
;
COMMENT ON COLUMN CONCEPT.CONCEPT_CODE IS 'The concept code represents the identifier of the concept in the source data it originates from, such as SNOMED-CT concept IDs, RxNorm RXCUIs etc. Note that concept codes are not unique across vocabularies.'
;
COMMENT ON COLUMN CONCEPT.VALID_START_DATE IS 'The date when the was first recorded.'
;
ALTER TABLE CONCEPT MODIFY VALID_END_DATE DEFAULT '31-Dec-2099'
;
COMMENT ON COLUMN CONCEPT.VALID_END_DATE IS 'The date when the concept became invalid because it was deleted or superseded (updated) by a new concept. The default value is 31-Dec-2099.'
;
COMMENT ON COLUMN CONCEPT.INVALID_REASON IS 'Concepts that are replaced with a new concept are designated "Updated" (U) and concepts that are removed without replacement are "Deprecated" (D).'
;
ALTER TABLE CONCEPT ADD CONSTRAINT XPKCONCEPT PRIMARY KEY (CONCEPT_ID)
USING INDEX
LOGGING
;
ALTER TABLE CONCEPT ADD CHECK ( invalid_reason IN ('D', 'U'))
;
ALTER TABLE CONCEPT ADD CONSTRAINT CONCEPT_VOCABULARY_REF_FK FOREIGN KEY (VOCABULARY_ID) REFERENCES VOCABULARY (VOCABULARY_ID)
;

CREATE TABLE CONCEPT_ANCESTOR (
  ANCESTOR_CONCEPT_ID		INTEGER	NOT NULL,
  DESCENDANT_CONCEPT_ID		INTEGER	NOT NULL,
  MAX_LEVELS_OF_SEPARATION	NUMBER	NULL,
  MIN_LEVELS_OF_SEPARATION	NUMBER	NULL)
LOGGING
MONITORING
;

COMMENT ON TABLE CONCEPT_ANCESTOR IS 'A specialized table containing only hierarchical relationship between concepts that may span several generations.'
;
COMMENT ON COLUMN CONCEPT_ANCESTOR.ANCESTOR_CONCEPT_ID IS 'A foreign key to the concept code in the concept table for the higher-level concept that forms the ancestor in the relationship.'
;
COMMENT ON COLUMN CONCEPT_ANCESTOR.DESCENDANT_CONCEPT_ID IS 'A foreign key to the concept code in the concept table for the lower-level concept that forms the descendant in the relationship.'
;
COMMENT ON COLUMN CONCEPT_ANCESTOR.MAX_LEVELS_OF_SEPARATION IS 'The maximum separation in number of levels of hierarchy between ancestor and descendant concepts. This is an optional attribute that is used to simplify hierarchic analysis. '
;
COMMENT ON COLUMN CONCEPT_ANCESTOR.MIN_LEVELS_OF_SEPARATION IS 'The minimum separation in number of levels of hierarchy between ancestor and descendant concepts. This is an optional attribute that is used to simplify hierarchic analysis.'
;
ALTER TABLE CONCEPT_ANCESTOR ADD CONSTRAINT XPKCONCEPT_ANCESTOR PRIMARY KEY (ANCESTOR_CONCEPT_ID,DESCENDANT_CONCEPT_ID)
USING INDEX
LOGGING
;
ALTER TABLE CONCEPT_ANCESTOR ADD CONSTRAINT CONCEPT_ANCESTOR_FK FOREIGN KEY (ANCESTOR_CONCEPT_ID) REFERENCES CONCEPT (CONCEPT_ID)
;
ALTER TABLE CONCEPT_ANCESTOR ADD CONSTRAINT CONCEPT_DESCENDANT_FK FOREIGN KEY (DESCENDANT_CONCEPT_ID) REFERENCES CONCEPT (CONCEPT_ID)
;

CREATE TABLE CONCEPT_RELATIONSHIP (
  CONCEPT_ID_1		INTEGER	NOT NULL,
  CONCEPT_ID_2		INTEGER	NOT NULL,
  RELATIONSHIP_ID	INTEGER	NOT NULL,
  VALID_START_DATE	DATE	NOT NULL,
  VALID_END_DATE	DATE	NOT NULL,
  INVALID_REASON	CHAR(1)	NULL)
LOGGING
MONITORING
;

COMMENT ON TABLE CONCEPT_RELATIONSHIP IS 'A list of relationship between concepts. Some of these relationships are generic (e.g. ''Subsumes'' relationship), others are domain-specific.'
;
COMMENT ON COLUMN CONCEPT_RELATIONSHIP.CONCEPT_ID_1 IS 'A foreign key to the concept in the concept table associated with the relationship. Relationships are directional, and this field represents the source concept designation.'
;
COMMENT ON COLUMN CONCEPT_RELATIONSHIP.CONCEPT_ID_2 IS 'A foreign key to the concept in the concept table associated with the relationship. Relationships are directional, and this field represents the destination concept designation.'
;
COMMENT ON COLUMN CONCEPT_RELATIONSHIP.RELATIONSHIP_ID IS 'The type of relationship as defined in the relationship table.'
;
COMMENT ON COLUMN CONCEPT_RELATIONSHIP.VALID_START_DATE IS 'The date when the the relationship was first recorded.'
;
ALTER TABLE CONCEPT_RELATIONSHIP MODIFY VALID_END_DATE DEFAULT '31-Dec-2099'
;
COMMENT ON COLUMN CONCEPT_RELATIONSHIP.VALID_END_DATE IS 'The date when the relationship became invalid because it was deleted or superseded (updated) by a new relationship. Default value is 31-Dec-2099.'
;
COMMENT ON COLUMN CONCEPT_RELATIONSHIP.INVALID_REASON IS 'Reason the relationship was invalidated. Possible values are D (deleted), U (replaced with an update) or NULL when valid_end_date has the default  value.'
;
ALTER TABLE CONCEPT_RELATIONSHIP ADD CONSTRAINT XPKCONCEPT_RELATIONSHIP PRIMARY KEY (CONCEPT_ID_1,CONCEPT_ID_2,RELATIONSHIP_ID)
USING INDEX
LOGGING
;
ALTER TABLE CONCEPT_RELATIONSHIP ADD CHECK ( invalid_reason IN ('D', 'U'))
;
ALTER TABLE CONCEPT_RELATIONSHIP ADD CONSTRAINT CONCEPT_REL_CHILD_FK FOREIGN KEY (CONCEPT_ID_2) REFERENCES CONCEPT (CONCEPT_ID)
;
ALTER TABLE CONCEPT_RELATIONSHIP ADD CONSTRAINT CONCEPT_REL_PARENT_FK FOREIGN KEY (CONCEPT_ID_1) REFERENCES CONCEPT (CONCEPT_ID)
;
ALTER TABLE CONCEPT_RELATIONSHIP ADD CONSTRAINT CONCEPT_REL_REL_TYPE_FK FOREIGN KEY (RELATIONSHIP_ID) REFERENCES RELATIONSHIP (RELATIONSHIP_ID)
;

CREATE TABLE CONCEPT_SYNONYM (
  CONCEPT_SYNONYM_ID	INTEGER		NOT NULL,
  CONCEPT_ID		INTEGER		NOT NULL,
  CONCEPT_SYNONYM_NAME	VARCHAR2(1000)	NOT NULL)
LOGGING
MONITORING
;

COMMENT ON TABLE CONCEPT_SYNONYM IS 'A table with synonyms for concepts that have more than one valid name or description.'
;
COMMENT ON COLUMN CONCEPT_SYNONYM.CONCEPT_SYNONYM_ID IS 'A system-generated unique identifier for each concept synonym.'
;
COMMENT ON COLUMN CONCEPT_SYNONYM.CONCEPT_ID IS 'A foreign key to the concept in the concept table. '
;
COMMENT ON COLUMN CONCEPT_SYNONYM.CONCEPT_SYNONYM_NAME IS 'The alternative name for the concept.'
;
ALTER TABLE CONCEPT_SYNONYM ADD CONSTRAINT XPKCONCEPT_SYNONYM PRIMARY KEY (CONCEPT_SYNONYM_ID)
USING INDEX
LOGGING
;
ALTER TABLE CONCEPT_SYNONYM ADD CONSTRAINT CONCEPT_SYNONYM_CONCEPT_FK FOREIGN KEY (CONCEPT_ID) REFERENCES CONCEPT (CONCEPT_ID)
;

CREATE TABLE DRUG_APPROVAL (
  INGREDIENT_CONCEPT_ID	INTEGER		NOT NULL,
  APPROVAL_DATE		DATE		NOT NULL,
  APPROVED_BY		VARCHAR2(20)	NOT NULL)
LOGGING
MONITORING
;
ALTER TABLE DRUG_APPROVAL MODIFY APPROVED_BY DEFAULT 'FDA'
;

CREATE TABLE DRUG_STRENGTH (
  DRUG_CONCEPT_ID		INTEGER		NOT NULL,
  INGREDIENT_CONCEPT_ID		INTEGER		NOT NULL,
  AMOUNT_VALUE			NUMBER		NULL,
  AMOUNT_UNIT			VARCHAR2(60)	NULL,
  CONCENTRATION_VALUE		NUMBER		NULL,
  CONCENTRATION_ENUM_UNIT	VARCHAR2(60)	NULL,
  CONCENTRATION_DENOM_UNIT	VARCHAR2(60)	NULL,
  VALID_START_DATE		DATE		NOT NULL,
  VALID_END_DATE		DATE		NOT NULL,
  INVALID_REASON		VARCHAR2(1)	NULL)
LOGGING
MONITORING
;

CREATE TABLE RELATIONSHIP (
  RELATIONSHIP_ID	INTEGER		NOT NULL,
  RELATIONSHIP_NAME	VARCHAR2(256)	NOT NULL,
  IS_HIERARCHICAL	INTEGER		NOT NULL,
  DEFINES_ANCESTRY	INTEGER		NOT NULL,
  REVERSE_RELATIONSHIP	INTEGER		NULL)
LOGGING
MONITORING
;

COMMENT ON TABLE RELATIONSHIP IS 'A list of relationship between concepts. Some of these relationships are generic (e.g. "Subsumes" relationship), others are domain-specific.'
;
COMMENT ON COLUMN RELATIONSHIP.RELATIONSHIP_ID IS 'The type of relationship captured by the relationship record.'
;
COMMENT ON COLUMN RELATIONSHIP.RELATIONSHIP_NAME IS 'The text that describes the relationship type.'
;
COMMENT ON COLUMN RELATIONSHIP.IS_HIERARCHICAL IS 'Defines whether a relationship defines concepts into classes or hierarchies. Values are Y for hierarchical relationship or NULL if not'
;
ALTER TABLE RELATIONSHIP MODIFY DEFINES_ANCESTRY DEFAULT 1
;
COMMENT ON COLUMN RELATIONSHIP.DEFINES_ANCESTRY IS 'Defines whether a hierarchical relationship contributes to the concept_ancestor table. These are subsets of the hierarchical relationships. Valid values are Y or NULL.'
;
COMMENT ON COLUMN RELATIONSHIP.REVERSE_RELATIONSHIP IS 'Relationship ID of the reverse relationship to this one. Corresponding records of reverse relationships have their concept_id_1 and concept_id_2 swapped.'
;
ALTER TABLE RELATIONSHIP ADD CONSTRAINT XPKRELATIONSHIP_TYPE PRIMARY KEY (RELATIONSHIP_ID)
USING INDEX
LOGGING
;

CREATE TABLE SOURCE_TO_CONCEPT_MAP (
  SOURCE_CODE			VARCHAR2(40)	NOT NULL,
  SOURCE_VOCABULARY_ID		INTEGER		NOT NULL,
  SOURCE_CODE_DESCRIPTION	VARCHAR2(256)	NULL,
  TARGET_CONCEPT_ID		INTEGER		NOT NULL,
  TARGET_VOCABULARY_ID		INTEGER		NOT NULL,
  MAPPING_TYPE			VARCHAR2(20)	NULL,
  PRIMARY_MAP			CHAR(1)		NULL,
  VALID_START_DATE		DATE		NOT NULL,
  VALID_END_DATE		DATE		NOT NULL,
  INVALID_REASON		CHAR(1)		NULL)
LOGGING
MONITORING
;

COMMENT ON TABLE SOURCE_TO_CONCEPT_MAP IS 'A map between commonly used terminologies and the CDM Standard Vocabulary. For example, drugs are often recorded as NDC, while the Standard Vocabulary for drugs is RxNorm.'
;
COMMENT ON COLUMN SOURCE_TO_CONCEPT_MAP.SOURCE_CODE IS 'The source code being translated into a standard concept.'
;
COMMENT ON COLUMN SOURCE_TO_CONCEPT_MAP.SOURCE_VOCABULARY_ID IS 'A foreign key to the vocabulary table defining the vocabulary of the source code that is being mapped to the standard vocabulary.'
;
COMMENT ON COLUMN SOURCE_TO_CONCEPT_MAP.SOURCE_CODE_DESCRIPTION IS 'An optional description for the source code. This is included as a convenience to compare the description of the source code to the name of the concept.'
;
COMMENT ON COLUMN SOURCE_TO_CONCEPT_MAP.TARGET_CONCEPT_ID IS 'A foreign key to the concept to which the source code is being mapped.'
;
COMMENT ON COLUMN SOURCE_TO_CONCEPT_MAP.TARGET_VOCABULARY_ID IS 'A foreign key to the vocabulary table defining the vocabulary of the target concept.'
;
COMMENT ON COLUMN SOURCE_TO_CONCEPT_MAP.MAPPING_TYPE IS 'A string identifying the observational data element being translated. Examples include ''DRUG'', ''CONDITION'', ''PROCEDURE'', ''PROCEDURE DRUG'' etc. It is important to pick the appropriate mapping record when the same source code is being mapped to different concepts in different contexts. As an example a procedure code for drug administration can be mapped to a procedure concept or a drug concept.'
;
COMMENT ON COLUMN SOURCE_TO_CONCEPT_MAP.PRIMARY_MAP IS 'A boolean value identifying the primary mapping relationship for those sets where the source_code, the source_concept_type_id and the mapping type is identical (one-to-many mappings). The ETL will only consider the primary map. Permitted values are Y and null.'
;
COMMENT ON COLUMN SOURCE_TO_CONCEPT_MAP.VALID_START_DATE IS 'The date when the mapping instance was first recorded.'
;
ALTER TABLE SOURCE_TO_CONCEPT_MAP MODIFY VALID_END_DATE DEFAULT '31-Dec-2099'
;
COMMENT ON COLUMN SOURCE_TO_CONCEPT_MAP.VALID_END_DATE IS 'The date when the mapping instance became invalid because it was deleted or superseded (updated) by a new relationship. Default value is 31-Dec-2099.'
;
COMMENT ON COLUMN SOURCE_TO_CONCEPT_MAP.INVALID_REASON IS 'Reason the mapping instance was invalidated. Possible values are D (deleted), U (replaced with an update) or NULL when valid_end_date has the default  value.'
;
CREATE INDEX SOURCE_TO_CONCEPT_SOURCE_IDX ON SOURCE_TO_CONCEPT_MAP (SOURCE_CODE ASC)
LOGGING
;
ALTER TABLE SOURCE_TO_CONCEPT_MAP ADD CONSTRAINT XPKSOURCE_TO_CONCEPT_MAP PRIMARY KEY (SOURCE_VOCABULARY_ID,TARGET_CONCEPT_ID,SOURCE_CODE,VALID_END_DATE)
USING INDEX
LOGGING
;
ALTER TABLE SOURCE_TO_CONCEPT_MAP ADD CHECK ( primary_map IN ('Y'))
;
ALTER TABLE SOURCE_TO_CONCEPT_MAP ADD CHECK ( invalid_reason IN ('D', 'U'))
;
ALTER TABLE SOURCE_TO_CONCEPT_MAP ADD CONSTRAINT SOURCE_TO_CONCEPT_CONCEPT FOREIGN KEY (TARGET_CONCEPT_ID) REFERENCES CONCEPT (CONCEPT_ID)
;
ALTER TABLE SOURCE_TO_CONCEPT_MAP ADD CONSTRAINT SOURCE_TO_CONCEPT_SOURCE_VOCAB FOREIGN KEY (SOURCE_VOCABULARY_ID) REFERENCES VOCABULARY (VOCABULARY_ID)
;
ALTER TABLE SOURCE_TO_CONCEPT_MAP ADD CONSTRAINT SOURCE_TO_CONCEPT_TARGET_VOCAB FOREIGN KEY (TARGET_VOCABULARY_ID) REFERENCES VOCABULARY (VOCABULARY_ID)
;

CREATE TABLE VOCABULARY (
  VOCABULARY_ID		INTEGER		NOT NULL,
  VOCABULARY_NAME	VARCHAR2(256)	NOT NULL)
LOGGING
MONITORING
;

COMMENT ON TABLE VOCABULARY IS 'A combination of terminologies and classifications that belong to a Vocabulary Domain.'
;
COMMENT ON COLUMN VOCABULARY.VOCABULARY_ID IS 'Unique identifier for each of the vocabulary sources used in the observational analysis.'
;
COMMENT ON COLUMN VOCABULARY.VOCABULARY_NAME IS 'Elaborative name for each of the vocabulary sources'
;
ALTER TABLE VOCABULARY ADD CONSTRAINT UNIQUE_VOCABULARY_NAME UNIQUE (VOCABULARY_NAME)
USING INDEX
LOGGING
;
ALTER TABLE VOCABULARY ADD CONSTRAINT XPKVOCABULARY_REF PRIMARY KEY (VOCABULARY_ID)
USING INDEX
LOGGING
;

