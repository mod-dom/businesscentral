# businesscentral
Urgency Level Dynamics 365 Business Central

# installation

* Docker image used for building evironment is available in a setup.json file
* Container name Urgency
* Platform version 14.0.0.0
* Application version 14.0.0.0
* Test version 14.0.0.0
* Runtime 3.0

# source

* Source code is available in UrgencyCode/Source subfolder
* New field _Urgency Code_ is available on Sales Order Card and Sales Order List
* After shipping order, value of new Sales Order field will be transferred to shipment
* With app installation, web service is automatically published
* Service Name of published web service is _URG Shipment Urgency Entries_

# test

* Test unit is available in UrgencyCode/Source subfolder
* On a Test Tool page, get test codeunit _URG Test Sales Post Urgency_
