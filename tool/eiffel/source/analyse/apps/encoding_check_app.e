note
	description: "[
		Command line interface to the command ${ENCODING_CHECK_COMMAND}.
		
		Usage:
			el_eiffel -encoding_check -sources <dir-path/manifest-path>
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-01 9:30:40 GMT (Sunday 1st September 2024)"
	revision: "20"

class
	ENCODING_CHECK_APP

inherit
	SOURCE_MANIFEST_APPLICATION [ENCODING_CHECK_COMMAND]

feature {NONE} -- Implementation

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make (create {FILE_PATH})
		end

end