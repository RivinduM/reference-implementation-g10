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

# Generic type to wrap all implemented profiles.
# Add required profile types here.
# public type Organization r4:Organization|<other_Organization_Profile>;
public type Organization uscore311:USCoreOrganizationProfile;

# initialize source system endpoint here
configurable string backendBaseUrl = "http://localhost:9095/backend";
configurable string fhirBaseUrl = "localhost:9091/fhir/r4";
final http:Client fhirApiClient = check new (fhirBaseUrl);
final http:Client backendClient = check new (backendBaseUrl);

# A service representing a network-accessible API
# bound to port `9090`.
service /fhir/r4 on new fhirr4:Listener(9090, apiConfig) {

    // Read the current state of single resource based on its id.
    isolated resource function get Organization/[string id](r4:FHIRContext fhirContext) returns Organization|r4:OperationOutcome|r4:FHIRError|error {
        lock {
            json[] data = check retrieveData("Organization").ensureType();
            foreach json val in data {
                map<json> fhirResource = check val.ensureType();
                if (fhirResource.resourceType == "Organization" && fhirResource.id == id) {
                    Organization organization = check fhirResource.cloneWithType(Organization);
                    return organization.clone();
                }
            }
        }
        return r4:createFHIRError("Not found", r4:ERROR, r4:INFORMATIONAL, httpStatusCode = http:STATUS_NOT_FOUND);
    }

    // Read the state of a specific version of a resource based on its id.
    isolated resource function get Organization/[string id]/_history/[string vid](r4:FHIRContext fhirContext) returns Organization|r4:OperationOutcome|r4:FHIRError {
        return r4:createFHIRError("Not implemented", r4:ERROR, r4:INFORMATIONAL, httpStatusCode = http:STATUS_NOT_IMPLEMENTED);
    }

    // Search for resources based on a set of criteria.
    isolated resource function get Organization(r4:FHIRContext fhirContext) returns r4:Bundle|r4:OperationOutcome|r4:FHIRError|error {
        return filterData(fhirContext);
    }

    // Create a new resource.
    isolated resource function post Organization(r4:FHIRContext fhirContext, Organization organization) returns Organization|r4:OperationOutcome|r4:FHIRError {
        return r4:createFHIRError("Not implemented", r4:ERROR, r4:INFORMATIONAL, httpStatusCode = http:STATUS_NOT_IMPLEMENTED);
    }

    // Update the current state of a resource completely.
    isolated resource function put Organization/[string id](r4:FHIRContext fhirContext, Organization organization) returns Organization|r4:OperationOutcome|r4:FHIRError {
        return r4:createFHIRError("Not implemented", r4:ERROR, r4:INFORMATIONAL, httpStatusCode = http:STATUS_NOT_IMPLEMENTED);
    }

    // Update the current state of a resource partially.
    isolated resource function patch Organization/[string id](r4:FHIRContext fhirContext, json patch) returns Organization|r4:OperationOutcome|r4:FHIRError {
        return r4:createFHIRError("Not implemented", r4:ERROR, r4:INFORMATIONAL, httpStatusCode = http:STATUS_NOT_IMPLEMENTED);
    }

    // Delete a resource.
    isolated resource function delete Organization/[string id](r4:FHIRContext fhirContext) returns r4:OperationOutcome|r4:FHIRError {
        return r4:createFHIRError("Not implemented", r4:ERROR, r4:INFORMATIONAL, httpStatusCode = http:STATUS_NOT_IMPLEMENTED);
    }

    // Retrieve the update history for a particular resource.
    isolated resource function get Organization/[string id]/_history(r4:FHIRContext fhirContext) returns r4:Bundle|r4:OperationOutcome|r4:FHIRError {
        return r4:createFHIRError("Not implemented", r4:ERROR, r4:INFORMATIONAL, httpStatusCode = http:STATUS_NOT_IMPLEMENTED);
    }

    // Retrieve the update history for all resources.
    isolated resource function get Organization/_history(r4:FHIRContext fhirContext) returns r4:Bundle|r4:OperationOutcome|r4:FHIRError {
        return r4:createFHIRError("Not implemented", r4:ERROR, r4:INFORMATIONAL, httpStatusCode = http:STATUS_NOT_IMPLEMENTED);
    }

    // post search request
    isolated resource function post Organization/_search(r4:FHIRContext fhirContext) returns r4:FHIRError|http:Response {
        r4:Bundle|error result = filterData(fhirContext);
        if result is r4:Bundle {
            http:Response response = new;
            response.statusCode = http:STATUS_OK;
            response.setPayload(result.clone().toJson());
            return response;
        } else {
            return r4:createFHIRError("Internal Server Error", r4:ERROR, r4:INFORMATIONAL, httpStatusCode = http:STATUS_INTERNAL_SERVER_ERROR);
        }
    }
}

isolated function addRevInclude(string revInclude, r4:Bundle bundle, int entryCount, string apiName) returns r4:Bundle|error {

    if revInclude == "" {
        return bundle;
    }
    string[] ids = check buildSearchIds(bundle, apiName);
    if ids.length() == 0 {
        return bundle;
    }

    int count = entryCount;
    http:Response response = check fhirApiClient->/Provenance(target = string:'join(",", ...ids));
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

isolated function filterData(r4:FHIRContext fhirContext) returns r4:FHIRError|r4:Bundle|error {

    boolean isSearchParamAvailable = false;
    r4:StringSearchParameter[] nameParam = check fhirContext.getStringSearchParameter("name") ?: [];
    string[] names = [];
    foreach r4:StringSearchParameter item in nameParam {
        string id = check item.value.ensureType();
        names.push(id);
    }
    r4:TokenSearchParameter[] revIncludeParam = check fhirContext.getTokenSearchParameter("_revinclude") ?: [];
    string revInclude = revIncludeParam != [] ? check revIncludeParam[0].code.ensureType() : "";
    lock {

        r4:Bundle bundle = {identifier: {system: ""}, 'type: "searchset", entry: []};
        r4:BundleEntry bundleEntry = {};
        int count = 0;
        json[] data = check retrieveData("Organization").ensureType();
        json[] resultSet = data;

        // filter by name
        if (names.length() > 0) {
            resultSet = [];
            isSearchParamAvailable = true;
            foreach json val in data {
                map<json> fhirResource = check val.ensureType();
                if fhirResource.hasKey("name") {
                    string name = check fhirResource.name.ensureType();
                    if (names.indexOf(name) > -1) {
                        resultSet.push(fhirResource);
                        continue;
                    }
                }
            }
        }

        resultSet = isSearchParamAvailable ? resultSet : data;
        foreach json item in resultSet {
            bundleEntry = {fullUrl: "", 'resource: item};
            bundle.entry[count] = bundleEntry;
            count += 1;
        }

        if bundle.entry != [] {
            return addRevInclude(revInclude, bundle, count, "Organization").clone();
        }
        return bundle.clone();
    }

}

// Retrieve data from the backend
isolated function retrieveData(string resourceType) returns json|error {
    
    http:Response response = check backendClient->get("/data/" + resourceType);
    if response.statusCode == http:STATUS_OK {
        json payload = check response.getJsonPayload();
        return payload;
    } else {
        return error("Failed to retrieve data from backend service");
    }
}
