# Vocabulary maintenance at the DCC

The PEDSnet vocabulary is based closely on the standard OHDSI/OMOP vocabulary, and uses components from the vocabulary wherever possible.  For additions that are either specific to PEDSnet or unavailable currently through OHDSI, PEDSnet maintains a set of separate terminology-specific schemata, called addons.  Each schema reproduces the tables from the OHDSI vocabulary structure needed for that terminology, as well as the OHDSI standard metadata terms needed to describe the PEDSnet-specific additions (_e.g._ domain IDs, concept class IDs).  If the addon requires new metadata terms (_e.g._ to add a new domain ID), these are defined in the supplement as well.

* For instructions on how to load a snapshot of the OHDSI standard vocabulary as a base for a PEDSnet release, see [OHDSI_snapshot.md](OHDSI_snapshot.md).

* For information about the PEDSnet-maintained GPI drug vocabulary supplement, see [GPI_vocabulary_supplement.md](GPI_vocabulary_supplement.md).

* For information about adding PEDSnet-specific terms, see [PEDSnet_vocabulary_supplement.md](PEDSnet_vocabulary_supplement.md). 
