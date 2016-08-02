note
	description: "Command to find file count and directory file content size"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-06-19 13:27:56 GMT (Sunday 19th June 2016)"
	revision: "1"

deferred class
	EL_DIRECTORY_INFO_COMMAND_I

inherit
	EL_SINGLE_PATH_OPERAND_COMMAND_I
		rename
			path as target_path,
			set_path as set_target_path
		undefine
			make_default, do_command, new_command_string
		redefine
			make, target_path, var_name_path, reset
		end

	EL_CAPTURED_OS_COMMAND_I
		redefine
			make_default, reset
		end

feature {NONE} -- Initialization

	make (a_target_path: like target_path)
			--
		do
			Precursor (a_target_path)
			execute
		end

	make_default
			--
		do
			create target_path
			Precursor {EL_CAPTURED_OS_COMMAND_I}
		end

feature -- Access

	file_count: INTEGER

	size: INTEGER

	target_path: EL_DIR_PATH

feature {NONE} -- Evolicity reflection

	Var_name_path: ZSTRING
		once
			Result := "target_path"
		end

feature {NONE} -- Implementation

	reset
		do
			Precursor {EL_CAPTURED_OS_COMMAND_I}
			file_count := 0
			size := 0
		end
end