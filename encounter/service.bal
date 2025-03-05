import ballerina/http;
import ballerinax/health.fhir.r4;
import ballerinax/health.fhirr4;
import ballerinax/health.fhir.r4.parser as fhirParser;
import ballerinax/health.fhir.r4.uscore311;

# Generic type to wrap all implemented profiles.
# Add required profile types here.
# public type Encounter r4:Encounter|<other_Encounter_Profile>;
public type Encounter uscore311:USCoreEncounterProfile;

# initialize source system endpoint here

# A service representing a network-accessible API
# bound to port `9090`.
service / on new fhirr4:Listener(9090, apiConfig) {

    // Read the current state of single resource based on its id.
    isolated resource function get fhir/r4/Encounter/[string id](r4:FHIRContext fhirContext) returns Encounter|r4:OperationOutcome|r4:FHIRError|error {
        lock {
            foreach json val in data {
                map<json> fhirResource = check val.ensureType();
                if (fhirResource.resourceType == "Encounter" && fhirResource.id == id) {
                    Encounter encounter = check fhirParser:parse(fhirResource, uscore311:USCoreEncounterProfile).ensureType();
                    return encounter.clone();
                }
            }
        }
        return r4:createFHIRError("Not found", r4:ERROR, r4:INFORMATIONAL, httpStatusCode = http:STATUS_NOT_FOUND);
    }

    // Read the state of a specific version of a resource based on its id.
    isolated resource function get fhir/r4/Encounter/[string id]/_history/[string vid](r4:FHIRContext fhirContext) returns Encounter|r4:OperationOutcome|r4:FHIRError {
        return r4:createFHIRError("Not implemented", r4:ERROR, r4:INFORMATIONAL, httpStatusCode = http:STATUS_NOT_IMPLEMENTED);
    }

    // Search for resources based on a set of criteria.
    isolated resource function get fhir/r4/Encounter(r4:FHIRContext fhirContext) returns r4:Bundle|r4:OperationOutcome|r4:FHIRError|error {
        lock {
            return filterData(fhirContext);
        }
    }

    // Create a new resource.
    isolated resource function post fhir/r4/Encounter(r4:FHIRContext fhirContext, Encounter encounter) returns Encounter|r4:OperationOutcome|r4:FHIRError {
        return r4:createFHIRError("Not implemented", r4:ERROR, r4:INFORMATIONAL, httpStatusCode = http:STATUS_NOT_IMPLEMENTED);
    }

    // Update the current state of a resource completely.
    isolated resource function put fhir/r4/Encounter/[string id](r4:FHIRContext fhirContext, Encounter encounter) returns Encounter|r4:OperationOutcome|r4:FHIRError {
        return r4:createFHIRError("Not implemented", r4:ERROR, r4:INFORMATIONAL, httpStatusCode = http:STATUS_NOT_IMPLEMENTED);
    }

    // Update the current state of a resource partially.
    isolated resource function patch fhir/r4/Encounter/[string id](r4:FHIRContext fhirContext, json patch) returns Encounter|r4:OperationOutcome|r4:FHIRError {
        return r4:createFHIRError("Not implemented", r4:ERROR, r4:INFORMATIONAL, httpStatusCode = http:STATUS_NOT_IMPLEMENTED);
    }

    // Delete a resource.
    isolated resource function delete fhir/r4/Encounter/[string id](r4:FHIRContext fhirContext) returns r4:OperationOutcome|r4:FHIRError {
        return r4:createFHIRError("Not implemented", r4:ERROR, r4:INFORMATIONAL, httpStatusCode = http:STATUS_NOT_IMPLEMENTED);
    }

    // Retrieve the update history for a particular resource.
    isolated resource function get fhir/r4/Encounter/[string id]/_history(r4:FHIRContext fhirContext) returns r4:Bundle|r4:OperationOutcome|r4:FHIRError {
        return r4:createFHIRError("Not implemented", r4:ERROR, r4:INFORMATIONAL, httpStatusCode = http:STATUS_NOT_IMPLEMENTED);
    }

    // Retrieve the update history for all resources.
    isolated resource function get fhir/r4/Encounter/_history(r4:FHIRContext fhirContext) returns r4:Bundle|r4:OperationOutcome|r4:FHIRError {
        return r4:createFHIRError("Not implemented", r4:ERROR, r4:INFORMATIONAL, httpStatusCode = http:STATUS_NOT_IMPLEMENTED);
    }

    // post search request
    isolated resource function post fhir/r4/Encounter/_search(r4:FHIRContext fhirContext) returns r4:FHIRError|http:Response {
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

isolated function filterData(r4:FHIRContext fhirContext) returns r4:Bundle|error {

    r4:StringSearchParameter[] idParam = check fhirContext.getStringSearchParameter("_id") ?: [];
    r4:TokenSearchParameter[] identifierParam = check fhirContext.getTokenSearchParameter("identifier") ?: [];
    r4:StringSearchParameter[] nameParam = check fhirContext.getStringSearchParameter("name") ?: [];
    r4:TokenSearchParameter[] genderParam = check fhirContext.getTokenSearchParameter("gender") ?: [];
    r4:DateSearchParameter[] birthdateParam = check fhirContext.getDateSearchParameter("birthdate") ?: [];

    string id = idParam != [] ? check idParam[0].value.ensureType() : "";
    string identifierValue = identifierParam != [] ? check identifierParam[0].code.ensureType() : "";
    string nameValue = nameParam != [] ? check nameParam[0].value.ensureType() : "";
    string gender = genderParam != [] ? check genderParam[0].code.ensureType() : "";
    string birthdate = birthdateParam != [] ? check birthdateParam[0].toString().ensureType() : "";

    r4:TokenSearchParameter[] revIncludeParam = check fhirContext.getTokenSearchParameter("_revinclude") ?: [];
    string revInclude = revIncludeParam != [] ? check revIncludeParam[0].code.ensureType() : "";
    lock {

        r4:Bundle bundle = {identifier: {system: ""}, 'type: "searchset", entry: []};
        r4:BundleEntry bundleEntry = {};
        int count = 0;
        json[] identifier = [];
        map<json> identifierObject = {};

        json[] name = [];
        map<json> nameObject = {};
        foreach json val in data {
            map<json> fhirResource = check val.ensureType();
            if fhirResource.hasKey("identifier") {
                identifier = check fhirResource.identifier.ensureType();
                identifierObject = <map<json>>identifier[0];
                string idValue = (check identifierObject.value).toString();
                if (fhirResource.resourceType == "Encounter" && (fhirResource.id == id || idValue.equalsIgnoreCaseAscii(identifierValue))) {
                    bundleEntry = {fullUrl: "", 'resource: fhirResource};
                    bundle.entry[count] = bundleEntry;
                    count += 1;
                    continue;
                }
            }

            if fhirResource.hasKey("name") {
                name = check fhirResource.name.ensureType();
                nameObject = <map<json>>name[0];
                string family = (check nameObject.family).toString();
                if (fhirResource.resourceType == "Encounter" && (fhirResource.id == id || family.equalsIgnoreCaseAscii(nameValue))) {
                    bundleEntry = {fullUrl: "", 'resource: fhirResource};
                    bundle.entry[count] = bundleEntry;
                    count += 1;
                    continue;
                }
            }

            if fhirResource.hasKey("gender") && fhirResource.hasKey("name") {
                name = check fhirResource.name.ensureType();
                nameObject = <map<json>>name[0];
                string family = (check nameObject.family).toString();
                if (fhirResource.resourceType == "Encounter" && (fhirResource.gender == gender && family.equalsIgnoreCaseAscii(nameValue))) {
                    bundleEntry = {fullUrl: "", 'resource: fhirResource};
                    bundle.entry[count] = bundleEntry;
                    count += 1;
                    continue;
                }
            }

            if fhirResource.hasKey("birthdate") && fhirResource.hasKey("name") {
                name = check fhirResource.name.ensureType();
                nameObject = <map<json>>name[0];
                string family = (check nameObject.family).toString();
                if (fhirResource.resourceType == "Encounter" && (fhirResource.birthdate == birthdate && family.equalsIgnoreCaseAscii(nameValue))) {
                    bundleEntry = {fullUrl: "", 'resource: fhirResource};
                    bundle.entry[count] = bundleEntry;
                    count += 1;
                    continue;
                }
            }

        }

        if bundle.entry != [] {
            return addRevInclude(revInclude, bundle, count, "Encounter").clone();
        }
    }
    return r4:createFHIRError("Not found", r4:ERROR, r4:INFORMATIONAL, httpStatusCode = http:STATUS_NOT_FOUND);
}

isolated json[] data = [
    {
        "resourceType": "Encounter",
        "id": "38cd73c9-184d-4016-b315-aca42e5f9569",
        "meta": {
            "lastUpdated": "2017-05-26T11:56:57.250-04:00",
            "profile": [
                "http://hl7.org/fhir/us/core/StructureDefinition/us-core-encounter"
            ]
        },
        "text": {
            "status": "generated",
            "div": "<div xmlns=\"http://www.w3.org/1999/xhtml\"><p><b>Generated Narrative</b></p><p><b>id</b>: example-1</p><p><b>meta</b>: </p><p><b>status</b>: finished</p><p><b>class</b>: <span title=\"{http://terminology.hl7.org/CodeSystem/v3-ActCode AMB}\">ambulatory</span></p><p><b>type</b>: <span title=\"Codes: {http://www.ama-assn.org/go/cpt 99201}\">Office Visit</span></p><p><b>subject</b>: <a href=\"Patient-example.html\">Generated Summary: id: example; Medical Record Number: 1032702 (USUAL); active; Amy V. Shaw , Amy V. Baxter ; ph: 555-555-5555(HOME), amy.shaw@example.com; gender: female; birthDate: 1987-02-20</a></p><p><b>period</b>: 02/11/2015 9:00:14 AM --&gt; 02/11/2015 10:00:14 AM</p></div>"
        },
        "status": "finished",
        "class": {
            "system": "http://terminology.hl7.org/CodeSystem/v3-ActCode",
            "code": "AMB",
            "display": "ambulatory"
        },
        "type": [
            {
                "coding": [
                    {
                        "system": "http://www.ama-assn.org/go/cpt",
                        "code": "99201"
                    }
                ],
                "text": "Office Visit"
            }
        ],
        "subject": {
            "reference": "Patient/example"
        },
        "period": {
            "start": "2015-11-01T17:00:14-05:00",
            "end": "2015-11-01T18:00:14-05:00"
        }
    },
    {
        "resourceType": "Encounter",
        "id": "patient-1-lab-encounter",
        "meta": {
            "lastUpdated": "2017-05-26T11:56:57.250-04:00",
            "profile": [
                "http://hl7.org/fhir/us/core/StructureDefinition/us-core-encounter"
            ]
        },
        "text": {
            "status": "generated",
            "div": "<div xmlns=\"http://www.w3.org/1999/xhtml\"><p><b>Generated Narrative</b></p><p><b>id</b>: example-1</p><p><b>meta</b>: </p><p><b>status</b>: finished</p><p><b>class</b>: <span title=\"{http://terminology.hl7.org/CodeSystem/v3-ActCode AMB}\">ambulatory</span></p><p><b>type</b>: <span title=\"Codes: {http://www.ama-assn.org/go/cpt 99201}\">Office Visit</span></p><p><b>subject</b>: <a href=\"Patient-example.html\">Generated Summary: id: example; Medical Record Number: 1032702 (USUAL); active; Amy V. Shaw , Amy V. Baxter ; ph: 555-555-5555(HOME), amy.shaw@example.com; gender: female; birthDate: 1987-02-20</a></p><p><b>period</b>: 02/11/2015 9:00:14 AM --&gt; 02/11/2015 10:00:14 AM</p></div>"
        },
        "status": "finished",
        "class": {
            "system": "http://terminology.hl7.org/CodeSystem/v3-ActCode",
            "code": "AMB",
            "display": "ambulatory"
        },
        "type": [
            {
                "coding": [
                    {
                        "system": "http://www.ama-assn.org/go/cpt",
                        "code": "99201"
                    }
                ],
                "text": "Office Visit"
            }
        ],
        "subject": {
            "reference": "Patient/1"
        },
        "period": {
            "start": "2015-11-01T17:00:14-05:00",
            "end": "2015-11-01T18:00:14-05:00"
        }
    },
    {
        "resourceType": "Encounter",
        "id": "patient-2-xray-encounter",
        "meta": {
            "lastUpdated": "2017-05-26T11:56:57.250-04:00",
            "profile": [
                "http://hl7.org/fhir/us/core/StructureDefinition/us-core-encounter"
            ]
        },
        "text": {
            "status": "generated",
            "div": "<div xmlns=\"http://www.w3.org/1999/xhtml\"><p><b>Generated Narrative</b></p><p><b>id</b>: example-1</p><p><b>meta</b>: </p><p><b>status</b>: finished</p><p><b>class</b>: <span title=\"{http://terminology.hl7.org/CodeSystem/v3-ActCode AMB}\">ambulatory</span></p><p><b>type</b>: <span title=\"Codes: {http://www.ama-assn.org/go/cpt 99201}\">Office Visit</span></p><p><b>subject</b>: <a href=\"Patient-example.html\">Generated Summary: id: example; Medical Record Number: 1032702 (USUAL); active; Amy V. Shaw , Amy V. Baxter ; ph: 555-555-5555(HOME), amy.shaw@example.com; gender: female; birthDate: 1987-02-20</a></p><p><b>period</b>: 02/11/2015 9:00:14 AM --&gt; 02/11/2015 10:00:14 AM</p></div>"
        },
        "status": "finished",
        "class": {
            "system": "http://terminology.hl7.org/CodeSystem/v3-ActCode",
            "code": "AMB",
            "display": "ambulatory"
        },
        "type": [
            {
                "coding": [
                    {
                        "system": "http://www.ama-assn.org/go/cpt",
                        "code": "99201"
                    }
                ],
                "text": "Office Visit"
            }
        ],
        "subject": {
            "reference": "Patient/2"
        },
        "period": {
            "start": "2015-11-01T17:00:14-05:00",
            "end": "2015-11-01T18:00:14-05:00"
        }
    }
];


