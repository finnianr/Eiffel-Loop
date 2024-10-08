note
	description: "Unix implementation of ${EL_OS_COMMAND_IMP} for find commands"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-13 8:29:31 GMT (Friday 13th September 2024)"
	revision: "14"

deferred class
	EL_FIND_COMMAND_IMP

inherit
	EL_CAPTURED_OS_COMMAND_IMP
		undefine
			getter_function_table, make_default, reset
		redefine
			new_output_lines
		end

	EL_UNIX_FIND_TEMPLATE
		undefine
			is_equal
		end

feature {NONE} -- Implementation

	new_output_lines (file_path: FILE_PATH): EL_PLAIN_TEXT_LINE_SOURCE
		do
			create Result.make (output_encoding, file_path)
		end

end