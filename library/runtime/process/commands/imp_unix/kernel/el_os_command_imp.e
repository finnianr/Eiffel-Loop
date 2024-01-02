note
	description: "Unix implementation of [$source EL_OS_COMMAND_I] interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-02 17:17:26 GMT (Tuesday 2nd January 2024)"
	revision: "19"

deferred class
	EL_OS_COMMAND_IMP

inherit
	EL_OS_COMMAND_I
		export
			{NONE} all
		undefine
			getter_function_table, is_equal, make_default, new_transient_fields
		end

	EL_UNIX_IMPLEMENTATION
		export
			{NONE} all
		end

feature {NONE} -- Implementation

	new_output_lines (file_path: FILE_PATH): EL_PLAIN_TEXT_LINE_SOURCE
		do
			create Result.make (output_encoding, file_path)
		end

	run_as_administrator (command: ZSTRING)
		-- Windows only routines
		do
		end

feature {NONE} -- Constants

	Command_prefix: STRING_32
		once
			create Result.make_empty
		end

	Null_redirection: ZSTRING
		once
			Result := "> /dev/null 2>&1"
		end

end