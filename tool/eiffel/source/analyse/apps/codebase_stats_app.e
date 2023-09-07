note
	description: "[
		A command line interface to the command [$source CODEBASE_STATS_COMMAND].
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-09-03 16:26:36 GMT (Sunday 3rd September 2023)"
	revision: "25"

class
	CODEBASE_STATS_APP

inherit
	SOURCE_MANIFEST_APPLICATION [CODEBASE_STATS_COMMAND]
		redefine
			option_name
		end

feature {NONE} -- Implementation

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make (create {FILE_PATH})
		end

feature {NONE} -- Constants

	Option_name: STRING = "code_stats"

end