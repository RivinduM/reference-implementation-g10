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
import ballerinax/health.fhir.r4.parser as fhirParser;
import ballerinax/health.fhir.r4.uscore311;

# Generic type to wrap all implemented profiles.
# Add required profile types here.
# public type AllergyIntolerance r4:AllergyIntolerance|<other_AllergyIntolerance_Profile>;
public type AllergyIntolerance uscore311:USCoreAllergyIntolerance;

# initialize source system endpoint here

# A service representing a network-accessible API
# bound to port `9090`.
service / on new fhirr4:Listener(9090, apiConfig) {

    // Read the current state of single resource based on its id.
    isolated resource function get fhir/r4/AllergyIntolerance/[string id](r4:FHIRContext fhirContext) returns AllergyIntolerance|r4:OperationOutcome|r4:FHIRError|error {
        lock {
            foreach json val in data {
                map<json> fhirResource = check val.ensureType();
                if (fhirResource.resourceType == "AllergyIntolerance" && fhirResource.id == id) {
                    AllergyIntolerance allergy = check fhirParser:parse(fhirResource, uscore311:USCoreAllergyIntolerance).ensureType();
                    return allergy.clone();
                }
            }
        }
        return r4:createFHIRError("Not found", r4:ERROR, r4:INFORMATIONAL, httpStatusCode = http:STATUS_NOT_FOUND);
    }

    // Read the state of a specific version of a resource based on its id.
    isolated resource function get fhir/r4/AllergyIntolerance/[string id]/_history/[string vid](r4:FHIRContext fhirContext) returns AllergyIntolerance|r4:OperationOutcome|r4:FHIRError {
        return r4:createFHIRError("Not implemented", r4:ERROR, r4:INFORMATIONAL, httpStatusCode = http:STATUS_NOT_IMPLEMENTED);
    }

    // Search for resources based on a set of criteria.
    isolated resource function get fhir/r4/AllergyIntolerance(r4:FHIRContext fhirContext) returns r4:Bundle|r4:OperationOutcome|r4:FHIRError|error {
        return filterData(fhirContext);
    }

    // Create a new resource.
    isolated resource function post fhir/r4/AllergyIntolerance(r4:FHIRContext fhirContext, AllergyIntolerance procedure) returns AllergyIntolerance|r4:OperationOutcome|r4:FHIRError {
        return r4:createFHIRError("Not implemented", r4:ERROR, r4:INFORMATIONAL, httpStatusCode = http:STATUS_NOT_IMPLEMENTED);
    }

    // Update the current state of a resource completely.
    isolated resource function put fhir/r4/AllergyIntolerance/[string id](r4:FHIRContext fhirContext, AllergyIntolerance allergyintolerance) returns AllergyIntolerance|r4:OperationOutcome|r4:FHIRError {
        return r4:createFHIRError("Not implemented", r4:ERROR, r4:INFORMATIONAL, httpStatusCode = http:STATUS_NOT_IMPLEMENTED);
    }

    // Update the current state of a resource partially.
    isolated resource function patch fhir/r4/AllergyIntolerance/[string id](r4:FHIRContext fhirContext, json patch) returns AllergyIntolerance|r4:OperationOutcome|r4:FHIRError {
        return r4:createFHIRError("Not implemented", r4:ERROR, r4:INFORMATIONAL, httpStatusCode = http:STATUS_NOT_IMPLEMENTED);
    }

    // Delete a resource.
    isolated resource function delete fhir/r4/AllergyIntolerance/[string id](r4:FHIRContext fhirContext) returns r4:OperationOutcome|r4:FHIRError {
        return r4:createFHIRError("Not implemented", r4:ERROR, r4:INFORMATIONAL, httpStatusCode = http:STATUS_NOT_IMPLEMENTED);
    }

    // Retrieve the update history for a particular resource.
    isolated resource function get fhir/r4/AllergyIntolerance/[string id]/_history(r4:FHIRContext fhirContext) returns r4:Bundle|r4:OperationOutcome|r4:FHIRError {
        return r4:createFHIRError("Not implemented", r4:ERROR, r4:INFORMATIONAL, httpStatusCode = http:STATUS_NOT_IMPLEMENTED);
    }

    // Retrieve the update history for all resources.
    isolated resource function get fhir/r4/AllergyIntolerance/_history(r4:FHIRContext fhirContext) returns r4:Bundle|r4:OperationOutcome|r4:FHIRError {
        return r4:createFHIRError("Not implemented", r4:ERROR, r4:INFORMATIONAL, httpStatusCode = http:STATUS_NOT_IMPLEMENTED);
    }

    // post search request
    isolated resource function post fhir/r4/AllergyIntolerance/_search(r4:FHIRContext fhirContext) returns r4:FHIRError|http:Response {
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
    r4:ReferenceSearchParameter[] patientParam = check fhirContext.getReferenceSearchParameter("patient") ?: [];
    string[] patients = [];
    foreach r4:ReferenceSearchParameter item in patientParam {
        string id = check item.id.ensureType();
        patients.push("Patient/" + id);
    }
    r4:TokenSearchParameter[] revIncludeParam = check fhirContext.getTokenSearchParameter("_revinclude") ?: [];
    string revInclude = revIncludeParam != [] ? check revIncludeParam[0].code.ensureType() : "";
    lock {

        r4:Bundle bundle = {identifier: {system: ""}, 'type: "searchset", entry: []};
        r4:BundleEntry bundleEntry = {};
        int count = 0;
        foreach json val in data {
            map<json> fhirResource = check val.ensureType();
            if fhirResource.hasKey("id") {
                string id = check fhirResource.id.ensureType();
                if (fhirResource.resourceType == "AllergyIntolerance" && ids.indexOf(id) > -1) {
                    bundleEntry = {fullUrl: "", 'resource: fhirResource};
                    bundle.entry[count] = bundleEntry;
                    count += 1;
                    continue;
                }
            }
        }

        foreach json val in data {
            map<json> fhirResource = check val.ensureType();
            if fhirResource.hasKey("patient") {
                map<json> patient = check fhirResource.patient.ensureType();
                if patient.hasKey("reference") {
                    string patientRef = check patient.reference.ensureType();
                    if (patients.indexOf(patientRef) > -1) {
                        bundleEntry = {fullUrl: "", 'resource: fhirResource};
                        bundle.entry[count] = bundleEntry;
                        count += 1;
                        continue;
                    }
                }
            }
        }

        if bundle.entry != [] {
            return addRevInclude(revInclude, bundle, count, "AllergyIntolerance").clone();
        }
    }
    return r4:createFHIRError("Not found", r4:ERROR, r4:INFORMATIONAL, httpStatusCode = http:STATUS_NOT_FOUND);
}

isolated json[] data = [
    {
        "resourceType": "AllergyIntolerance",
        "id": "1",
        "meta": {
            "profile": [
                "http://hl7.org/fhir/us/core/StructureDefinition/us-core-allergyintolerance"
            ]
        },
        "clinicalStatus": {
            "coding": [
                {
                    "system": "http://terminology.hl7.org/CodeSystem/allergyintolerance-clinical",
                    "code": "active"
                }
            ]
        },
        "verificationStatus": {
            "coding": [
                {
                    "system": "http://terminology.hl7.org/CodeSystem/allergyintolerance-verification",
                    "code": "confirmed"
                }
            ]
        },
        "category": ["food"],
        "criticality": "high",
        "code": {
            "coding": [
                {
                    "system": "http://snomed.info/sct",
                    "code": "91935009",
                    "display": "Peanut allergy"
                }
            ],
            "text": "Peanut allergy"
        },
        "patient": {
            "reference": "Patient/1",
            "display": "Patient 1"
        },
        "reaction": [
            {
                "manifestation": [
                    {
                        "coding": [
                            {
                                "system": "http://snomed.info/sct",
                                "code": "39579001",
                                "display": "Anaphylactic reaction"
                            }
                        ],
                        "text": "Anaphylaxis"
                    }
                ],
                "severity": "severe"
            }
        ]
    },
    {
        "resourceType": "AllergyIntolerance",
        "id": "2",
        "meta": {
            "profile": [
                "http://hl7.org/fhir/us/core/StructureDefinition/us-core-allergyintolerance"
            ]
        },
        "clinicalStatus": {
            "coding": [
                {
                    "system": "http://terminology.hl7.org/CodeSystem/allergyintolerance-clinical",
                    "code": "active"
                }
            ]
        },
        "verificationStatus": {
            "coding": [
                {
                    "system": "http://terminology.hl7.org/CodeSystem/allergyintolerance-verification",
                    "code": "confirmed"
                }
            ]
        },
        "category": ["medication"],
        "criticality": "high",
        "code": {
            "coding": [
                {
                    "system": "http://snomed.info/sct",
                    "code": "79899007",
                    "display": "Allergy to penicillin"
                }
            ],
            "text": "Penicillin allergy"
        },
        "patient": {
            "reference": "Patient/2",
            "display": "Patient 2"
        },
        "reaction": [
            {
                "manifestation": [
                    {
                        "coding": [
                            {
                                "system": "http://snomed.info/sct",
                                "code": "247472004",
                                "display": "Hives"
                            }
                        ],
                        "text": "Hives"
                    }
                ],
                "severity": "moderate"
            }
        ]
    },
    {
        "resourceType": "AllergyIntolerance",
        "id": "3",
        "meta": {
            "profile": [
                "http://hl7.org/fhir/us/core/StructureDefinition/us-core-allergyintolerance"
            ]
        },
        "clinicalStatus": {
            "coding": [
                {
                    "system": "http://terminology.hl7.org/CodeSystem/allergyintolerance-clinical",
                    "code": "active"
                }
            ]
        },
        "verificationStatus": {
            "coding": [
                {
                    "system": "http://terminology.hl7.org/CodeSystem/allergyintolerance-verification",
                    "code": "confirmed"
                }
            ]
        },
        "category": ["environment"],
        "criticality": "moderate",
        "code": {
            "coding": [
                {
                    "system": "http://snomed.info/sct",
                    "code": "300916003",
                    "display": "Latex allergy"
                }
            ],
            "text": "Latex allergy"
        },
        "patient": {
            "reference": "Patient/4",
            "display": "Patient 4"
        },
        "reaction": [
            {
                "manifestation": [
                    {
                        "coding": [
                            {
                                "system": "http://snomed.info/sct",
                                "code": "422587007",
                                "display": "Contact dermatitis"
                            }
                        ],
                        "text": "Contact dermatitis"
                    }
                ],
                "severity": "mild"
            }
        ]
    }
];
