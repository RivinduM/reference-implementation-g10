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
import ballerina/time;
import ballerinax/health.fhir.r4;
import ballerinax/health.fhirr4;
import ballerinax/health.fhir.r4.uscore700;

# Generic type to wrap all implemented profiles.
# Add required profile types here.
# public type Procedure r4:Procedure|<other_Procedure_Profile>;
public type Procedure uscore700:USCoreProcedureProfile;

# initialize source system endpoint here

# A service representing a network-accessible API
# bound to port `9090`.
service / on new fhirr4:Listener(9090, apiConfig) {

    // Read the current state of single resource based on its id.
    isolated resource function get fhir/r4/Procedure/[string id](r4:FHIRContext fhirContext) returns Procedure|r4:OperationOutcome|r4:FHIRError|error {
        lock {
            foreach json val in data {
                map<json> fhirResource = check val.ensureType();
                if (fhirResource.resourceType == "Procedure" && fhirResource.id == id) {
                    Procedure procedure = check fhirResource.cloneWithType(Procedure);
                    return procedure.clone();
                }
            }
        }
        return r4:createFHIRError("Not found", r4:ERROR, r4:INFORMATIONAL, httpStatusCode = http:STATUS_NOT_FOUND);
    }

    // Read the state of a specific version of a resource based on its id.
    isolated resource function get fhir/r4/Procedure/[string id]/_history/[string vid](r4:FHIRContext fhirContext) returns Procedure|r4:OperationOutcome|r4:FHIRError {
        return r4:createFHIRError("Not implemented", r4:ERROR, r4:INFORMATIONAL, httpStatusCode = http:STATUS_NOT_IMPLEMENTED);
    }

    // Search for resources based on a set of criteria.
    isolated resource function get fhir/r4/Procedure(r4:FHIRContext fhirContext) returns r4:Bundle|r4:OperationOutcome|r4:FHIRError|error {
        return filterData(fhirContext);
    }

    // Create a new resource.
    isolated resource function post fhir/r4/Procedure(r4:FHIRContext fhirContext, Procedure procedure) returns Procedure|r4:OperationOutcome|r4:FHIRError {
        return r4:createFHIRError("Not implemented", r4:ERROR, r4:INFORMATIONAL, httpStatusCode = http:STATUS_NOT_IMPLEMENTED);
    }

    // Update the current state of a resource completely.
    isolated resource function put fhir/r4/Procedure/[string id](r4:FHIRContext fhirContext, Procedure procedure) returns Procedure|r4:OperationOutcome|r4:FHIRError {
        return r4:createFHIRError("Not implemented", r4:ERROR, r4:INFORMATIONAL, httpStatusCode = http:STATUS_NOT_IMPLEMENTED);
    }

    // Update the current state of a resource partially.
    isolated resource function patch fhir/r4/Procedure/[string id](r4:FHIRContext fhirContext, json patch) returns Procedure|r4:OperationOutcome|r4:FHIRError {
        return r4:createFHIRError("Not implemented", r4:ERROR, r4:INFORMATIONAL, httpStatusCode = http:STATUS_NOT_IMPLEMENTED);
    }

    // Delete a resource.
    isolated resource function delete fhir/r4/Procedure/[string id](r4:FHIRContext fhirContext) returns r4:OperationOutcome|r4:FHIRError {
        return r4:createFHIRError("Not implemented", r4:ERROR, r4:INFORMATIONAL, httpStatusCode = http:STATUS_NOT_IMPLEMENTED);
    }

    // Retrieve the update history for a particular resource.
    isolated resource function get fhir/r4/Procedure/[string id]/_history(r4:FHIRContext fhirContext) returns r4:Bundle|r4:OperationOutcome|r4:FHIRError {
        return r4:createFHIRError("Not implemented", r4:ERROR, r4:INFORMATIONAL, httpStatusCode = http:STATUS_NOT_IMPLEMENTED);
    }

    // Retrieve the update history for all resources.
    isolated resource function get fhir/r4/Procedure/_history(r4:FHIRContext fhirContext) returns r4:Bundle|r4:OperationOutcome|r4:FHIRError {
        return r4:createFHIRError("Not implemented", r4:ERROR, r4:INFORMATIONAL, httpStatusCode = http:STATUS_NOT_IMPLEMENTED);
    }

    // post search request
    isolated resource function post fhir/r4/Procedure/_search(r4:FHIRContext fhirContext) returns r4:FHIRError|http:Response {
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
                    if (fhirResource.resourceType == "Procedure" && ids.indexOf(id) > -1) {
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
                if fhirResource.hasKey("performedDateTime") {
                    string dateTime = check fhirResource.performedDateTime.ensureType();
                    dateTime = dateTime.includes("T") ? dateTime : dateTime + "T00:00:00Z";
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
            return addRevInclude(revInclude, bundle, count, "Procedure").clone();
        }
        return bundle.clone();
    }

}

isolated json[] data = [
    {
        "resourceType": "Procedure",
        "id": "defib-implant-patient-1",
        "meta": {
            "profile": [
                "http://hl7.org/fhir/us/core/StructureDefinition/us-core-procedure"
            ]
        },
        "status": "completed",
        "code": {
            "coding": [
                {
                    "system": "http://snomed.info/sct",
                    "code": "35637008",
                    "display": "Alcohol rehabilitation"
                },
                {
                    "system": "http://www.cms.gov/Medicare/Coding/ICD10",
                    "code": "HZ30ZZZ",
                    "display": "Individual Counseling for Substance Abuse Treatment, Cognitive"
                }
            ],
            "text": "Alcohol rehabilitation"
        },
        "subject": {
            "reference": "Patient/1",
            "display": "Amy Shaw"
        },
        "performedDateTime": "2002-05-23"
    },
    {
        "resourceType": "Procedure",
        "id": "defib-implant-patient-2",
        "meta": {
            "profile": [
                "http://hl7.org/fhir/us/core/StructureDefinition/us-core-procedure"
            ]
        },
        "status": "completed",
        "code": {
            "coding": [
                {
                    "system": "http://snomed.info/sct",
                    "code": "35637008",
                    "display": "Alcohol rehabilitation"
                },
                {
                    "system": "http://www.cms.gov/Medicare/Coding/ICD10",
                    "code": "HZ30ZZZ",
                    "display": "Individual Counseling for Substance Abuse Treatment, Cognitive"
                }
            ],
            "text": "Alcohol rehabilitation"
        },
        "subject": {
            "reference": "Patient/2",
            "display": "Amy Shaw"
        },
        "performedDateTime": "2002-05-23"
    }
];
