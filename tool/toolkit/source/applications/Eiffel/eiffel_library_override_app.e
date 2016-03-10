note
	description: "Summary description for {EIFFEL_LIBRARY_OVERRIDE_APP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-05-22 17:20:37 GMT (Friday 22nd May 2015)"
	revision: "5"

class
	EIFFEL_LIBRARY_OVERRIDE_APP

inherit
	EL_COMMAND_LINE_SUB_APPLICATION [EIFFEL_LIBRARY_OVERRIDE_GENERATOR]
		redefine
			Option_name
		end

feature {NONE} -- Implementation

	make_action: PROCEDURE [like command, like default_operands]
		do
			Result := agent command.make
		end

	default_operands: TUPLE [ise_eiffel_dir, output_dir: EL_DIR_PATH]
		do
			create Result
			Result.ise_eiffel_dir := ""
			Result.output_dir := ""
		end

	argument_specs: ARRAY [like Type_argument_specification]
		do
			Result := <<
				required_existing_path_argument ("ise_eiffel", "Path to EiffelStudio installation"),
				required_existing_path_argument ("output", "Output directory")
			>>
		end

feature {NONE} -- Constants

	Option_name: STRING = "library_override"

	Description: STRING = "[
		Generates override of standard libaries to work with Eiffel-Loop
	]"

	Log_filter: ARRAY [like Type_logging_filter]
			--
		do
			Result := <<
				[{EIFFEL_LIBRARY_OVERRIDE_APP}, "*"],
				[{EIFFEL_LIBRARY_OVERRIDE_GENERATOR}, "*"]
			>>
		end

end
