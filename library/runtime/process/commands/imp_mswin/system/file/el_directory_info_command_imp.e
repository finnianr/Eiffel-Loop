note
	description: "Windows implementation of ${EL_DIRECTORY_INFO_COMMAND_I} interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-13 15:53:04 GMT (Friday 13th September 2024)"
	revision: "16"

class
	EL_DIRECTORY_INFO_COMMAND_IMP

inherit
	EL_DIRECTORY_INFO_COMMAND_I
		export
			{NONE} all
		end

	EL_CAPTURED_OS_COMMAND_IMP
		undefine
			reset
		end

create
	make, make_default

feature {EL_DIRECTORY_INFO_COMMAND_I} -- Implementation

	do_with_lines (a_lines: like new_output_lines)
		-- Parse output like the following to obtain file count and total bytes
		-- Total Files Listed:
		--          17 File(s)         65,246 bytes
		--           5 Dir(s)  31,614,328,832 bytes free
		local
			summary_line: ZSTRING; summary_parts: EL_SPLIT_ZSTRING_LIST
		do
			a_lines.find_first_true (agent {ZSTRING}.ends_with (Total_files_listed))
			if a_lines.found then
				a_lines.forth
				if not a_lines.after then
					summary_line := a_lines.item_copy
					summary_line.left_adjust
					create summary_parts.make (summary_line, ' ')
					if summary_parts.count >= 3 then
						file_count := summary_parts.first_item.to_integer
						-- second last word
						if attached summary_parts.circular_i_th (-2) as size_string then
							size_string.prune_all (',')
							size := size_string.to_integer
						end
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