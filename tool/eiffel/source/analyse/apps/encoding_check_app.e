note
	description: "[
		A command line interface to the command [$source ENCODING_CHECK_COMMAND].
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-18 12:46:04 GMT (Tuesday 18th February 2020)"
	revision: "12"

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

	Description: STRING = "[
		Checks for UTF-8 files that could be encoded as Latin-1
	]"

	Option_name: STRING = "check_encoding"

end
