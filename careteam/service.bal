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
# public type CareTeam r4:CareTeam|<other_CareTeam_Profile>;
public type CareTeam uscore311:USCoreCareTeam;

# initialize source system endpoint here

# A service representing a network-accessible API
# bound to port `9090`.
service / on new fhirr4:Listener(9090, apiConfig) {

    // Read the current state of single resource based on its id.
    isolated resource function get fhir/r4/CareTeam/[string id](r4:FHIRContext fhirContext) returns CareTeam|r4:OperationOutcome|r4:FHIRError|error {
        lock {
            foreach json val in data {
                map<json> fhirResource = check val.ensureType();
                if (fhirResource.resourceType == "CareTeam" && fhirResource.id == id) {
                    CareTeam careteam = check fhirParser:parse(fhirResource, uscore311:USCoreCareTeam).ensureType();
                    return careteam.clone();
                }
            }
        }
        return r4:createFHIRError("Not found", r4:ERROR, r4:INFORMATIONAL, httpStatusCode = http:STATUS_NOT_FOUND);
    }

    // Read the state of a specific version of a resource based on its id.
    isolated resource function get fhir/r4/CareTeam/[string id]/_history/[string vid](r4:FHIRContext fhirContext) returns CareTeam|r4:OperationOutcome|r4:FHIRError {
        return r4:createFHIRError("Not implemented", r4:ERROR, r4:INFORMATIONAL, httpStatusCode = http:STATUS_NOT_IMPLEMENTED);
    }

    // Search for resources based on a set of criteria.
    isolated resource function get fhir/r4/CareTeam(r4:FHIRContext fhirContext) returns r4:Bundle|r4:OperationOutcome|r4:FHIRError|error {
        return check filterData(fhirContext);
    }

    // Create a new resource.
    isolated resource function post fhir/r4/CareTeam(r4:FHIRContext fhirContext, CareTeam procedure) returns CareTeam|r4:OperationOutcome|r4:FHIRError {
        return r4:createFHIRError("Not implemented", r4:ERROR, r4:INFORMATIONAL, httpStatusCode = http:STATUS_NOT_IMPLEMENTED);
    }

    // Update the current state of a resource completely.
    isolated resource function put fhir/r4/CareTeam/[string id](r4:FHIRContext fhirContext, CareTeam careteam) returns CareTeam|r4:OperationOutcome|r4:FHIRError {
        return r4:createFHIRError("Not implemented", r4:ERROR, r4:INFORMATIONAL, httpStatusCode = http:STATUS_NOT_IMPLEMENTED);
    }

    // Update the current state of a resource partially.
    isolated resource function patch fhir/r4/CareTeam/[string id](r4:FHIRContext fhirContext, json patch) returns CareTeam|r4:OperationOutcome|r4:FHIRError {
        return r4:createFHIRError("Not implemented", r4:ERROR, r4:INFORMATIONAL, httpStatusCode = http:STATUS_NOT_IMPLEMENTED);
    }

    // Delete a resource.
    isolated resource function delete fhir/r4/CareTeam/[string id](r4:FHIRContext fhirContext) returns r4:OperationOutcome|r4:FHIRError {
        return r4:createFHIRError("Not implemented", r4:ERROR, r4:INFORMATIONAL, httpStatusCode = http:STATUS_NOT_IMPLEMENTED);
    }

    // Retrieve the update history for a particular resource.
    isolated resource function get fhir/r4/CareTeam/[string id]/_history(r4:FHIRContext fhirContext) returns r4:Bundle|r4:OperationOutcome|r4:FHIRError {
        return r4:createFHIRError("Not implemented", r4:ERROR, r4:INFORMATIONAL, httpStatusCode = http:STATUS_NOT_IMPLEMENTED);
    }

    // Retrieve the update history for all resources.
    isolated resource function get fhir/r4/CareTeam/_history(r4:FHIRContext fhirContext) returns r4:Bundle|r4:OperationOutcome|r4:FHIRError {
        return r4:createFHIRError("Not implemented", r4:ERROR, r4:INFORMATIONAL, httpStatusCode = http:STATUS_NOT_IMPLEMENTED);
    }

    // post search request
    isolated resource function post fhir/r4/CareTeam/_search(r4:FHIRContext fhirContext) returns r4:FHIRError|http:Response {
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
        // filter by id
        json[] resultSet = data;
        if (ids.length() > 0) {
            foreach json val in resultSet {
                map<json> fhirResource = check val.ensureType();
                if fhirResource.hasKey("id") {
                    string id = check fhirResource.id.ensureType();
                    if (fhirResource.resourceType == "CareTeam" && ids.indexOf(id) > -1) {
                        resultSet.push(fhirResource);
                        continue;
                    }
                }
            }
        }

        resultSet = resultSet.length() > 0 ? resultSet : data;
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

        foreach json item in resultSet {
            bundleEntry = {fullUrl: "", 'resource: item};
            bundle.entry[count] = bundleEntry;
            count += 1;
        }

        if bundle.entry != [] {
            return addRevInclude(revInclude, bundle, count, "CareTeam").clone();
        }
        return bundle.clone();
    }
    
}

isolated json[] data = [
    {
        "resourceType": "CareTeam",
        "id": "1",
        "meta": {
            "profile": [
                "http://hl7.org/fhir/us/core/StructureDefinition/us-core-careteam"
            ]
        },
        "text": {
            "status": "generated",
            "div": "<div xmlns=\"http://www.w3.org/1999/xhtml\"><p><b>Generated Narrative</b></p><p><b>id</b>: hypertension-careteam</p><p><b>status</b>: active</p><p><b>name</b>: Hypertension Management Team</p><p><b>subject</b>: John Doe</p><blockquote><p><b>participant</b></p><p><b>role</b>: Cardiology</p><p><b>member</b>: Dr. Susan Adams, MD</p></blockquote><blockquote><p><b>participant</b></p><p><b>role</b>: General Practice</p><p><b>member</b>: Dr. Mark Johnson, MD</p></blockquote><blockquote><p><b>participant</b></p><p><b>role</b>: Patient</p><p><b>member</b>: John Doe</p></blockquote></div>"
        },
        "status": "proposed",
        "name": "Hypertension Management Team",
        "subject": {
            "reference": "Patient/1",
            "display": "John Doe"
        },
        "participant": [
            {
                "role": [
                    {
                        "coding": [
                            {
                                "system": "http://nucc.org/provider-taxonomy",
                                "code": "207RC0000X",
                                "display": "Cardiology"
                            }
                        ]
                    }
                ],
                "member": {
                    "reference": "Practitioner/333",
                    "display": "Dr. Susan Adams, MD"
                }
            },
            {
                "role": [
                    {
                        "coding": [
                            {
                                "system": "http://nucc.org/provider-taxonomy",
                                "code": "208D00000X",
                                "display": "General Practice"
                            }
                        ]
                    }
                ],
                "member": {
                    "reference": "Practitioner/111",
                    "display": "Dr. Mark Johnson, MD"
                }
            },
            {
                "role": [
                    {
                        "coding": [
                            {
                                "system": "http://snomed.info/sct",
                                "code": "116154003",
                                "display": "Patient (person)"
                            }
                        ]
                    }
                ],
                "member": {
                    "reference": "Patient/1",
                    "display": "John Doe"
                }
            }
        ]
    },
    {
        "resourceType": "CareTeam",
        "id": "2",
        "meta": {
            "profile": [
                "http://hl7.org/fhir/us/core/StructureDefinition/us-core-careteam"
            ]
        },
        "text": {
            "status": "generated",
            "div": "<div xmlns=\"http://www.w3.org/1999/xhtml\"><p><b>Generated Narrative</b></p><p><b>id</b>: diabetes-careteam</p><p><b>status</b>: active</p><p><b>name</b>: Diabetes Care Team</p><p><b>subject</b>: Jane Smith</p><blockquote><p><b>participant</b></p><p><b>role</b>: Endocrinology</p><p><b>member</b>: Dr. Robert Lee, MD</p></blockquote><blockquote><p><b>participant</b></p><p><b>role</b>: General Practice</p><p><b>member</b>: Dr. Emily Carter, MD</p></blockquote><blockquote><p><b>participant</b></p><p><b>role</b>: Patient</p><p><b>member</b>: Jane Smith</p></blockquote></div>"
        },
        "status": "active",
        "name": "Diabetes Care Team",
        "subject": {
            "reference": "Patient/2",
            "display": "Jane Smith"
        },
        "participant": [
            {
                "role": [
                    {
                        "coding": [
                            {
                                "system": "http://nucc.org/provider-taxonomy",
                                "code": "207RE0101X",
                                "display": "Endocrinology"
                            }
                        ]
                    }
                ],
                "member": {
                    "reference": "Practitioner/111",
                    "display": "Dr. Robert Lee, MD"
                }
            },
            {
                "role": [
                    {
                        "coding": [
                            {
                                "system": "http://nucc.org/provider-taxonomy",
                                "code": "208D00000X",
                                "display": "General Practice"
                            }
                        ]
                    }
                ],
                "member": {
                    "reference": "Practitioner/333",
                    "display": "Dr. Emily Carter, MD"
                }
            },
            {
                "role": [
                    {
                        "coding": [
                            {
                                "system": "http://snomed.info/sct",
                                "code": "116154003",
                                "display": "Patient (person)"
                            }
                        ]
                    }
                ],
                "member": {
                    "reference": "Patient/2",
                    "display": "Jane Smith"
                }
            }
        ]
    },
    {
        "resourceType": "CareTeam",
        "id": "3",
        "meta": {
            "profile": [
                "http://hl7.org/fhir/us/core/StructureDefinition/us-core-careteam"
            ]
        },
        "text": {
            "status": "generated",
            "div": "<div xmlns=\"http://www.w3.org/1999/xhtml\"><p><b>Generated Narrative</b></p><p><b>id</b>: asthma-careteam</p><p><b>status</b>: active</p><p><b>name</b>: Asthma Care Team</p><p><b>subject</b>: Michael Brown</p><blockquote><p><b>participant</b></p><p><b>role</b>: Pulmonology</p><p><b>member</b>: Dr. Lisa Morgan, MD</p></blockquote><blockquote><p><b>participant</b></p><p><b>role</b>: General Practice</p><p><b>member</b>: Dr. Alan Smith, MD</p></blockquote><blockquote><p><b>participant</b></p><p><b>role</b>: Patient</p><p><b>member</b>: Michael Brown</p></blockquote></div>"
        },
        "status": "active",
        "name": "Asthma Care Team",
        "subject": {
            "reference": "Patient/4",
            "display": "Michael Brown"
        },
        "participant": [
            {
                "role": [
                    {
                        "coding": [
                            {
                                "system": "http://nucc.org/provider-taxonomy",
                                "code": "207RP1001X",
                                "display": "Pulmonology"
                            }
                        ]
                    }
                ],
                "member": {
                    "reference": "Practitioner/practitioner-7",
                    "display": "Dr. Lisa Morgan, MD"
                }
            },
            {
                "role": [
                    {
                        "coding": [
                            {
                                "system": "http://nucc.org/provider-taxonomy",
                                "code": "208D00000X",
                                "display": "General Practice"
                            }
                        ]
                    }
                ],
                "member": {
                    "reference": "Practitioner/practitioner-8",
                    "display": "Dr. Alan Smith, MD"
                }
            },
            {
                "role": [
                    {
                        "coding": [
                            {
                                "system": "http://snomed.info/sct",
                                "code": "116154003",
                                "display": "Patient (person)"
                            }
                        ]
                    }
                ],
                "member": {
                    "reference": "Patient/4",
                    "display": "Michael Brown"
                }
            }
        ]
    }
];
