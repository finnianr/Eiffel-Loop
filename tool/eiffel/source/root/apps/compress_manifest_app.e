note
	description: "[
		A command line interface to the command ${COMPRESS_MANIFEST_COMMAND}.
		Compress an indented manifest table and output as Eiffel code fragment
	]"
	notes: "[
		Usage:
		
			el_eiffel -compress_manifest -source <input-path> OPTIONAL [-output <output-path>]

	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-22 8:08:37 GMT (Thursday 22nd August 2024)"
	revision: "19"

class
	COMPRESS_MANIFEST_APP

inherit
	EL_COMMAND_LINE_APPLICATION [COMPRESS_MANIFEST_COMMAND]

create
	make

feature {NONE} -- Implementation

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := <<
				required_argument ("source", "Path to manifest table text file", << file_must_exist >>),
				optional_argument ("output", "Output path to generated Eiffel code fragment", No_checks)
			>>
		end

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make (create {FILE_PATH}, create {FILE_PATH})
		end

end