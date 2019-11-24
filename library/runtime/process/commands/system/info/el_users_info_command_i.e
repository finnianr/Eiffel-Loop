note
	description: "[
		Gathers info on all system users determined by listing directories in `C:\Users' (Windows) or `/home' (Linux)
		For Windows, hidden or system directories are ignored, also the Public folder
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-11-24 12:57:41 GMT (Sunday 24th November 2019)"
	revision: "7"

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

	configuration_dir_list: like new_dir_list
		do
			Result := new_dir_list (Directory.App_configuration)
		end

	data_dir_list: like new_dir_list
		do
			Result := new_dir_list (Directory.app_data)
		end

	user_list: EL_ZSTRING_LIST
		-- list of user names

feature -- Basic operations

	do_for_existing_directories (do_with: PROCEDURE [EL_DIR_PATH])
		-- apply `do_with' action to every configuration and data directory for all users
		do
			across << configuration_dir_list, data_dir_list >> as dir_list loop
				across dir_list.item as dir loop
					if dir.item.exists then
						do_with (dir.item)
					end
				end
			end
		end

feature {NONE} -- Implementation

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

	new_dir_list (dir: EL_DIR_PATH): EL_ARRAYED_LIST [EL_DIR_PATH]
		local
			steps: EL_PATH_STEPS; index: INTEGER
		do
			steps := dir
			index := users_dir.step_count
			create Result.make (user_list.count)
			across user_list as user loop
				steps [index + 1] := user.item
				Result.extend (steps)
			end
		end

end
