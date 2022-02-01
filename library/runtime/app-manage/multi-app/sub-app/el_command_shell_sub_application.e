note
	description: "Command shell sub application"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-01 9:50:46 GMT (Tuesday 1st February 2022)"
	revision: "16"

deferred class
	EL_COMMAND_SHELL_SUB_APPLICATION [C -> EL_COMMAND_SHELL_COMMAND]

inherit
	EL_COMMAND_LINE_SUB_APPLICATION [C]

	EL_MODULE_NAMING

feature {NONE} -- Implementation

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := <<
				optional_argument ("title", "Menu title", No_checks),
				optional_argument ("rows", "Number of menu rows", No_checks)
			>>
		end

	default_make: PROCEDURE [like command]
		do
			Result := agent make_shell (?, default_menu_name, default_menu_rows)
		end

	make_shell (cmd: like command; name: READABLE_STRING_GENERAL; a_row_count: INTEGER)
		do
			cmd.make (name, a_row_count)
		end

	default_menu_name: READABLE_STRING_GENERAL
		do
			Result := Naming.class_with_separator (Current, ' ', 0, 1) + " MENU"
		end

	default_menu_rows: INTEGER
		do
			Result := 10
		end

end