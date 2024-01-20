note
	description: "[
		Command line interface to ${PYXIS_TREE_TO_XML_COMPILER} which compiles a tree of
		Pyxis source files into single XML file.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:27 GMT (Saturday 20th January 2024)"
	revision: "20"

class
	PYXIS_TREE_TO_XML_COMPILER_APP

inherit
	EL_COMMAND_LINE_APPLICATION [PYXIS_TREE_TO_XML_COMPILER]
		redefine
			Option_name, visible_types
		end

create
	make

feature {NONE} -- Implementation

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := <<
				optional_argument ("manifest", "Path to manifest of directories and files", << file_must_exist >>),
				optional_argument ("source", "Source tree directory", << directory_must_exist >>),
				required_argument ("output", "Output file path", No_checks)
			>>
		end

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make ("", "", "")
		end

	visible_types: TUPLE [PYXIS_TREE_TO_XML_COMPILER]
		do
			create Result
		end

feature {NONE} -- Constants

	Option_name: STRING = "pyxis_compile"

end