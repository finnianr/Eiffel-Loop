note
	description: "[
		A command line interface to the command [$source ENCODING_CHECK_COMMAND].
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-25 15:24:46 GMT (Wednesday 25th September 2019)"
	revision: "11"

class
	ENCODING_CHECK_APP

inherit
	EL_LOGGED_COMMAND_LINE_SUB_APPLICATION [ENCODING_CHECK_COMMAND]
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

	Log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{ENCODING_CHECK_APP}, All_routines],
				[{ENCODING_CHECK_COMMAND}, All_routines]
			>>
		end

	Option_name: STRING = "check_encoding"

end
