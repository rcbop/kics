package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	document := input.document[i]
	task := ansLib.getTasks(document)[t]
	instance := task["google.cloud.gcp_sql_instance"]
	settings := instance.settings
	database_flags := settings.database_flags

	ansLib.checkState(instance)
	ansLib.check_database_flags_content(database_flags, "log_temp_files", 0)

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name=%s.{{google.cloud.gcp_sql_instance}}.settings.database_flags", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("name=%s.{{google.cloud.gcp_sql_instance}}.settings.database_flags sets the log_temp_files to 0", [task.name]),
		"keyActualValue": sprintf("name=%s.{{google.cloud.gcp_sql_instance}}.settings.database_flags doesn't set the log_temp_files to 0", [task.name]),
	}
}
