## OMOP CDM V4

The OMOP common data model as defined and instantiated by PEDSnet is described here.

### Changes made to the stock DDL:

The following changes are made to the OMOP CDM and Vocabulary structures (as distributed by OMOP for Oracle) in order to be compatible with the SQL Standard.

1. Declare PRIMARY KEY in the table definition, instead of adding constraint afterwards (including compound primary keys)
2. Replace VARCHAR2 data types with VARCHAR
3. Replace NUMBER data types
    - that specified digits with NUMERIC
    - that didn't specify digits with INTEGER
    - with some exceptions: (DRUG STRENGTH.AMOUNT_VALUE and .CONCENTRATION_VALUE got NUMERIC(50))
4. Remove LOGGING and MONITORING keywords in table definitions
5. Replace MODIFY with ALTER COLUMN and add SET in ALTER TABLE statements
6. Replace DATE type with TIMESTAMP WITH TIME ZONE, except in the observation table, where observation_date is left as DATE and observation_time converted to TIME WITH TIME ZONE.
7. Move foreign key constraints to bottom of vocabulary DDL

