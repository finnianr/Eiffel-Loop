note
	description: "[
		Gathers info on all system users determined by listing directories in `C:\Users' (Windows) or `/home' (Linux)
		For Windows, hidden or system directories are ignored, also the Public folder
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-12-25 12:03:42 GMT (Tuesday 25th December 2018)"
	revision: "5"

deferred class
	EL_USERS_INFO_COMMAND_I

inherit
	EL_DIR_PATH_OPERAND_COMMAND_I
		rename
			dir_path as users_dir,
			set_dir_path as set_users_dir,
			make as make_with_path
		undefine
			do_command, make_default, new_command_string
		end

	EL_CAPTURED_OS_COMMAND_I
		redefine
			make_default, do_with_lines
		end

feature {NONE} -- Initialization

	make
		do
			make_with_path (Directory.users)
			execute
		end

	make_default
			--
		do
			create user_list.make (3)
			user_list.compare_objects
			Precursor {EL_CAPTURED_OS_COMMAND_I}
		end

feature -- Access

	user_list: EL_ZSTRING_LIST
		-- list of user names

	configuration_dir_list: like new_dir_list
		do
			Result := new_dir_list (Directory.App_configuration)
		end

	data_dir_list: like new_dir_list
		do
			Result := new_dir_list (Directory.app_data)
		end

feature {NONE} -- Implementation

	new_dir_list (dir: EL_DIR_PATH): EL_ARRAYED_LIST [EL_DIR_PATH]
		local
			steps: EL_PATH_STEPS; index: INTEGER
		do
			steps := dir
			index := users_dir.step_count
			create Result.make (user_list.count)
			across user_list as user loop
				steps [index] := user.item
				Result.extend (steps)
			end
		end

	do_with_lines (lines: like adjusted_lines)
			--
		do
			user_list.wipe_out
			from lines.start until lines.after loop
				if not lines.item.is_empty then
					user_list.extend (lines.item)
				end
				lines.forth
			end
		end

end
