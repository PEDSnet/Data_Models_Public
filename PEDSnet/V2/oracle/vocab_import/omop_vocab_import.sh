#!/bin/sh

sqlldr CONTROL=concept.ctl BAD=concept.bad LOG=concept.log
sqlldr CONTROL=concept_ancestor.ctl BAD=concept_ancestor.bad LOG=concept_ancestor.log
sqlldr CONTROL=concept_class.ctl BAD=concept_class.bad LOG=concept_class.log
sqlldr CONTROL=concept_relationship.ctl BAD=concept_relationship.bad LOG=concept_relationship.log
sqlldr CONTROL=concept_synonym.ctl BAD=concept_synonym.bad LOG=concept_synonym.log
sqlldr CONTROL=domain.ctl BAD=domain.bad LOG=domain.log
sqlldr CONTROL=drug_strength.ctl BAD=drug_strength.bad LOG=drug_strength.log
sqlldr CONTROL=relationship.ctl BAD=relationship.bad LOG=relationship.log
sqlldr CONTROL=vocabulary.ctl BAD=vocabulary.bad LOG=vocabulary.log