# Observation Template

## Template Overview

This template provides a boilerplate code for rapid implementation of FHIR APIs and creating, accessing and manipulating FHIR resources.

| Module/Element       | Version |
| -------------------- | ------- |
| FHIR version         | r4 |
| Implementation Guide | [http://hl7.org/fhir/us/core](http://hl7.org/fhir/us/core) |
| Profile URL          |[http://hl7.org/fhir/us/core/StructureDefinition/us-core-observation-lab](http://hl7.org/fhir/us/core/StructureDefinition/us-core-observation-lab), [http://hl7.org/fhir/us/core/StructureDefinition/us-core-body-temperature](http://hl7.org/fhir/us/core/StructureDefinition/us-core-body-temperature), [http://hl7.org/fhir/us/core/StructureDefinition/us-core-head-circumference](http://hl7.org/fhir/us/core/StructureDefinition/us-core-head-circumference), [http://hl7.org/fhir/us/core/StructureDefinition/us-core-observation-pregnancystatus](http://hl7.org/fhir/us/core/StructureDefinition/us-core-observation-pregnancystatus), [http://hl7.org/fhir/us/core/StructureDefinition/us-core-respiratory-rate](http://hl7.org/fhir/us/core/StructureDefinition/us-core-respiratory-rate), [http://hl7.org/fhir/us/core/StructureDefinition/us-core-blood-pressure](http://hl7.org/fhir/us/core/StructureDefinition/us-core-blood-pressure), [http://hl7.org/fhir/us/core/StructureDefinition/us-core-pulse-oximetry](http://hl7.org/fhir/us/core/StructureDefinition/us-core-pulse-oximetry), [http://hl7.org/fhir/us/core/StructureDefinition/us-core-observation-occupation](http://hl7.org/fhir/us/core/StructureDefinition/us-core-observation-occupation), [http://hl7.org/fhir/us/core/StructureDefinition/us-core-body-weight](http://hl7.org/fhir/us/core/StructureDefinition/us-core-body-weight), [http://hl7.org/fhir/us/core/StructureDefinition/us-core-observation-clinical-result](http://hl7.org/fhir/us/core/StructureDefinition/us-core-observation-clinical-result), [http://hl7.org/fhir/us/core/StructureDefinition/us-core-observation-screening-assessment](http://hl7.org/fhir/us/core/StructureDefinition/us-core-observation-screening-assessment), [http://hl7.org/fhir/us/core/StructureDefinition/head-occipital-frontal-circumference-percentile](http://hl7.org/fhir/us/core/StructureDefinition/head-occipital-frontal-circumference-percentile), [http://hl7.org/fhir/us/core/StructureDefinition/us-core-smokingstatus](http://hl7.org/fhir/us/core/StructureDefinition/us-core-smokingstatus), [http://hl7.org/fhir/us/core/StructureDefinition/us-core-bmi](http://hl7.org/fhir/us/core/StructureDefinition/us-core-bmi), [http://hl7.org/fhir/us/core/StructureDefinition/pediatric-weight-for-height](http://hl7.org/fhir/us/core/StructureDefinition/pediatric-weight-for-height), [http://hl7.org/fhir/us/core/StructureDefinition/pediatric-bmi-for-age](http://hl7.org/fhir/us/core/StructureDefinition/pediatric-bmi-for-age), [http://hl7.org/fhir/us/core/StructureDefinition/us-core-body-height](http://hl7.org/fhir/us/core/StructureDefinition/us-core-body-height), [http://hl7.org/fhir/us/core/StructureDefinition/us-core-heart-rate](http://hl7.org/fhir/us/core/StructureDefinition/us-core-heart-rate), [http://hl7.org/fhir/us/core/StructureDefinition/us-core-vital-signs](http://hl7.org/fhir/us/core/StructureDefinition/us-core-vital-signs), [http://hl7.org/fhir/us/core/StructureDefinition/us-core-observation-sexual-orientation](http://hl7.org/fhir/us/core/StructureDefinition/us-core-observation-sexual-orientation), [http://hl7.org/fhir/us/core/StructureDefinition/us-core-observation-pregnancyintent](http://hl7.org/fhir/us/core/StructureDefinition/us-core-observation-pregnancyintent), [http://hl7.org/fhir/us/core/StructureDefinition/us-core-simple-observation](http://hl7.org/fhir/us/core/StructureDefinition/us-core-simple-observation)|

### Dependency List

- ballerinax/health.fhir.r4
- ballerinax/health.fhirr4
- ballerinax/health.fhir.r4.uscore311

This template includes a Ballerina service for Observation FHIR resource with following FHIR interactions.
- READ
- VREAD
- SEARCH
- CREATE
- UPDATE
- PATCH
- DELETE
- HISTORY-INSTANCE
- HISTORY-TYPE

## Prerequisites

Pull the template from central

    ` bal new -t healthcare/health.fhir.r4.uscore311.observation ObservationAPI `

## Run the template

- Run the Ballerina project created by the service template by executing bal run from the root.
- Once successfully executed, Listener will be started at port 9090. Then you need to invoke the service using the following curl command
    ` $ curl http://localhost:9090/fhir/r4/Observation `
- Now service will be invoked and returns an Operation Outcome, until the code template is implemented completely.

## Adding a Custom Profile/Combination of Profiles

- Add profile type to the aggregated resource type. Eg: `public type Observation r4:Observation|<Other_Observation_Profile>;`.
    - Add the new profile URL in `api_config.bal` file.
    - Add as a string inside the `profiles` array.
    - Eg: `profiles: ["http://hl7.org/fhir/us/core/StructureDefinition/us-core-observation-lab", "new_profile_url"]`
