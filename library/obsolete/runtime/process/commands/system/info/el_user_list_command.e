note
	description: "[
		List of users determined by listing directories in C:\Users (Windows) or /home (Linux)
		For Windows, hidden or system directories are ignored, also the Public folder
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-05-17 17:09:38 GMT (Tuesday 17th May 2016)"
	revision: "1"

class
	EL_USER_LIST_COMMAND

inherit
	EL_SINGLE_OPERAND_FILE_SYSTEM_COMMAND [EL_USER_LIST_COMMAND_IMPL]
		rename
			path as users_path,
			make as make_with_path
		redefine
			do_with_lines, Line_processing_enabled, users_path
		end

create
	make

feature {NONE} -- Initialization

	make
		do
			create list.make (3)
			make_with_path (Directory.user_profile.parent)
		end

feature -- Access

	list: EL_ZSTRING_LIST

	users_path: EL_DIR_PATH

feature {EL_OS_COMMAND_IMPL} -- Implementation

	do_with_lines (lines: EL_LINEAR [ZSTRING])
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

feature {NONE} -- Constants

	Line_processing_enabled: BOOLEAN = true

end