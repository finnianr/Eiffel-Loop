note
	description: "Unix implementation of [$source EL_OS_COMMAND_IMP] for find commands"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-10 18:23:36 GMT (Thursday 10th February 2022)"
	revision: "9"

deferred class
	EL_FIND_COMMAND_IMP

inherit
	EL_OS_COMMAND_IMP
		undefine
			do_command, new_command_parts, reset
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