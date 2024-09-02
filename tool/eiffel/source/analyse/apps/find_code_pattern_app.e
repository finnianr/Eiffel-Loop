note
	description: "[
		A command line interface to the command ${FIND_CODE_PATTERN_SHELL}.
	]"
	notes: "[
		Usage:
		
			el_eiffel -find_code_pattern -sources <directory path or sources manifest path>
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-01 7:19:38 GMT (Sunday 1st September 2024)"
	revision: "2"

class
	FIND_CODE_PATTERN_APP

inherit
	SOURCE_MANIFEST_APPLICATION [FIND_CODE_PATTERN_SHELL]

feature {NONE} -- Implementation

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make (create {FILE_PATH})
		end

end