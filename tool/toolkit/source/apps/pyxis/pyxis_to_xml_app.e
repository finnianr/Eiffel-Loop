note
	description: "Command line interface to command ${EL_PYXIS_TO_XML_CONVERTER}"
	notes: "[
		Usage:
			
			el_toolkit -pyxis_to_xml -in <input-file-path> [-out <output-file-path>]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "30"

class
	PYXIS_TO_XML_APP

inherit
	EL_COMMAND_LINE_APPLICATION [EL_PYXIS_TO_XML_CONVERTER]
		redefine
			Option_name, visible_types
		end

create
	make

feature {NONE} -- Implementation

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := <<
				required_argument ("in", "Input file path", << file_must_exist >>),
				optional_argument ("out", "Output file path", No_checks)
			>>
		end

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make ("", "")
		end

	visible_types: TUPLE [EL_PYXIS_TO_XML_CONVERTER]
		-- types with lio output visible in console
		-- See: {EL_CONSOLE_MANAGER_I}.show_all
		do
			create Result
		end

feature {NONE} -- Constants

	Option_name: STRING = "pyxis_to_xml"

end