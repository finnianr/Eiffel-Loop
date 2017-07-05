note
	description: "Summary description for {EIFFEL_LIBRARY_OVERRIDE_APP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-06-29 11:28:42 GMT (Thursday 29th June 2017)"
	revision: "7"

class
	LIBRARY_OVERRIDE_APP

inherit
	EL_COMMAND_LINE_SUB_APPLICATION [LIBRARY_OVERRIDE_GENERATOR]
		redefine
			Option_name
		end

feature {NONE} -- Implementation

	make_action: PROCEDURE [like default_operands]
		do
			Result := agent command.make
		end

	default_operands: TUPLE [ise_eiffel_dir, output_dir: EL_DIR_PATH]
		do
			create Result
			Result.ise_eiffel_dir := ""
			Result.output_dir := "workarea"
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