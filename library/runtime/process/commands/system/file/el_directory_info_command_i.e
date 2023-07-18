note
	description: "Command to find file count and directory file content size"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-07-18 15:29:48 GMT (Tuesday 18th July 2023)"
	revision: "9"

deferred class
	EL_DIRECTORY_INFO_COMMAND_I

inherit
	EL_DIR_PATH_OPERAND_COMMAND_I
		rename
			dir_path as target_path,
			set_dir_path as set_target_path
		undefine
			do_command, new_command_parts
		redefine
			make, reset
		end

	EL_CAPTURED_OS_COMMAND_I
		undefine
			getter_function_table, make_default, new_transient_fields
		redefine
			reset
		end

feature {NONE} -- Initialization

	make (a_target_path: like target_path)
			--
		do
			Precursor (a_target_path)
			execute
		end

feature -- Access

	file_count: INTEGER

	size: INTEGER

feature {NONE} -- Implementation

	reset
		do
			Precursor
			file_count := 0
			size := 0
		end
end