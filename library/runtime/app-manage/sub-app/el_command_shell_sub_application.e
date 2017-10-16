note
	description: "Summary description for {EL_COMMAND_SHELL_SUB_APPLICATTION}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-16 10:37:07 GMT (Monday 16th October 2017)"
	revision: "5"

deferred class
	EL_COMMAND_SHELL_SUB_APPLICATION [C -> EL_COMMAND_SHELL_COMMAND]

inherit
	EL_COMMAND_LINE_SUB_APPLICATION [C]

feature {NONE} -- Implementation

	argument_specs: ARRAY [like specs.item]
		do
			create Result.make_empty
		end

	default_make: PROCEDURE
		do
			Result := agent {EL_COMMAND_SHELL_COMMAND}.make_shell
		end

end
