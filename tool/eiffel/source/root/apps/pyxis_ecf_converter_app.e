note
	description: "Command line interface to command [$source PYXIS_ECF_CONVERTER]"
	notes: "[
		Converts Pyxis format Eiffel project configuration with `.pecf' extension to `.ecf' XML file
		
		Usage:
		
			el_eiffel -pecf_to_xml -in <project.pecf> [-out <name>]

	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-03 15:52:09 GMT (Monday 3rd January 2022)"
	revision: "5"

class
	PYXIS_ECF_CONVERTER_APP

inherit
	EL_COMMAND_LINE_SUB_APPLICATION [PYXIS_ECF_CONVERTER]
		redefine
			Option_name, visible_types
		end

create
	make

feature {NONE} -- Implementation

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := <<
				valid_required_argument ("in", "Input file path", << file_must_exist >>),
				optional_argument ("out", "Output file path")
			>>
		end

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make (create {FILE_PATH}, create {FILE_PATH})
		end

	visible_types: TUPLE [PYXIS_ECF_CONVERTER]
		-- types with lio output visible in console
		-- See: {EL_CONSOLE_MANAGER_I}.show_all
		do
			create Result
		end

feature {NONE} -- Constants

	Option_name: STRING = "pecf_to_xml"

	Description: STRING = "Convert Pyxis format Eiffel project configuration to `.ecf' XML file"

end