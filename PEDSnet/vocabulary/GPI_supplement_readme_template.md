# PEDSnet Vocabulary GPI Supplement

The files in this directory represent supplemental content for the PEDSnet common data model vocabulary, covering the Medispan GPI vocabulary.  Medispan is a product of Wolters-Kluwer licensed by several PEDSnet member institutions for drug information; at these institutions, medication prescribing and dispensing may be recorded using Medispan GPIs to identify specific drug products.

Use of this supplement is currently limited to insitutions licensed to use the Medispan drug master file and the GPI to RxNorm mapping.

### Version

These files contain version M.N.X of the GPI supplemental data, released on DD-MON-YYYY.

### Use

The CSV files in this directory are produced in the same format as the core PEDSnet vocabulary files.  Their content should be loaded into an existing CDM using the methods described in the main vocabulary release.

If the GPI supplement is merged into an existing CDM in which foreign key constraints have already been applied to the vocabulary tables, files from the supplement should be loaded in the following order to avoid constraint violations:

  1. vocabulary
  2. concept
  3. concept_relationship

### Questions?

The PEDSnet vocabulary files are released by the PEDSnet Data Coordinating Center.  If you have any questions, or encounter any difficulties using the data, please do not hesitate to contact the DCC at [pedsnetdcc@email.chop.edu](mailto:pedsnetdcc@email.chop.edu).




