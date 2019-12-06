# Conditions

This document is intended to summarize details around condition occurrence metadata for the PEDSnet network.

### [Condition Source](https://github.com/PEDSnet/Data_Models/issues/255)

Condition Source| CCHMC|CHCO |CHOP|Nationwide|Nemours|Seattle|St Louis
---|---|---|---|---|---|---|---
Physician|x|x|x||x||x
Billing|x|x||x|x|x|x


### [Condition Provider (primary)](https://github.com/PEDSnet/Data_Models/issues/378)

 Condition Provider |CCHMC|CHCO |CHOP|Nationwide|Nemours|Seattle|St Louis
---|---|---|---|---|---|---|---
Diagnosis Record||x|
Visit Level|x||x|x|x|x|x

#### Note:
- St.Louis imputes from visit if provider not found on diagnosis record
- Natiowide problem list provider is recording provider
- Nemours problem list provider is recording provider
