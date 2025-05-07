note
	description: "Command-line interface to ${LIBRARY_OVERRIDE_GENERATOR} command"
	notes: "[
		Usage:
			el_eiffel -library_override [-output <output-dir>]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-05-07 15:24:15 GMT (Wednesday 7th May 2025)"
	revision: "24"

class
	LIBRARY_OVERRIDE_APP

inherit
	EL_COMMAND_LINE_APPLICATION [LIBRARY_OVERRIDE_GENERATOR]

feature {NONE} -- Implementation

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make ("workarea", False)
		end

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := <<
				optional_argument ("output", "Output directory", << file_must_exist >>)
			>>
		end

	log_filter_set: EL_LOG_FILTER_SET [like Current, LIBRARY_OVERRIDE_GENERATOR]
		do
			create Result.make
		end

end