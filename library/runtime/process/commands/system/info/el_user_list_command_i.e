note
	description: "[
		List of users determined by listing directories in C:\Users (Windows) or /home (Linux)
		For Windows, hidden or system directories are ignored, also the Public folder
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-06-21 11:12:34 GMT (Tuesday 21st June 2016)"
	revision: "5"

deferred class
	EL_USER_LIST_COMMAND_I

inherit
	EL_SINGLE_PATH_OPERAND_COMMAND_I
		rename
			path as users_path,
			make as make_with_path
		undefine
			do_command, make_default, new_command_string
		redefine
			users_path
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
			create users_path
			Precursor {EL_CAPTURED_OS_COMMAND_I}
		end

feature -- Access

	list: EL_ZSTRING_LIST

	users_path: EL_DIR_PATH

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
