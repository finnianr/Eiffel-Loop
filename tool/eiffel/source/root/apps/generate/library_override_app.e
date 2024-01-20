note
	description: "Command-line interface to ${LIBRARY_OVERRIDE_GENERATOR} command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:27 GMT (Saturday 20th January 2024)"
	revision: "23"

class
	LIBRARY_OVERRIDE_APP

inherit
	EL_COMMAND_LINE_APPLICATION [LIBRARY_OVERRIDE_GENERATOR]
		redefine
			Option_name
		end

feature {NONE} -- Implementation

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make ("", "workarea")
		end

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := <<
				required_argument ("ise_eiffel", "Path to EiffelStudio installation", << file_must_exist >>),
				required_argument ("output", "Output directory", No_checks)
			>>
		end

	log_filter_set: EL_LOG_FILTER_SET [like Current, LIBRARY_OVERRIDE_GENERATOR]
		do
			create Result.make
		end

feature {NONE} -- Constants

	Option_name: STRING = "library_override"

end