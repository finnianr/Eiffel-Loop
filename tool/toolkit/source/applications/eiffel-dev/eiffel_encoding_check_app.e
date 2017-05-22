note
	description: "Checks for UTF-8 files that could be encoded as Latin-1"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-19 8:50:11 GMT (Tuesday 19th July 2016)"
	revision: "1"

class
	EIFFEL_ENCODING_CHECK_APP

inherit
	EL_COMMAND_LINE_SUB_APPLICATION [EIFFEL_ENCODING_CHECK_COMMAND]
		redefine
			Option_name
		end

feature {NONE} -- Implementation

	argument_specs: ARRAY [like Type_argument_specification]
		do
			Result := <<
				required_existing_path_argument ("sources", "Path to sources manifest file")
			>>
		end

	default_operands: TUPLE [source_manifest_path: EL_FILE_PATH]
		do
			create Result
			Result.source_manifest_path := ""
		end

	make_action: PROCEDURE [like default_operands]
		do
			Result := agent command.make
		end

feature {NONE} -- Constants

	Description: STRING = "[
		Checks for UTF-8 files that could be encoded as Latin-1
	]"

	Log_filter: ARRAY [like Type_logging_filter]
			--
		do
			Result := <<
				[{EIFFEL_ENCODING_CHECK_APP}, All_routines],
				[{EIFFEL_ENCODING_CHECK_COMMAND}, All_routines]
			>>
		end

	Option_name: STRING = "check_encoding"

end
