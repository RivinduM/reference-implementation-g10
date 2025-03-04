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
# public type Provenance r4:Provenance|<other_Provenance_Profile>;
public type Provenance uscore311:USCoreProvenance;

# initialize source system endpoint here

# A service representing a network-accessible API
# bound to port `9090`.
service / on new fhirr4:Listener(9090, apiConfig) {

    // Read the current state of single resource based on its id.
    isolated resource function get fhir/r4/Provenance/[string id](r4:FHIRContext fhirContext) returns Provenance|r4:OperationOutcome|r4:FHIRError {
        return r4:createFHIRError("Not implemented", r4:ERROR, r4:INFORMATIONAL, httpStatusCode = http:STATUS_NOT_IMPLEMENTED);
    }

    // Read the state of a specific version of a resource based on its id.
    isolated resource function get fhir/r4/Provenance/[string id]/_history/[string vid](r4:FHIRContext fhirContext) returns Provenance|r4:OperationOutcome|r4:FHIRError {
        return r4:createFHIRError("Not implemented", r4:ERROR, r4:INFORMATIONAL, httpStatusCode = http:STATUS_NOT_IMPLEMENTED);
    }

    // Search for resources based on a set of criteria.
    isolated resource function get fhir/r4/Provenance(r4:FHIRContext fhirContext) returns r4:Bundle|r4:OperationOutcome|r4:FHIRError|error {

        lock {
            r4:StringSearchParameter[] idParam = check fhirContext.getStringSearchParameter("_id") ?: [];
            r4:ReferenceSearchParameter[] targetParam = check fhirContext.getReferenceSearchParameter("target") ?: [];

            // string id = idParam != [] ? check idParam[0].value.ensureType() : "";
            string[] ids = [];
            foreach r4:StringSearchParameter item in idParam {
                string id = check item.value.ensureType();
                ids.push(id);
            }
            string[] targetIds = [];
            foreach r4:ReferenceSearchParameter item in targetParam {
                string targetId = check item.id.ensureType();
                string targetResourceType = check item.resourceType.ensureType();
                targetIds.push(targetResourceType + "/" + targetId);
            }
            // string targetId = targetParam != [] ? check targetParam[0].id.ensureType() : "";
            // string targetResourceType = targetParam != [] ? check targetParam[0].resourceType.ensureType() : "";

            r4:Bundle bundle = {identifier: {system: ""}, 'type: "collection", entry: []};
            r4:BundleEntry bundleEntry = {};
            int count = 0;

            foreach json val in data {
                map<json> fhirResource = check val.ensureType();

                if fhirResource.hasKey("target") {
                    json[] references = check fhirResource.target.ensureType();
                    foreach json reference in references {
                        string ref = check reference.reference.ensureType();
                        if (targetIds.indexOf(ref) > -1) {
                            bundleEntry = {fullUrl: "", 'resource: fhirResource};
                            bundle.entry[count] = bundleEntry;
                            count += 1;
                            continue;
                        }
                    }
                }
                if fhirResource.hasKey("id") {
                    string id = check fhirResource.id.ensureType();
                    if (fhirResource.resourceType == "Provenance" && ids.indexOf(id) > -1) {
                        bundleEntry = {fullUrl: "", 'resource: fhirResource};
                        bundle.entry[count] = bundleEntry;
                        count += 1;
                        continue;
                    }
                }

            }

            if bundle.entry != [] {
                return bundle.clone();
            }
        }
        return r4:createFHIRError("Not found", r4:ERROR, r4:INFORMATIONAL, httpStatusCode = http:STATUS_NOT_FOUND);
    }

    // Create a new resource.
    isolated resource function post fhir/r4/Provenance(r4:FHIRContext fhirContext, Provenance procedure) returns Provenance|r4:OperationOutcome|r4:FHIRError {
        return r4:createFHIRError("Not implemented", r4:ERROR, r4:INFORMATIONAL, httpStatusCode = http:STATUS_NOT_IMPLEMENTED);
    }

    // Update the current state of a resource completely.
    isolated resource function put fhir/r4/Provenance/[string id](r4:FHIRContext fhirContext, Provenance provenance) returns Provenance|r4:OperationOutcome|r4:FHIRError {
        return r4:createFHIRError("Not implemented", r4:ERROR, r4:INFORMATIONAL, httpStatusCode = http:STATUS_NOT_IMPLEMENTED);
    }

    // Update the current state of a resource partially.
    isolated resource function patch fhir/r4/Provenance/[string id](r4:FHIRContext fhirContext, json patch) returns Provenance|r4:OperationOutcome|r4:FHIRError {
        return r4:createFHIRError("Not implemented", r4:ERROR, r4:INFORMATIONAL, httpStatusCode = http:STATUS_NOT_IMPLEMENTED);
    }

    // Delete a resource.
    isolated resource function delete fhir/r4/Provenance/[string id](r4:FHIRContext fhirContext) returns r4:OperationOutcome|r4:FHIRError {
        return r4:createFHIRError("Not implemented", r4:ERROR, r4:INFORMATIONAL, httpStatusCode = http:STATUS_NOT_IMPLEMENTED);
    }

    // Retrieve the update history for a particular resource.
    isolated resource function get fhir/r4/Provenance/[string id]/_history(r4:FHIRContext fhirContext) returns r4:Bundle|r4:OperationOutcome|r4:FHIRError {
        return r4:createFHIRError("Not implemented", r4:ERROR, r4:INFORMATIONAL, httpStatusCode = http:STATUS_NOT_IMPLEMENTED);
    }

    // Retrieve the update history for all resources.
    isolated resource function get fhir/r4/Provenance/_history(r4:FHIRContext fhirContext) returns r4:Bundle|r4:OperationOutcome|r4:FHIRError {
        return r4:createFHIRError("Not implemented", r4:ERROR, r4:INFORMATIONAL, httpStatusCode = http:STATUS_NOT_IMPLEMENTED);
    }
}

isolated json[] data =
[
    {
        "resourceType": "Provenance",
        "id": "example-targeted-provenance",
        "meta": {
            "profile": [
                "http://hl7.org/fhir/us/core/StructureDefinition/us-core-provenance|7.0.0"
            ]
        },
        "target": [
            {
                "reference": "Patient/2"
            },
            {
                "reference": "Location/d8b7dd62-f16a-4b7a-b517-093579182ac4"
            },
            {
                "reference": "CarePlan/2"
            },
            {
                "reference": "Condition/2"
            },
            {
                "reference": "Device/insulin-pump-2"
            },
            {
                "reference": "CareTeam/2"
            },
            {
                "reference": "Organization/1ac77c95-a3af-4656-94a9-5efd7820ca81"
            },
            {
                "reference": "Practitioner/98420dc3-34c7-4aa8-8181-9f014b1e4561"
            },
            {
                "reference": "PractitionerRole/41a61c28-6a92-40b2-86fd-bbe41819b271"
            },
            {
                "reference": "Encounter/35c8b4d6-ca63-4402-8b84-b01a9cfa86f5"
            },
            {
                "reference": "Observation/123"
            },
            {
                "reference": "DiagnosticReport/blood-sugar-report-2"
            },
            {
                "reference": "Encounter/59972354-9faf-41a0-b967-3139b4c5bef2"
            },
            {
                "reference": "Observation/699c6541-3c3e-44fb-abf9-a55b1b7cd6e1"
            }

        ],
        "recorded": "2023-02-28T15:26:23.217+00:00",
        "agent": [
            {
                "type": {
                    "coding": [
                        {
                            "system": "http://terminology.hl7.org/CodeSystem/provenance-participant-type",
                            "code": "informant",
                            "display": "Informant"
                        }
                    ]
                },
                "who": {
                    "reference": "Patient/2"
                }
            }
        ],
        "entity": [
            {
                "role": "source",
                "what": {
                    "display": "admission form"
                }
            }
        ]
    },

    {
        "resourceType": "Provenance",
        "id": "example-targeted-provenance2",
        "meta": {
            "profile": [
                "http://hl7.org/fhir/us/core/StructureDefinition/us-core-provenance|7.0.0"
            ]
        },
        "target": [
            {
                "reference": "Patient/1"
            },
            {
                "reference": "Goal/patient-1-weight-loss-goal"
            },
            {
                "reference": "CareTeam/1"
            },
            {
                "reference": "Condition/1"
            },
            {
                "reference": "DiagnosticReport/aa185ec1-d7c1-4bde-9664-4f0cebc713be"
            },
            {
                "reference": "Device/pacemaker-1"
            },
            {
                "reference": "CarePlan/1"
            },
            {
                "reference": "Document/patient-1-lab-doc"
            },
            {
                "reference": "AllergyIntolerance/1"
            },
            {
                "reference": "Location/d8b7dd62-f16a-4b7a-b517-093579182ac4"
            },
            {
                "reference": "Organization/1ac77c95-a3af-4656-94a9-5efd7820ca81"
            },
            {
                "reference": "Practitioner/98420dc3-34c7-4aa8-8181-9f014b1e4561"
            },
            {
                "reference": "PractitionerRole/41a61c28-6a92-40b2-86fd-bbe41819b271"
            },
            {
                "reference": "Encounter/35c8b4d6-ca63-4402-8b84-b01a9cfa86f5"
            },
            {
                "reference": "Observation/456"
            },
            {
                "reference": "Encounter/59972354-9faf-41a0-b967-3139b4c5bef2"
            },
            {
                "reference": "Observation/699c6541-3c3e-44fb-abf9-a55b1b7cd6e1"
            },
            {
                "reference": "Immunization/imm-patient-1"
            }

        ],
        "recorded": "2023-02-28T15:26:23.217+00:00",
        "agent": [
            {
                "type": {
                    "coding": [
                        {
                            "system": "http://terminology.hl7.org/CodeSystem/provenance-participant-type",
                            "code": "informant",
                            "display": "Informant"
                        }
                    ]
                },
                "who": {
                    "reference": "Patient/example-targeted-provenance"
                }
            }
        ],
        "entity": [
            {
                "role": "source",
                "what": {
                    "display": "admission form"
                }
            }
        ]
    }
];
