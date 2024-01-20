note
	description: "[
		Sub app to compile tree of Pyxis translation files into multiple locale files named `locale.x'
		where `x' is a 2 letter country code. Does nothing if source files are all older
		than locale files. See class ${EL_LOCALE}
		
		Syntax:
		
			el_toolkit -compile_translations -source <source tree dir> -output <output dir>
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:27 GMT (Saturday 20th January 2024)"
	revision: "22"

class
	PYXIS_TRANSLATION_TREE_COMPILER_APP

inherit
	EL_COMMAND_LINE_APPLICATION [PYXIS_TRANSLATION_TREE_COMPILER]
		redefine
			Option_name, visible_types
		end

	EL_ZSTRING_CONSTANTS

create
	make

feature {NONE} -- Implementation

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := <<
				optional_argument ("manifest", "Path to manifest of directories and files", << file_must_exist >>),
				optional_argument ("source", "Source tree directory", << directory_must_exist >>),
				optional_argument ("output", "Output directory path", No_checks)
			>>
		end

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make (Empty_string, Empty_string, "resources/locales")
		end

	visible_types: TUPLE [PYXIS_TRANSLATION_TREE_COMPILER]
		do
			create Result
		end

feature {NONE} -- Constants

	Option_name: STRING = "compile_translations"

end