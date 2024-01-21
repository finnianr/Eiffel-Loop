note
	description: "[
		Command line interface to the command ${ENCODING_CHECK_COMMAND}.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-21 8:55:40 GMT (Sunday 21st January 2024)"
	revision: "19"

class
	ENCODING_CHECK_APP

inherit
	SOURCE_MANIFEST_APPLICATION [ENCODING_CHECK_COMMAND]
		redefine
			Option_name
		end

feature {NONE} -- Implementation

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make (create {FILE_PATH})
		end

feature {NONE} -- Constants

	Option_name: STRING = "check_encoding"

end