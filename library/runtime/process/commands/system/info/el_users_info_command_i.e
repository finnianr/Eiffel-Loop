note
	description: "[
		Creates a list of system users that have a directory in `Directory.home'.		
		For Windows this is usually `C:\Users' and for Linux `/home'

		The user list is best accessed via {[$source EL_MODULE_SYSTEM]}.user_list
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-21 17:00:20 GMT (Monday 21st February 2022)"
	revision: "16"

deferred class
	EL_USERS_INFO_COMMAND_I

inherit
	EL_DIR_PATH_OPERAND_COMMAND_I
		rename
			dir_path as users_dir,
			set_dir_path as set_users_dir,
			make as make_with_path
		undefine
			do_command, make_default, new_command_parts
		end

	EL_CAPTURED_OS_COMMAND_I
		undefine
			getter_function_table, Transient_fields
		redefine
			make_default, do_with_lines
		end

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