note
	description: "Windows implementation of [$source EL_OS_COMMAND_I] interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-10 17:56:33 GMT (Thursday 10th February 2022)"
	revision: "15"

deferred class
	EL_OS_COMMAND_IMP

inherit
	EL_OS_COMMAND_I
		undefine
			getter_function_table, make_default, Transient_fields
		end

	EL_OS_IMPLEMENTATION

	EL_SHARED_ENCODINGS

	EL_FILE_OPEN_ROUTINES

feature {NONE} -- Implementation

	new_output_lines (file_path: FILE_PATH): EL_PLAIN_TEXT_LINE_SOURCE
		do
			create Result.make_encoded (Encodings.Console, file_path)
		end

feature -- Constants

	Command_prefix: STRING_32
		-- Force output of command to be UTF-16
		once
			Result := "cmd /U /C"
		end

	Error_redirection_suffix: STRING = ""

end