note
	description: "Summary description for {FILTER_INVALID_UTF_8_APP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-09-03 16:27:35 GMT (Sunday 3rd September 2017)"
	revision: "1"

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

	make_action: PROCEDURE [like default_operands]
		do
			Result := agent command.make
		end

	default_operands: TUPLE [source_path: EL_FILE_PATH]
		do
			create Result
			Result.source_path := ""
		end

	argument_specs: ARRAY [like specs.item]
		do
			Result := <<
				valid_required_argument ("in", "Input file path", << file_must_exist >>)
			>>
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
