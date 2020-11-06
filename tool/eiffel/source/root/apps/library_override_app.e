note
	description: "Command-line interface to [$source LIBRARY_OVERRIDE_GENERATOR] command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-11-06 16:49:13 GMT (Friday 6th November 2020)"
	revision: "15"

class
	LIBRARY_OVERRIDE_APP

inherit
	EL_LOGGED_COMMAND_LINE_SUB_APPLICATION [LIBRARY_OVERRIDE_GENERATOR]
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
				valid_required_argument ("ise_eiffel", "Path to EiffelStudio installation", << file_must_exist >>),
				required_argument ("output", "Output directory")
			>>
		end

	log_filter_list: EL_LOG_FILTER_LIST [like Current, LIBRARY_OVERRIDE_GENERATOR]
		do
			create Result.make
		end

feature {NONE} -- Constants

	Option_name: STRING = "library_override"

	Description: STRING = "Generates override of standard libaries to work with Eiffel-Loop"

end