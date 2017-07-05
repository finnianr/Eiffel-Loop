note
	description: "[
		List of users determined by listing directories in `C:\Users' (Windows) or `/home' (Linux)
		For Windows, hidden or system directories are ignored, also the Public folder
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-07-01 10:33:03 GMT (Saturday 1st July 2017)"
	revision: "2"

deferred class
	EL_USER_LIST_COMMAND_I

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
			make_with_path (Directory.user_profile.parent)
			execute
		end

	make_default
			--
		do
			create list.make (3)
			list.compare_objects
			Precursor {EL_CAPTURED_OS_COMMAND_I}
		end

feature -- Access

	list: EL_ZSTRING_LIST

feature {NONE} -- Implementation

	do_with_lines (lines: like adjusted_lines)
			--
		do
			list.wipe_out
			from lines.start until lines.after loop
				if not lines.item.is_empty then
					list.extend (lines.item)
				end
				lines.forth
			end
		end

end
