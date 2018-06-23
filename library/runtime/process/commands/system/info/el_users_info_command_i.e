note
	description: "[
		Gathers info on all system users determined by listing directories in `C:\Users' (Windows) or `/home' (Linux)
		For Windows, hidden or system directories are ignored, also the Public folder
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-06-23 10:08:46 GMT (Saturday 23rd June 2018)"
	revision: "3"

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
			make_with_path (new_users_dir)
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
			Result := new_dir_list (Directory.User_configuration_steps)
		end

	data_dir_list: like new_dir_list
		do
			Result := new_dir_list (Directory.user_data_steps)
		end

feature {NONE} -- Implementation

	new_dir_list (relative_steps: EL_PATH_STEPS): EL_ARRAYED_LIST [EL_DIR_PATH]
		local
			steps: EL_PATH_STEPS
		do
			steps := relative_steps.twin
			steps.put_front (Empty_string)
			create Result.make (user_list.count)
			across user_list as user loop
				steps [1] := user.item
				Result.extend (users_dir.joined_dir_steps (steps))
			end
		end

	new_users_dir: EL_DIR_PATH
		deferred
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
