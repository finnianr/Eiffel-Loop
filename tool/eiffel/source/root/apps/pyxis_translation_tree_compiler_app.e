note
	description: "[
		Sub app to compile tree of Pyxis translation files into multiple locale files named `locale.x'
		where `x' is a 2 letter country code. Does nothing if source files are all older
		than locale files. See class [$source EL_LOCALE_I]
		
		Syntax:
		
			el_toolkit -compile_translations -source <source tree dir> -output <output dir>
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-06-25 8:05:22 GMT (Friday 25th June 2021)"
	revision: "14"

class
	PYXIS_TRANSLATION_TREE_COMPILER_APP

inherit
	EL_COMMAND_LINE_SUB_APPLICATION [PYXIS_TRANSLATION_TREE_COMPILER]
		redefine
			Option_name, visible_types
		end

create
	make

feature {NONE} -- Implementation

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := <<
				valid_optional_argument ("manifest", "Path to manifest of directories and files", << file_must_exist >>),
				valid_optional_argument ("source", "Source tree directory", << directory_must_exist >>),
				required_argument ("output", "Output directory path")
			>>
		end

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make ("", "", "")
		end

	visible_types: TUPLE [PYXIS_TRANSLATION_TREE_COMPILER]
		do
			create Result
		end

feature {NONE} -- Constants

	Option_name: STRING = "compile_translations"

	Description: STRING = "Compile tree of Pyxis translation files into multiple locale files"

end