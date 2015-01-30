from sqlalchemy import Column, Integer, Date, String, Numeric
from sqlalchemy.schema import PrimaryKeyConstraint, ForeignKeyConstraint, Index, CheckConstraint, UniqueConstraint
from sqlalchemy.ext.declarative import declarative_base

Base = declarative_base()


class Concept(Base):
    __tablename__ = 'concept'
    __table_args__ = (
        PrimaryKeyConstraint('concept_id', name='xpkconcept'),
        ForeignKeyConstraint(['vocabulary_id'], ['vocabulary.vocabulary_id'], name='concept_vocabulary_ref_fk')
    )

    concept_id = Column('concept_id', Integer(), nullable=False, autoincrement=False)
    concept_name = Column('concept_name', String(256), nullable=False)
    concept_level = Column('concept_level', Integer(), nullable=False)
    concept_class = Column('concept_class', String(60), nullable=False)
    vocabulary_id = Column('vocabulary_id', Integer(), nullable=False)
    concept_code = Column('concept_code', String(40), nullable=False)
    valid_start_date = Column('valid_start_date', Date(), nullable=False)
    valid_end_date = Column('valid_end_date', Date(), nullable=False, server_default='31-Dec-2099')
    invalid_reason = Column('invalid_reason', String(1), CheckConstraint("invalid_reason IN ('D', 'U')"))


class ConceptAncestor(Base):
    __tablename__ = 'concept_ancestor'
    __table_args__ = (
        PrimaryKeyConstraint('ancestor_concept_id', 'descendant_concept_id', name='xpkconcept_ancestor'),
        ForeignKeyConstraint(['ancestor_concept_id'], ['concept.concept_id'], name='concept_ancestor_fk'),
        ForeignKeyConstraint(['descendant_concept_id'], ['concept.concept_id'], name='concept_descendant_fk')
    )

    ancestor_concept_id = Column('ancestor_concept_id', Integer(), nullable=False)
    descendant_concept_id = Column('descendant_concept_id', Integer(), nullable=False)
    max_levels_of_separation = Column('max_levels_of_separation', Numeric(precision=38))
    min_levels_of_separation = Column('min_levels_of_separation', Numeric(precision=38))


class ConceptRelationship(Base):
    __tablename__ = 'concept_relationship'
    __table_args__ = (
        PrimaryKeyConstraint('concept_id_1', 'concept_id_2', 'relationship_id', name='xpkconcept_relationship'),
        ForeignKeyConstraint(['concept_id_2'], ['concept.concept_id'], name='concept_rel_child_fk'),
        ForeignKeyConstraint(['concept_id_1'], ['concept.concept_id'], name='concept_rel_parent_fk'),
        ForeignKeyConstraint(['relationship_id'], ['relationship.relationship_id'], name='concept_rel_rel_type_fk')
    )

    concept_id_1 = Column('concept_id_1', Integer(), nullable=False)
    concept_id_2 = Column('concept_id_2', Integer(), nullable=False)
    relationship_id = Column('relationship_id', Integer(), nullable=False)
    valid_start_date = Column('valid_start_date', Date(), nullable=False)
    valid_end_date = Column('valid_end_date', Date(), nullable=False, server_default='31-Dec-2099')
    invalid_reason = Column('invalid_reason', String(1), CheckConstraint("invalid_reason IN ('D', 'U')"))


class ConceptSynonym(Base):
    __tablename__ = 'concept_synonym'
    __table_args__ = (
        PrimaryKeyConstraint('concept_synonym_id', name='xpkconcept_synonym'),
        ForeignKeyConstraint(['concept_id'], ['concept.concept_id'], name='concept_synonym_concept_fk')
    )

    concept_synonym_id = Column('concept_synonym_id', Integer(), nullable=False, autoincrement=False)
    concept_id = Column('concept_id', Integer(), nullable=False)
    concept_synonym_name = Column('concept_synonym_name', String(1000), nullable=False)


class DrugApproval(Base):
    __tablename__ = 'drug_approval'
    __table_args__ = (
        PrimaryKeyConstraint('ingredient_concept_id', name='xpkdrug_approval'),
    )

    ingredient_concept_id = Column('ingredient_concept_id', Integer(), nullable=False, autoincrement=False)
    approval_date = Column('approval_date', Date(), nullable=False)
    approved_by = Column('approved_by', String(20), nullable=False, server_default='FDA')


class DrugStrength(Base):
    __tablename__ = 'drug_strength'
    __table_args__ = (
        PrimaryKeyConstraint('drug_concept_id', 'ingredient_concept_id', 'valid_end_date', name='xpkdrug_strength'),
    )

    drug_concept_id = Column('drug_concept_id', Integer(), nullable=False, autoincrement=False)
    ingredient_concept_id = Column('ingredient_concept_id', Integer(), nullable=False, autoincrement=False)
    amount_value = Column('amount_value', Numeric(precision=38))
    amount_unit = Column('amount_unit', String(60))
    concentration_value = Column('concentration_value', Numeric(precision=38))
    concentration_enum_unit = Column('concentration_enum_unit', String(60))
    concentration_denom_unit = Column('concentration_denom_unit', String(60))
    valid_start_date = Column('valid_start_date', Date(), nullable=False)
    valid_end_date = Column('valid_end_date', Date(), nullable=False)
    invalid_reason = Column('invalid_reason', String(1), CheckConstraint("invalid_reason IN ('D', 'U')"))


class Relationship(Base):
    __tablename__ = 'relationship'
    __table_args__ = (
        PrimaryKeyConstraint('relationship_id', name='xpkrelationship_type'),
    )

    relationship_id = Column('relationship_id', Integer(), nullable=False, autoincrement=False)
    relationship_name = Column('relationship_name', String(256), nullable=False)
    is_hierarchical = Column('is_hierarchical', Integer(), nullable=False)
    defines_ancestry = Column('defines_ancestry', Integer(), nullable=False, server_default='1')
    reverse_relationship = Column('reverse_relationship', Integer())


class SourceToConceptMap(Base):
    __tablename__ = 'source_to_concept_map'
    __table_args__ = (
        PrimaryKeyConstraint('source_vocabulary_id', 'target_concept_id', 'source_code', 'valid_end_date', name='xpksource_to_concept_map'),
        ForeignKeyConstraint(['target_concept_id'], ['concept.concept_id'], name='source_to_concept_concept'),
        ForeignKeyConstraint(['source_vocabulary_id'], ['vocabulary.vocabulary_id'], name='source_to_concept_source_vocab'),
        ForeignKeyConstraint(['target_vocabulary_id'], ['vocabulary.vocabulary_id'], name='source_to_concept_target_vocab'),
        Index('source_to_concept_source_idx', 'source_code')
    )

    source_code = Column('source_code', String(40), nullable=False)
    source_vocabulary_id = Column('source_vocabulary_id', Integer(), nullable=False)
    source_code_description = Column('source_code_description', String(256))
    target_concept_id = Column('target_concept_id', Integer(), nullable=False)
    target_vocabulary_id = Column('target_vocabulary_id', Integer(), nullable=False)
    mapping_type = Column('mapping_type', String(20))
    primary_map = Column('primary_map', String(1), CheckConstraint("primary_map IN ('Y')"))
    valid_start_date = Column('valid_start_date', Date(), nullable=False)
    valid_end_date = Column('valid_end_date', Date(), nullable=False, server_default='31-Dec-2099')
    invalid_reason = Column('invalid_reason', String(1), CheckConstraint("invalid_reason IN ('D', 'U')"))


class Vocabulary(Base):
    __tablename__ = 'vocabulary'
    __table_args__ = (
        PrimaryKeyConstraint('vocabulary_id', name='xpkvocabulary_ref'),
        UniqueConstraint('vocabulary_name', name='unique_vocabulary_name')
    )

    vocabulary_id = Column('vocabulary_id', Integer(), nullable=False, autoincrement=False)
    vocabulary_name = Column('vocabulary_name', String(256), nullable=False)
