// Copyright (c) 2023, WSO2 LLC. (http://www.wso2.com). All Rights Reserved.

// This software is the property of WSO2 LLC. and its suppliers, if any.
// Dissemination of any information or reproduction of any material contained
// herein is strictly forbidden, unless permitted by WSO2 in accordance with
// the WSO2 Software License available at: https://wso2.com/licenses/eula/3.2
// For specific language governing the permissions and limitations under
// this license, please see the license as well as any agreement you’ve
// entered into with WSO2 governing the purchase of this software and any
// associated services.
//
//
// AUTO-GENERATED FILE.
//
// This file is auto-generated by Ballerina.
// Developers are allowed to modify this file as per the requirement.

import ballerina/http;
import ballerinax/health.fhir.r4;
import ballerinax/health.fhirr4;
import ballerinax/health.fhir.r4.uscore311;
import ballerina/time;

# Generic type to wrap all implemented profiles.
# Add required profile types here.
# public type Observation r4:Observation|<other_Observation_Profile>;
public type Observation uscore311:USCoreSmokingStatusProfile|uscore311:USCorePediatricBMIforAgeObservationProfile|uscore311:USCoreLaboratoryResultObservationProfile
|uscore311:USCorePulseOximetryProfile|uscore311:UsCorePediatricHeadOccipitalFrontalCircumferencePercentileProfile;

# initialize source system endpoint here

# A service representing a network-accessible API
# bound to port `9090`.
service / on new fhirr4:Listener(9095, apiConfig) {

    // Read the current state of single resource based on its id.
    isolated resource function get fhir/r4/Observation/[string id](r4:FHIRContext fhirContext) returns Observation|r4:OperationOutcome|r4:FHIRError|error {
        lock {
            foreach json val in data {
                map<json> fhirResource = check val.ensureType();
                if (fhirResource.resourceType == "Observation" && fhirResource.id == id) {
                    Observation documentReference = check fhirResource.cloneWithType(Observation);
                    return documentReference.clone();
                }
            }
        }
        return r4:createFHIRError("Not found", r4:ERROR, r4:INFORMATIONAL, httpStatusCode = http:STATUS_NOT_FOUND);
    }

    // Read the state of a specific version of a resource based on its id.
    isolated resource function get fhir/r4/Observation/[string id]/_history/[string vid](r4:FHIRContext fhirContext) returns Observation|r4:OperationOutcome|r4:FHIRError {
        return r4:createFHIRError("Not implemented", r4:ERROR, r4:INFORMATIONAL, httpStatusCode = http:STATUS_NOT_IMPLEMENTED);
    }

    // Search for resources based on a set of criteria.
    isolated resource function get fhir/r4/Observation(r4:FHIRContext fhirContext) returns r4:Bundle|r4:OperationOutcome|r4:FHIRError|error {

        return filterData(fhirContext);
    }

    // Create a new resource.
    isolated resource function post fhir/r4/Observation(r4:FHIRContext fhirContext, Observation procedure) returns Observation|r4:OperationOutcome|r4:FHIRError {
        return r4:createFHIRError("Not implemented", r4:ERROR, r4:INFORMATIONAL, httpStatusCode = http:STATUS_NOT_IMPLEMENTED);
    }

    // Update the current state of a resource completely.
    isolated resource function put fhir/r4/Observation/[string id](r4:FHIRContext fhirContext, Observation observation) returns Observation|r4:OperationOutcome|r4:FHIRError {
        return r4:createFHIRError("Not implemented", r4:ERROR, r4:INFORMATIONAL, httpStatusCode = http:STATUS_NOT_IMPLEMENTED);
    }

    // Update the current state of a resource partially.
    isolated resource function patch fhir/r4/Observation/[string id](r4:FHIRContext fhirContext, json patch) returns Observation|r4:OperationOutcome|r4:FHIRError {
        return r4:createFHIRError("Not implemented", r4:ERROR, r4:INFORMATIONAL, httpStatusCode = http:STATUS_NOT_IMPLEMENTED);
    }

    // Delete a resource.
    isolated resource function delete fhir/r4/Observation/[string id](r4:FHIRContext fhirContext) returns r4:OperationOutcome|r4:FHIRError {
        return r4:createFHIRError("Not implemented", r4:ERROR, r4:INFORMATIONAL, httpStatusCode = http:STATUS_NOT_IMPLEMENTED);
    }

    // Retrieve the update history for a particular resource.
    isolated resource function get fhir/r4/Observation/[string id]/_history(r4:FHIRContext fhirContext) returns r4:Bundle|r4:OperationOutcome|r4:FHIRError {
        return r4:createFHIRError("Not implemented", r4:ERROR, r4:INFORMATIONAL, httpStatusCode = http:STATUS_NOT_IMPLEMENTED);
    }

    // Retrieve the update history for all resources.
    isolated resource function get fhir/r4/Observation/_history(r4:FHIRContext fhirContext) returns r4:Bundle|r4:OperationOutcome|r4:FHIRError {
        return r4:createFHIRError("Not implemented", r4:ERROR, r4:INFORMATIONAL, httpStatusCode = http:STATUS_NOT_IMPLEMENTED);
    }

    // post search request
    isolated resource function post fhir/r4/Observation/_search(r4:FHIRContext fhirContext) returns r4:FHIRError|http:Response {
        r4:Bundle|error result = filterData(fhirContext);
        if result is r4:Bundle {
            http:Response response = new;
            response.statusCode = http:STATUS_OK;
            response.setPayload(result.clone().toJson());
            return response;
        } else {
            return r4:createFHIRError("Not found", r4:ERROR, r4:INFORMATIONAL, httpStatusCode = http:STATUS_NOT_FOUND);
        }
    }
}

configurable string baseUrl = "localhost:9091/fhir/r4";
final http:Client apiClient = check new (baseUrl);

isolated function addRevInclude(string revInclude, r4:Bundle bundle, int entryCount, string apiName) returns r4:Bundle|error {

    if revInclude == "" {
        return bundle;
    }
    string[] ids = check buildSearchIds(bundle, apiName);
    if ids.length() == 0 {
        return bundle;
    }

    int count = entryCount;
    http:Response response = check apiClient->/Provenance(target = string:'join(",", ...ids));
    if (response.statusCode == 200) {
        json fhirResource = check response.getJsonPayload();
        json[] entries = check fhirResource.entry.ensureType();
        foreach json entry in entries {
            map<json> entryResource = check entry.'resource.ensureType();
            string entryUrl = check entry.fullUrl.ensureType();
            r4:BundleEntry bundleEntry = {fullUrl: entryUrl, 'resource: entryResource};
            bundle.entry[count] = bundleEntry;
            count += 1;
        }
    }
    return bundle;
}

isolated function buildSearchIds(r4:Bundle bundle, string apiName) returns string[]|error {
    r4:BundleEntry[] entries = check bundle.entry.ensureType();
    string[] searchIds = [];
    foreach r4:BundleEntry entry in entries {
        var entryResource = entry?.'resource;
        if (entryResource == ()) {
            continue;
        }
        map<json> entryResourceJson = check entryResource.ensureType();
        string id = check entryResourceJson.id.ensureType();
        string resourceType = check entryResourceJson.resourceType.ensureType();
        if (resourceType == apiName) {
            searchIds.push(resourceType + "/" + id);
        }
    }
    return searchIds;
}

isolated function filterData(r4:FHIRContext fhirContext) returns r4:FHIRError|r4:Bundle|error|error {
    r4:StringSearchParameter[] idParam = check fhirContext.getStringSearchParameter("_id") ?: [];
    string[] ids = [];
    foreach r4:StringSearchParameter item in idParam {
        string id = check item.value.ensureType();
        ids.push(id);
    }
    r4:TokenSearchParameter[] statusParam = check fhirContext.getTokenSearchParameter("status") ?: [];
    string[] statuses = [];
    foreach r4:TokenSearchParameter item in statusParam {
        string id = check item.code.ensureType();
        statuses.push(id);
    }
    r4:TokenSearchParameter[] categoryParam = check fhirContext.getTokenSearchParameter("category") ?: [];
    string[] categories = [];
    foreach r4:TokenSearchParameter item in categoryParam {
        string id = check item.code.ensureType();
        categories.push(id);
    }
    r4:TokenSearchParameter[] codeParam = check fhirContext.getTokenSearchParameter("code") ?: [];
    string[] codes = [];
    foreach r4:TokenSearchParameter item in codeParam {
        string id = check item.code.ensureType();
        codes.push(id);
    }
    r4:ReferenceSearchParameter[] patientParam = check fhirContext.getReferenceSearchParameter("patient") ?: [];
    string[] patients = [];
    foreach r4:ReferenceSearchParameter item in patientParam {
        string id = check item.id.ensureType();
        patients.push("Patient/" + id);
    }
    r4:DateSearchParameter[] dateParam = check fhirContext.getDateSearchParameter("date") ?: [];
    time:Utc[] dates = [];
    foreach r4:DateSearchParameter item in dateParam {
        time:Civil date = check item.value.ensureType();
        dates.push(check time:utcFromCivil(date));
    }
    r4:TokenSearchParameter[] revIncludeParam = check fhirContext.getTokenSearchParameter("_revinclude") ?: [];
    string revInclude = revIncludeParam != [] ? check revIncludeParam[0].code.ensureType() : "";
    lock {

        r4:Bundle bundle = {identifier: {system: ""}, 'type: "searchset", entry: []};
        r4:BundleEntry bundleEntry = {};
        int count = 0;
        // filter by id
        json[] resultSet = data;
        json[] idFilteredData = [];
        if (ids.length() > 0) {
            foreach json val in resultSet {
                map<json> fhirResource = check val.ensureType();
                if fhirResource.hasKey("id") {
                    string id = check fhirResource.id.ensureType();
                    if (fhirResource.resourceType == "Observation" && ids.indexOf(id) > -1) {
                        idFilteredData.push(fhirResource);
                        continue;
                    }
                }
            }
            resultSet = idFilteredData;
        }

        // filter by patient
        json[] patientFilteredData = [];
        if (patients.length() > 0) {
            foreach json val in resultSet {
                map<json> fhirResource = check val.ensureType();
                if fhirResource.hasKey("subject") {
                    map<json> patient = check fhirResource.subject.ensureType();
                    if patient.hasKey("reference") {
                        string patientRef = check patient.reference.ensureType();
                        if (patients.indexOf(patientRef) > -1) {
                            patientFilteredData.push(fhirResource);
                            continue;
                        }
                    }
                }
            }
            resultSet = patientFilteredData;
        }

        // filter by date
        json[] dateFilteredData = [];
        if (dates.length() > 0) {
            foreach json val in resultSet {
                map<json> fhirResource = check val.ensureType();
                if fhirResource.hasKey("effectiveDateTime") {
                    string dateTime = check fhirResource.effectiveDateTime.ensureType();
                    if (dates.indexOf(check time:utcFromString(dateTime)) > -1) {
                        dateFilteredData.push(fhirResource);
                        continue;
                    }
                }
            }
            resultSet = dateFilteredData;
        }

        // filter by category
        json[] categoryFilteredData = [];
        if (categories.length() > 0) {
            foreach json val in resultSet {
                map<json> fhirResource = check val.ensureType();
                if fhirResource.hasKey("category") {
                    json[] categoryResources = check fhirResource.category.ensureType();
                    foreach json category in categoryResources {
                        map<json> categoryResource = check category.ensureType();
                        if categoryResource.hasKey("coding") {
                            json[] coding = check categoryResource.coding.ensureType();
                            foreach json codingItem in coding {
                                map<json> codingResource = check codingItem.ensureType();
                                if codingResource.hasKey("code") {
                                    string code = check codingResource.code.ensureType();
                                    if (categories.indexOf(code) > -1) {
                                        categoryFilteredData.push(fhirResource);
                                        continue;
                                    }
                                }

                            }
                        }
                    }
                }
            }
            resultSet = categoryFilteredData;
        }

        // filter by status
        json[] statusFilteredData = [];
        if (statuses.length() > 0) {
            foreach json val in resultSet {
                map<json> fhirResource = check val.ensureType();
                if fhirResource.hasKey("status") {
                    string status = check fhirResource.status.ensureType();

                    if (statuses.indexOf(status) > -1) {
                        statusFilteredData.push(fhirResource);
                        continue;
                    }

                }
            }
            resultSet = statusFilteredData;
        }

        // filter by code
        json[] codeFilteredData = [];
        if (codes.length() > 0) {
            foreach json val in resultSet {
                map<json> fhirResource = check val.ensureType();
                if fhirResource.hasKey("code") {
                    map<json> codeElement = check fhirResource.code.ensureType();
                    if codeElement.hasKey("coding") {
                        json[] coding = check codeElement.coding.ensureType();
                        foreach json codingItem in coding {
                            map<json> codingResource = check codingItem.ensureType();
                            if codingResource.hasKey("code") {
                                string code = check codingResource.code.ensureType();
                                if (codes.indexOf(code) > -1) {
                                    codeFilteredData.push(fhirResource);
                                    continue;
                                }
                            }
                        }
                    }
                }
            }
            resultSet = codeFilteredData;
        }

        foreach json item in resultSet {
            bundleEntry = {fullUrl: "", 'resource: item};
            bundle.entry[count] = bundleEntry;
            count += 1;
        }

        if bundle.entry != [] {
            return addRevInclude(revInclude, bundle, count, "Observation").clone();
        }
        return bundle.clone();
    }

}

isolated json[] data = [
    {
        "resourceType": "Observation",
        "id": "110ef0f6-304e-4293-846d-5b9d873565a1",
        "status": "final",
        "category": [
            {
                "coding": [
                    {
                        "system": "http://terminology.hl7.org/CodeSystem/observation-category",
                        "code": "vital-signs",
                        "display": "Vital Signs"
                    }
                ]
            }
        ],
        "code": {
            "coding": [
                {
                    "system": "http://loinc.org",
                    "code": "8867-4",
                    "display": "Heart rate"
                }
            ],
            "text": "Heart rate"
        },
        "subject": {
            "reference": "Patient/example"
        },
        "issued": "1940-05-03T01:11:45.131-04:00",
        "effectiveDateTime": "2025-02-26T10:00:00Z",
        "valueCodeableConcept": {
            "coding": [
                {
                    "system": "http://snomed.info/sct",
                    "code": "266919005",
                    "display": "Never smoked"
                }
            ],
            "text": "Never smoked"
        },
        "valueQuantity": {
            "value": 72,
            "unit": "beats/minute",
            "system": "http://unitsofmeasure.org",
            "code": "/min"
        }
    },
    {
        "resourceType": "Observation",
        "id": "093a7771-972c-45fb-a42a-8b4199f4c61d",
        "status": "final",
        "issued": "1940-05-03T01:11:45.131-04:00",
        "category": [
            {
                "coding": [
                    {
                        "system": "http://terminology.hl7.org/CodeSystem/observation-category",
                        "code": "vital-signs",
                        "display": "Vital Signs"
                    }
                ]
            }
        ],
        "code": {
            "coding": [
                {
                    "system": "http://loinc.org",
                    "code": "8867-4",
                    "display": "Heart rate"
                }
            ],
            "text": "Heart rate"

        },
        "subject": {
            "reference": "Patient/2"
        },
        "effectiveDateTime": "2025-02-26T10:00:00Z",
        "valueCodeableConcept": {
            "coding": [
                {
                    "system": "http://snomed.info/sct",
                    "code": "266919005",
                    "display": "Never smoked"
                }
            ],
            "text": "Never smoked"
        }
    },
    {
        "resourceType": "Observation",
        "id": "0cbfa230-ec31-4ac4-aa23-14911c6980c3",
        "status": "final",
        "issued": "1940-05-03T01:11:45.131-04:00",
        "category": [
            {
                "coding": [
                    {
                        "system": "http://terminology.hl7.org/CodeSystem/observation-category",
                        "code": "social-history",
                        "display": "Social History"
                    }
                ]
            }
        ],
        "code": {
            "coding": [
                {
                    "system": "http://loinc.org",
                    "code": "72166-2",
                    "display": "Tobacco smoking status"
                }
            ],
            "text": "Tobacco smoking status"
        },
        "subject": {
            "reference": "Patient/1"
        },
        "effectiveDateTime": "2025-02-26T10:00:00Z",
        "valueCodeableConcept": {
            "coding": [
                {
                    "system": "http://snomed.info/sct",
                    "code": "266919005",
                    "display": "Never smoked"
                }
            ],
            "text": "Never smoked"
        }
    },
    {
        "resourceType": "Observation",
        "id": "oxygen-saturation-patient-1",
        "meta": {
            "profile": [
                "http://hl7.org/fhir/us/core/StructureDefinition/us-core-oxygen-saturation"
            ]
        },
        "status": "final",
        "category": [
            {
                "coding": [
                    {
                        "system": "http://terminology.hl7.org/CodeSystem/observation-category",
                        "code": "vital-signs",
                        "display": "Vital Signs"
                    }
                ],
                "text": "Vital Signs"
            }
        ],
        "code": {
            "coding": [
                {
                    "system": "http://loinc.org",
                    "code": "2708-6",
                    "display": "Oxygen saturation in Arterial blood"
                },

                {
                    "system": "http://loinc.org",
                    "code": "59408-5",
                    "display": "Oxygen saturation in Arterial blood by Pulse oximetry"
                }
            ],
            "text": "Oxygen saturation in Arterial blood"
        },
        "subject": {
            "reference": "Patient/1"
        },
        "encounter": {
            "reference": "Encounter/example"
        },
        "effectiveDateTime": "2024-02-15T10:10:00Z",
        "issued": "2024-02-15T10:15:00Z",
        "performer": [
            {
                "reference": "Practitioner/example"
            }
        ],
        "valueQuantity": {
            "value": 98,
            "unit": "%",
            "system": "http://unitsofmeasure.org",
            "code": "%"
        },
        "device": {
            "reference": "Device/example",
            "display": "Pulse Oximeter"
        }
    },
    {
        "resourceType": "Observation",
        "id": "urobilinogen-patient-1",
        "meta": {
            "profile": [
                "http://hl7.org/fhir/us/core/StructureDefinition/us-core-lab-result-observation"
            ]
        },
        "status": "final",
        "category": [
            {
                "coding": [
                    {
                        "system": "http://terminology.hl7.org/CodeSystem/observation-category",
                        "code": "laboratory",
                        "display": "Laboratory"
                    }
                ],
                "text": "Laboratory"
            }
        ],
        "code": {
            "coding": [
                {
                    "system": "http://loinc.org",
                    "code": "20405-7",
                    "display": "Urobilinogen [Presence] in Urine by Test strip"
                }
            ],
            "text": "Urobilinogen in Urine"
        },
        "subject": {
            "reference": "Patient/1"
        },
        "encounter": {
            "reference": "Encounter/example"
        },
        "effectiveDateTime": "2024-02-15T10:10:00Z",
        "issued": "2024-02-15T10:15:00Z",
        "performer": [
            {
                "reference": "Practitioner/example"
            }
        ],
        "valueQuantity": {
            "value": 0.2,
            "unit": "mg/dL",
            "system": "http://unitsofmeasure.org",
            "code": "mg/dL"
        }
    },
    {
        "resourceType": "Observation",
        "id": "pediatric-bmi-patient-1",
        "meta": {
            "profile": [
                "http://hl7.org/fhir/us/core/StructureDefinition/pediatric-bmi-for-age"
            ]
        },
        "status": "final",
        "category": [
            {
                "coding": [
                    {
                        "system": "http://terminology.hl7.org/CodeSystem/observation-category",
                        "code": "vital-signs",
                        "display": "Vital Signs"
                    }
                ],
                "text": "Vital Signs"
            }
        ],
        "code": {
            "coding": [
                {
                    "system": "http://loinc.org",
                    "code": "59576-9",
                    "display": "Body mass index (BMI) [Percentile] Per age and gender"
                }
            ],
            "text": "Pediatric BMI for Age"
        },
        "subject": {
            "reference": "Patient/1"
        },
        "encounter": {
            "reference": "Encounter/example"
        },
        "effectiveDateTime": "2024-02-15T10:10:00Z",
        "issued": "2024-02-15T10:15:00Z",
        "performer": [
            {
                "reference": "Practitioner/example"
            }
        ],
        "valueQuantity": {
            "value": 85,
            "unit": "%",
            "system": "http://unitsofmeasure.org",
            "code": "%"
        },
        "interpretation": [
            {
                "coding": [
                    {
                        "system": "http://terminology.hl7.org/CodeSystem/v3-ObservationInterpretation",
                        "code": "N",
                        "display": "Normal"
                    }
                ],
                "text": "Normal"
            }
        ],
        "bodySite": {
            "coding": [
                {
                    "system": "http://snomed.info/sct",
                    "code": "38266002",
                    "display": "Entire Body"
                }
            ],
            "text": "Entire Body"
        },
        "method": {
            "coding": [
                {
                    "system": "http://snomed.info/sct",
                    "code": "702927004",
                    "display": "Body mass index percentile method"
                }
            ],
            "text": "BMI Percentile Method"
        }
    },
    {
  "resourceType": "Observation",
  "id": "pediatric-weight-height-patient-1",
  "meta": {
    "profile": [
      "http://hl7.org/fhir/us/core/StructureDefinition/pediatric-weight-for-height"
    ]
  },
  "status": "final",
  "category": [
    {
      "coding": [
        {
          "system": "http://terminology.hl7.org/CodeSystem/observation-category",
          "code": "vital-signs",
          "display": "Vital Signs"
        }
      ],
      "text": "Vital Signs"
    }
  ],
  "code": {
    "coding": [
      {
        "system": "http://loinc.org",
        "code": "77606-2",
        "display": "Weight-for-length Per age and sex"
      }
    ],
    "text": "Pediatric Weight-for-Height"
  },
  "subject": {
    "reference": "Patient/1"
  },
  "encounter": {
    "reference": "Encounter/example"
  },
  "effectiveDateTime": "2024-02-15T10:30:00Z",
  "issued": "2024-02-15T10:35:00Z",
  "performer": [
    {
      "reference": "Practitioner/example"
    }
  ],
  "valueQuantity": {
    "value": 90,
    "unit": "%",
    "system": "http://unitsofmeasure.org",
    "code": "%"
  },
  "interpretation": [
    {
      "coding": [
        {
          "system": "http://terminology.hl7.org/CodeSystem/v3-ObservationInterpretation",
          "code": "H",
          "display": "High"
        }
      ],
      "text": "High"
    }
  ],
  "bodySite": {
    "coding": [
      {
        "system": "http://snomed.info/sct",
        "code": "38266002",
        "display": "Entire Body"
      }
    ],
    "text": "Entire Body"
  },
  "method": {
    "coding": [
      {
        "system": "http://snomed.info/sct",
        "code": "702927004",
        "display": "Weight-for-height percentile method"
      }
    ],
    "text": "Weight-for-Height Percentile Method"
  }
}


];
