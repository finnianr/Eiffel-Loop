note
	description: "OS command constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-09-01 10:09:13 GMT (Wednesday 1st September 2021)"
	revision: "1"

class
	EL_OS_COMMAND_CONSTANTS

feature {NONE} -- Strings

	Command_suffix: ZSTRING
		once
			Result := "_COMMAND"
		end

	Enabled_suffix: STRING = "_enabled"

	EL_prefix: ZSTRING
		once
			Result := "EL_"
		end

	Error_redirection_operator: ZSTRING
		once
			Result := "2>"
		end

	Null_and_space: ZSTRING
		once
			Result := "%U "
		end

	Tab_and_new_line: ZSTRING
		once
			Result := "%T%N"
		end

	Temporary_path_format: ZSTRING
		once
			Result := "%S/%S/%S.00.%S"
		end

	Variable_cwd: ZSTRING
		once
			Result := "$CWD"
		end

feature {NONE} -- Constants

	Empty_list: EL_ZSTRING_LIST
		once ("PROCESS")
			create Result.make_empty
		end

	File_system_mutex: MUTEX
		once ("PROCESS")
			create Result.make
		end

end