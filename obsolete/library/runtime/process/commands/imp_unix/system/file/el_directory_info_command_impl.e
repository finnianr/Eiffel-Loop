note
	description: "Windows command to find file count and directory file content size"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-05-16 17:19:29 GMT (Monday 16th May 2016)"
	revision: "1"

class
	EL_DIRECTORY_INFO_COMMAND_IMPL

inherit
	EL_OS_COMMAND_IMPL

feature -- Access

	size: INTEGER

	file_count: INTEGER

feature {EL_DIRECTORY_INFO_COMMAND} -- Implementation

	do_with_lines (a_lines: EL_FILE_LINE_SOURCE)
			--
		do
		end

feature {NONE} -- Constants

	Template: STRING = "[
		dir /S "$target_path"
	]"

end
