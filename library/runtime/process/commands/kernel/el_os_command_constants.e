note
	description: "OS command constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-29 10:38:31 GMT (Saturday 29th March 2025)"
	revision: "6"

class
	EL_OS_COMMAND_CONSTANTS

feature {NONE} -- Strings

	IMP_COMMAND_suffix: ARRAY [STRING]
		once
			Result := << "IMP", "COMMAND" >>
		ensure
			imp_first: Result.item (1)[1] = 'I'
		end

	Enabled_suffix: STRING = "_enabled"

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

	Sudo_command: ZSTRING
		once
			Result := "sudo"
		end

end