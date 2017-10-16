note
	description: "Summary description for {FILTER_INVALID_UTF_8_APP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-15 11:39:39 GMT (Sunday 15th October 2017)"
	revision: "2"

class
	FILTER_INVALID_UTF_8_APP

inherit
	EL_COMMAND_LINE_SUB_APPLICATION [FILTER_INVALID_UTF_8_COMMAND]
		redefine
			Option_name
		end

create
	make

feature {NONE} -- Implementation

	argument_specs: ARRAY [like specs.item]
		do
			Result := <<
				valid_required_argument ("in", "Input file path", << file_must_exist >>)
			>>
		end

	default_make: PROCEDURE
		do
			Result := agent {like command}.make ("")
		end

feature {NONE} -- Constants

	Option_name: STRING = "filter_utf_8"

	Description: STRING = "Filter out all invalid UTF-8 lines from file"

	Log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{like Current}, All_routines],
				[{FILTER_INVALID_UTF_8_COMMAND}, All_routines]
			>>
		end


end
