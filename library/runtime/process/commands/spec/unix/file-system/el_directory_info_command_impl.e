note
	description: "Windows command to find file count and directory file content size"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-06-24 10:35:51 GMT (Wednesday 24th June 2015)"
	revision: "3"

class
	EL_DIRECTORY_INFO_COMMAND_IMPL

inherit
	EL_COMMAND_IMPL

create
	make

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
