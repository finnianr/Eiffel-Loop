note
	description: "Unix implementation of [$source EL_DIRECTORY_INFO_COMMAND_I] interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-09-01 9:23:58 GMT (Wednesday 1st September 2021)"
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
			do_command, new_command_parts, reset
		end

create
	make, make_default

feature {NONE} -- Implementation

	do_with_lines (a_lines: like adjusted_lines)
			--
		do
			from a_lines.start until a_lines.after loop
				if a_lines.item.is_integer_32 then
					size := size + a_lines.item.to_integer_32
					file_count := file_count + 1
				end
				a_lines.forth
			end
		end

feature {NONE} -- Constants

	Template: STRING = "[
		find $target_path -type f -printf "%s\n"
	]"

end