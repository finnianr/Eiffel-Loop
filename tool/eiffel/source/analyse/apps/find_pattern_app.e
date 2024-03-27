note
	description: "[
		A command line interface to the command ${FIND_PATTERN_COMMAND}.
	]"
	notes: "[
		Usage:
		
			el_eiffel -find_pattern -sources <directory path or sources manifest path>
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-03-27 16:03:08 GMT (Wednesday 27th March 2024)"
	revision: "1"

class
	FIND_PATTERN_APP

inherit
	SOURCE_MANIFEST_APPLICATION [FIND_PATTERN_COMMAND]

feature {NONE} -- Implementation

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make (create {FILE_PATH})
		end

end