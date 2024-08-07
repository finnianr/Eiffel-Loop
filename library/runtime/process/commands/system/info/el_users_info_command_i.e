note
	description: "[
		Creates a list of system users that have a directory in `Directory.home'.		
		For Windows this is usually `C:\Users' and for Linux `/home'

		The user list is best accessed via ${EL_MODULE_SYSTEM}.user_list
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-04-04 10:34:28 GMT (Thursday 4th April 2024)"
	revision: "22"

deferred class
	EL_USERS_INFO_COMMAND_I

inherit
	EL_DIR_PATH_OPERAND_COMMAND_I
		rename
			dir_path as users_dir,
			set_dir_path as set_users_dir,
			make as make_with_path
		undefine
			do_command, is_captured, make_default, new_command_parts
		end

	EL_CAPTURED_OS_COMMAND_I
		undefine
			getter_function_table, new_transient_fields
		redefine
			make_default, do_with_lines
		end

	EL_OS_DEPENDENT

feature {NONE} -- Initialization

	make
		do
			make_with_path (Directory.Users)
			execute
		end

	make_default
			--
		do
			create user_list.make (3)
			Precursor {EL_CAPTURED_OS_COMMAND_I}
		end

feature -- Access

	user_list: EL_ZSTRING_LIST
		-- list of user names
end