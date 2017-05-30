note
	description: "Checks for UTF-8 files that could be encoded as Latin-1"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-05-29 23:19:39 GMT (Monday 29th May 2017)"
	revision: "3"

class
	EIFFEL_ENCODING_CHECK_APP

inherit
	EL_COMMAND_LINE_SUB_APPLICATION [EIFFEL_ENCODING_CHECK_COMMAND]
		redefine
			Option_name
		end

feature {NONE} -- Implementation

	argument_specs: ARRAY [like specs.item]
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
