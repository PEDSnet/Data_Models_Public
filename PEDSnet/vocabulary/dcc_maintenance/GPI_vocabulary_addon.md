# PEDSnet Vocabulary: vocabulary\_gpi\_addon

The `vocabulary_gpi_addon` schema contains terms and mappings that incorporate the Medispan GPI drug description terminology into an OHDSI standard vocabulary.  The GPI vocabulary comprises propietary terms used by several PEDSnet sites that purchase the Medispan drug information product from Wolters-Kluwer.

The long-term process for maintaining this vocabulary is the subject of discussions among PEDSnet sites, the OHDSI vocabulary working group, and Wolters Kluwer.  In the interim, this vocabulary is managed by the DCC.

GPI concepts are drawn from an early version of the OHDSI version 5 vocabulary.  Concept IDs from this vocabulary remain reserved in the OHDSI assignment system, and are used here.

Mappings from GPI concepts to standard RxNorm concepts are determined from the Medispan mapping licensed by participating PEDSnet institutions.  Pending development of a long-term process with OHDSI, these are updated on an ad-hoc basis.  Updates should include:

* addition of new GPI terms to the `concept` table
* addition of mappings from these GPI terms to standard RxNorm concepts in the `concept_relationship` table, with the appropriate 'Maps to' and 'Mapped from' relationships.

Due to possible licensing requirements, the GPI-related sections of the vocabulary are released separately for use by PEDSnet sites licensing Medispan from Wolters Kluwer.  Unlike other supplements, it is not merged into the main vocabulary prior to a release.
