# PEDSnet CDM Vocabulary Maintenance

The PEDSnet CDM incorporates a number of the standard vocabularies and mappings from the OMOP CDM to support semantic normalization.  We add a small number of network-specific terms to this base, in order to address requirements specific to PEDSnet.

Files here document the tasks necessary for vocabulary maintenance and release, as well as storing a small amount of metadata to support this work.

Groups of PEDSnet-maintained terms and relationships are maintained in internally-consistent schemata designed to be merged with a snapshot of the standard OHDSI vocabulary to create a PEDSnet vocabulary release:

* [GPI\_vocabulary\_supplement](GPI_vocabulary_supplement.md) - PEDSnet-maintained content covering the Medispan GPI terms used by several sites for drug description.
* [PEDSnet\_vocabulary\_supplement](PEDSnet_vocabulary_supplement.md) - PEDSnet-specific content

The process for creating releases of the PEDSnet vocabulary is described in [`PEDSnet_vocabulary_release_management.md`](PEDSnet_vocabulary_release_management.md), with a few supporting files available:

* [`standard_vocab_list.csv`](standard_vocab_list.csv) - List of OHDSI vocabularies included in PEDSnet release
* [`core_release_readme_template.md`](core_release_readme_template.md) - Template for main release
* [`GPI_supplement_readme_template.md`](GPI_supplement_readme_template.md) - Template for GPI supplement release
* [`generate_load_script.pl`](generate_load_script.pl) - Output (Postgres) bulk loading commands for vocabulary data files.
* [`generate_metadata_csv.pl`](generate_metadata_csv.pl) - Write a loader-compatible `metadata.csv` file for vocabulary data files.





