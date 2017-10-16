note
	description: "Summary description for {EIFFEL_LIBRARY_OVERRIDE_APP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-15 11:26:09 GMT (Sunday 15th October 2017)"
	revision: "8"

class
	LIBRARY_OVERRIDE_APP

inherit
	EL_COMMAND_LINE_SUB_APPLICATION [LIBRARY_OVERRIDE_GENERATOR]
		redefine
			Option_name
		end

feature {NONE} -- Implementation

	default_make: PROCEDURE
		do
			Result := agent {like command}.make ("", "workarea")
		end

	argument_specs: ARRAY [like specs.item]
		do
			Result := <<
				valid_required_argument ("ise_eiffel", "Path to EiffelStudio installation", << file_must_exist >>),
				required_argument ("output", "Output directory")
			>>
		end

feature {NONE} -- Constants

	Option_name: STRING = "library_override"

	Description: STRING = "Generates override of standard libaries to work with Eiffel-Loop"

	Log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{LIBRARY_OVERRIDE_APP}, "*"],
				[{LIBRARY_OVERRIDE_GENERATOR}, "*"]
			>>
		end

end
