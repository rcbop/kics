package Cx

SupportedResources = "$.resource.aws_iam_role"

CxPolicy [ result ] {
	policy := input.document[i].resource.aws_iam_role[name].assume_role_policy
    re_match("Service", policy)
    out := json.unmarshal(policy)
    not out.Statement[ix].Effect
    aws := out.Statement[ix].Principal.AWS
    contains(aws, "*")

    result := mergeWithMetadata({
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("aws_iam_role[%s].assume_role_policy.Principal.AWS", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": null,
                "keyActualValue":   aws
              })
}

CxPolicy [ result ] {
	policy := input.document[i].resource.aws_iam_role[name].assume_role_policy
    re_match("Service", policy)
    out := json.unmarshal(policy)
    out.Statement[ix].Effect != "Deny"
    aws := out.Statement[ix].Principal.AWS
    contains(aws, "*")

    result := mergeWithMetadata({
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("aws_iam_role[%s].assume_role_policy.Principal.AWS", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": 8,
                "keyActualValue": 	aws
              })
}
