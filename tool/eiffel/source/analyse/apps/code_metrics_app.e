note
	description: "[
		A command line interface to the command [$source MANIFEST_METRICS_COMMAND].
	]"
	notes: "[
		Usage:
		
			el_eiffel -code_metrics -sources <directory path or sources manifest path>
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-09-17 10:10:32 GMT (Sunday 17th September 2023)"
	revision: "2"

class
	CODE_METRICS_APP

inherit
	SOURCE_MANIFEST_APPLICATION [MANIFEST_METRICS_COMMAND]

feature {NONE} -- Implementation

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make (create {FILE_PATH})
		end

end