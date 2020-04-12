note
	description: "Command shell sub application"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-04-11 11:30:33 GMT (Saturday 11th April 2020)"
	revision: "14"

deferred class
	EL_COMMAND_SHELL_SUB_APPLICATION [C -> EL_COMMAND_SHELL_COMMAND]

inherit
	EL_COMMAND_LINE_SUB_APPLICATION [C]

feature {NONE} -- Implementation

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			create Result.make_empty
		end

	default_make: PROCEDURE [like command]
		do
			Result := agent make_shell (?, Menu_name, 10)
		end

	make_shell (cmd: like command; name: READABLE_STRING_GENERAL; a_row_count: INTEGER)
		do
			cmd.make_shell (name, a_row_count)
		end

	menu_name: READABLE_STRING_GENERAL
		do
			Result := "MAIN"
		end

end
