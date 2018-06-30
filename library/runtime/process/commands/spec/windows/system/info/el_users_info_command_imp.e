note
	description: "Windows implementation of [$source EL_USERS_INFO_COMMAND_I] interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-06-29 11:15:39 GMT (Friday 29th June 2018)"
	revision: "5"

class
	EL_USERS_INFO_COMMAND_IMP

inherit
	EL_USERS_INFO_COMMAND_I
		export
			{NONE} all
		redefine
			adjusted_lines
		end

	EL_OS_COMMAND_IMP
		undefine
			do_command, make_default, new_command_string
		end

	EL_MODULE_EXECUTION_ENVIRONMENT

create
	make

feature {NONE} -- Implementation

	adjusted_lines (lines: EL_ZSTRING_LIST): EL_ZSTRING_LIST
		do
			create Result.make (lines.count)
			lines.do_if (agent Result.extend, agent is_user)
		end

	is_user (name: ZSTRING): BOOLEAN
		-- True if name is a user recognised by "net user" command
		do
			Net_user_cmd.put_string (Var_name, name)
			Net_user_cmd.execute
			Result := not Net_user_cmd.lines.is_empty
		end

feature {NONE} -- Constants

	Template: STRING = "dir /B /AD-S-H $path"
		-- Directories that do not have the hidden or system attribute set

	Net_user_cmd: EL_CAPTURED_OS_COMMAND
		once
			create Result.make_with_name ("net-user", "net user $name")
		end

	Var_name: ZSTRING
		once
			Result := "name"
		end

end
