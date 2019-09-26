note
	description: "Command shell sub application"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-10 8:22:08 GMT (Tuesday 10th September 2019)"
	revision: "12"

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
			Result := agent make_shell (?, Menu_name)
		end

	make_shell (cmd: like command; name: READABLE_STRING_GENERAL)
		do
			cmd.make_shell (name)
		end

	menu_name: READABLE_STRING_GENERAL
		do
			Result := "MAIN"
		end

end
