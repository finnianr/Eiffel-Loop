note
	description: "Checks for UTF-8 files that could be encoded as Latin-1"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-15 11:26:58 GMT (Sunday 15th October 2017)"
	revision: "6"

class
	ENCODING_CHECK_APP

inherit
	EL_COMMAND_LINE_SUB_APPLICATION [ENCODING_CHECK_COMMAND]
		redefine
			Option_name
		end

feature {NONE} -- Implementation

	argument_specs: ARRAY [like specs.item]
		do
			Result := <<
				valid_required_argument ("sources", "Path to sources manifest file", << file_must_exist >>)
			>>
		end

	default_make: PROCEDURE
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
