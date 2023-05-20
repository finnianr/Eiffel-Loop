note
	description: "Unix implementation of [$source EL_OS_COMMAND_IMP] for find commands"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-05-20 9:15:53 GMT (Saturday 20th May 2023)"
	revision: "11"

deferred class
	EL_FIND_COMMAND_IMP

inherit
	EL_OS_CAPTURED_COMMAND_IMP
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
			Result.enable_shared_item
		end

end