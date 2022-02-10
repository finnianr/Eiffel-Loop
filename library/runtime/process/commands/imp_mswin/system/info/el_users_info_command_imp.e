note
	description: "Windows implementation of [$source EL_USERS_INFO_COMMAND_I] interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-10 17:42:10 GMT (Thursday 10th February 2022)"
	revision: "11"

class
	EL_USERS_INFO_COMMAND_IMP

inherit
	EL_USERS_INFO_COMMAND_I
		export
			{NONE} all
		end

	EL_OS_COMMAND_IMP
		undefine
			do_command, new_command_parts
		end

	EL_MODULE_EXECUTION_ENVIRONMENT

create
	make

feature {NONE} -- Implementation

	is_user (name: ZSTRING): BOOLEAN
		-- True if name is a user recognised by "net user" command
		do
			if name.count > 0 then
				Net_user_cmd.put_string (Var_name, name)
				Net_user_cmd.execute
				Result := not Net_user_cmd.lines.is_empty
			end
		end

feature {NONE} -- Constants

	Template: STRING = "dir /B /AD-S-H $users_dir"
		-- Directories that do not have the hidden or system attribute set

	Net_user_cmd: EL_CAPTURED_OS_COMMAND
		once
			create Result.make_with_name ("net-user", "net user $name")
		end

	Var_name: STRING = "name"

end