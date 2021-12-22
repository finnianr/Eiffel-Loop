note
	description: "Windows implementation of [$source EL_DIRECTORY_INFO_COMMAND_I] interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-12-20 19:25:30 GMT (Monday 20th December 2021)"
	revision: "8"

class
	EL_DIRECTORY_INFO_COMMAND_IMP

inherit
	EL_DIRECTORY_INFO_COMMAND_I
		export
			{NONE} all
		end

	EL_OS_COMMAND_IMP
		undefine
			do_command, new_command_parts, reset
		end

create
	make, make_default

feature {EL_DIRECTORY_INFO_COMMAND_I} -- Implementation

	do_with_lines (a_lines: like adjusted_lines)
		-- Parse output like the following to obtain file count and total bytes
		-- Total Files Listed:
		--          17 File(s)         65,246 bytes
		--           5 Dir(s)  31,614,328,832 bytes free
		local
			summary_line: ZSTRING; summary_parts: EL_SPLIT_ZSTRING_LIST
		do
			from a_lines.start until a_lines.after or a_lines.item.ends_with (Total_files_listed) loop
				a_lines.forth
			end
			if not a_lines.after then
				a_lines.forth
				summary_line := a_lines.item
				summary_line.left_adjust
				create summary_parts.make (summary_line, ' ')
				if summary_parts.count >= 3 then
					file_count := summary_parts.first.to_integer
					-- second last word
					if attached summary_parts.circular_i_th_copy (-2) as size_string then
						size_string.prune_all (',')
						size := size_string.to_integer
					end
				end
			end
		end


feature {NONE} -- Constants

	Template: STRING = "dir /S $target_path"

	Total_files_listed: ZSTRING
		once
			Result := "Total Files Listed:"
		end

end