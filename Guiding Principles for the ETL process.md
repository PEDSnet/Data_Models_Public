######Guiding Principles for the ETL process
===================
<ol>
<li>  Don't impute things to appear in the data model (e.g. linkages that don't exist in the source data).  Stay true to source data</li>
<li>  Create a defined common list of minimum data elements to be included -- Lowest common denominator. </li>
<li>  Include other data elements from same source if it's easier for ETLers (e.g. complete data cump vs. writing bazillions of row filters) </li>
<li>  Include designated extra special null fields.  Fields not absolutely required for model, but if available and not TOO hard to get, should be included. </li>
<li>  Any data elements that REALLY have to stay off the grid should be excluded from extract. </li>
<li>  Make sure everyone is on the same page regarding the type variables (e.g. condition_type_source_value and place_of_service values).  There are a lot of potential interpretations of type variables. </li>
<li>  Be wary of the same transaction (visit, procedure, etc...) coming in from multiple systems when extracting data, particularly if these records have the same primary key value. </li>
<li>  Establish how the organization/care site hierarchy applies locally, it may affect how different data elements are extracted. </li>
<li>  See if some of the known idiosyncratic value sets (i.e. provider specialites or local race codes) can be provided early to get a jump on mapping. </li>
<li>  Be sure to establish parameters for what constitutes a 'visit' early, this may affect other data elements. </li>
<li>  When the PCORI CDM does not provide clear guidance in how to deal with ambiguities in the ETL, the 8 PEDSnet sites will work together to create our own standards, rather than delay while PCORI comes to a decision.  THis may mean that we will need to modify, but it will also allow us to move forward without delay. </li>
<li>  We will make some decisions about the ETL to meet the needs of the PEDSnet sites that may not be necessary/important to PCORI. </li>


