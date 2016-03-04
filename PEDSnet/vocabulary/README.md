# PEDSnet CDM Vocabulary Maintenance

The PEDSnet CDM incorporates a number of the standard vocabularies and mappings from the OHDSI/OMOP CDM to support semantic normalization.  We add a small number of network-specific terms to this base, in order to address requirements specific to PEDSnet.

Files within this tree document the tasks necessary for vocabulary maintenance and release, as well as storing a small amount of metadata to support this work.

Groups of PEDSnet-maintained terms and relationships are stored in separate internally-consistent schemata, called addons, with tables following the structure of the OHDSI vocabulary.  These are designed to be merged with a snapshot of the standard OHDSI vocabulary to create a PEDSnet vocabulary release.  Instructions for maintaining these "addon" schemata, as well as the list of OHDSI standard vocabularies used by PEDSnet, can be found in the [dcc_maintenance](dcc_maintenance) subdirectory.

Instructions and template files for producing PEDSnet vocabulary releases (either of the main vocabulary or of the separate GPI supplement) can be found in the [release_management](release_management) subdirectory.
