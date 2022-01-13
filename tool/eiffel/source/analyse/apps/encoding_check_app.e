note
	description: "[
		A command line interface to the command [$source ENCODING_CHECK_COMMAND].
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-13 12:22:35 GMT (Thursday 13th January 2022)"
	revision: "13"

class
	ENCODING_CHECK_APP

inherit
	EL_COMMAND_LINE_SUB_APPLICATION [ENCODING_CHECK_COMMAND]
		redefine
			Option_name
		end

feature {NONE} -- Implementation

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := <<
				valid_required_argument ("sources", "Path to sources manifest file", << file_must_exist >>)
			>>
		end

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make ("")
		end

feature {NONE} -- Constants

	Option_name: STRING = "check_encoding"

end