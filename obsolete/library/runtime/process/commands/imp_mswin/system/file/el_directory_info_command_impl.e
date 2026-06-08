note
	description: "Windows command to find file count and directory file content size"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-05-17 10:09:04 GMT (Tuesday 17th May 2016)"
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
		local
			summary_line, size_string: STRING
			summary_parts: LIST [STRING]
		do
			from a_lines.start until a_lines.after or a_lines.item.ends_with (Total_files_listed) loop
				a_lines.forth
			end
			if not a_lines.after then
				a_lines.forth
				summary_line := a_lines.item
				summary_line.left_adjust
				summary_parts := summary_line.split (' ')
				file_count := summary_parts.first.to_integer
				summary_parts.finish
				summary_parts.back
				size_string := summary_parts.item
				size_string.prune_all (',')
				size := size_string.to_integer
			end
		end

feature {NONE} -- Constants

	Template: STRING = "dir /S $target_path"

	Total_files_listed: ZSTRING
		once
			Result := "Total Files Listed:"
		end

end
