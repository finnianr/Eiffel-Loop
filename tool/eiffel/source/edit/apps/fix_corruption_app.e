note
	description: "[
		Command line interface to the command ${FIX_CORRUPTION_COMMAND}.
		
		Usage:
			el_eiffel -fix_corruption -sources <dir-path/manifest-path>
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-10-05 9:22:58 GMT (Saturday 5th October 2024)"
	revision: "21"

class
	FIX_CORRUPTION_APP

inherit
	SOURCE_MANIFEST_APPLICATION [FIX_BAD_NOTE_FIELDS_COMMAND]

feature {NONE} -- Implementation

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make (create {FILE_PATH})
		end

end