note
	description: "[
		A command line interface to the command [$source CODEBASE_STATS_COMMAND].
	]"
	notes: "[
		Usage:
		
			el_eiffel -routine_statistics -sources <directory path or sources manifest path>
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-09-16 7:43:10 GMT (Saturday 16th September 2023)"
	revision: "1"

class
	ROUTINE_STATISTICS_APP

inherit
	SOURCE_MANIFEST_APPLICATION [ROUTINE_STATISTICS_COMMAND]

feature {NONE} -- Implementation

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make (create {FILE_PATH})
		end

end