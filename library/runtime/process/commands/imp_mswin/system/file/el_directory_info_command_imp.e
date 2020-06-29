note
	description: "Windows implementation of [$source EL_DIRECTORY_INFO_COMMAND_I] interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-06-28 9:13:15 GMT (Sunday 28th June 2020)"
	revision: "6"

class
	EL_DIRECTORY_INFO_COMMAND_IMP

inherit
	EL_DIRECTORY_INFO_COMMAND_I
		export
			{NONE} all
		end

	EL_OS_COMMAND_IMP
		undefine
			do_command, make_default, new_command_parts, reset
		end

create
	make, make_default

feature {EL_DIRECTORY_INFO_COMMAND_I} -- Implementation

	do_with_lines (a_lines: like adjusted_lines)
			--
		local
			summary_line, size_string: ZSTRING
			summary_parts: LIST [ZSTRING]
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
