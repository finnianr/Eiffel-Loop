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
	date: "2024-07-29 8:24:55 GMT (Monday 29th July 2024)"
	revision: "24"

class
	PYXIS_LOCALE_COMPILER_APP

inherit
	EL_COMMAND_LINE_APPLICATION [EL_PYXIS_LOCALE_COMPILER]
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
				optional_argument ("output", "Output directory path", No_checks)
			>>
		end

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make (create {FILE_PATH}, create {DIR_PATH}, Directory.new ("resources/locales"))
		end

	visible_types: TUPLE [EL_PYXIS_LOCALE_COMPILER]
		do
			create Result
		end

feature {NONE} -- Constants

	Option_name: STRING = "compile_translations"

end