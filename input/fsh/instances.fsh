Alias: $restful-security-service = http://terminology.hl7.org/CodeSystem/restful-security-service

Instance: example-ipa-server
InstanceOf: CapabilityStatement
Usage: #example
* name = "RestServer"
* status = #active
* date = "2024-05-13T08:59:01.007+00:00"
* publisher = "HL7 Denmark"
* kind = #instance
* software
  * name = "HL7 Denmark example FHIR Server"
  * version = "0.9.0"
* implementation
  * description = "HAPI FHIR"
  * url = "https://gravitate-ips.gravitate.tcs.trifork.dev/fhir/metadata"
* fhirVersion = #4.0.1
* format[0] = #application/fhir+xml
* format[+] = #xml
* format[+] = #application/fhir+json
* format[+] = #json
* format[+] = #application/x-turtle
* format[+] = #ttl
* rest
  * mode = #server
  * security
    * extension
      * extension[0]
        * valueUri = "https://gravitate-ips.gravitate.tcs.trifork.dev/oauth2/authorize"
        * url = "authorize"
      * extension[+]
        * valueUri = "https://gravitate-ips.gravitate.tcs.trifork.dev/oauth2/token"
        * url = "token"
      * url = "http://fhir-registry.smarthealthit.org/StructureDefinition/oauth-uris"
    * cors = true
    * service[0] = $restful-security-service#OAuth "OAuth"
      * text = "OAuth"
    * service[+] = $restful-security-service#SMART-on-FHIR "SMART-on-FHIR"
      * text = "SMART-on-FHIR"
    * service[+] = $restful-security-service#Basic "Basic"
      * text = "Basic"
  * resource[0]
    * type = #Condition
    * profile = "http://hl7.org/fhir/StructureDefinition/Condition"
    * interaction.code = #search-type
    * searchInclude = "*"
  * resource[+]
    * type = #Immunization
    * profile = "http://hl7.org/fhir/StructureDefinition/Immunization"
    * interaction.code = #search-type
    * searchInclude = "*"
  * resource[+]
    * type = #Medication
    * profile = "http://hl7.org/fhir/StructureDefinition/Medication"
    * interaction.code = #search-type
    * searchInclude = "*"
  * resource[+]
    * type = #MedicationRequest
    * profile = "http://hl7.org/fhir/StructureDefinition/MedicationRequest"
    * interaction.code = #search-type
    * searchInclude = "*"
    * searchParam
      * name = "_id"
      * type = #token
      * documentation = "The ID of the resource"
  * resource[+]
    * type = #MedicationStatement
    * profile = "http://hl7.org/fhir/StructureDefinition/MedicationStatement"
    * interaction.code = #search-type
    * searchInclude = "*"
  * resource[+]
    * type = #Observation
    * profile = "http://hl7.org/fhir/StructureDefinition/Observation"
    * interaction.code = #search-type
    * searchInclude = "*"
  * resource[+]
    * type = #OperationDefinition
    * profile = "http://hl7.org/fhir/StructureDefinition/OperationDefinition"
    * interaction.code = #read
    * searchInclude = "*"
  * resource[+]
    * type = #Patient
    * profile = "http://hl7.org/fhir/StructureDefinition/Patient"
    * interaction[0].code = #search-type
    * interaction[+].code = #vread
    * interaction[+].code = #read
    * searchInclude = "*"
    * operation
      * name = "summary"
      * definition = "https://gravitate-ips.gravitate.tcs.trifork.dev/fhir/metadata/OperationDefinition/Patient-t-summary"
  * resource[+]
    * type = #Practitioner
    * profile = "http://hl7.org/fhir/StructureDefinition/Practitioner"
    * interaction.code = #search-type
    * searchInclude = "*"