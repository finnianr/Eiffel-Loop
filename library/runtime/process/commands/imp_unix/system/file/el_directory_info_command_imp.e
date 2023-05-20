note
	description: "Unix implementation of [$source EL_DIRECTORY_INFO_COMMAND_I] interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-05-20 9:08:02 GMT (Saturday 20th May 2023)"
	revision: "9"

class
	EL_DIRECTORY_INFO_COMMAND_IMP

inherit
	EL_DIRECTORY_INFO_COMMAND_I
		export
			{NONE} all
		end

	EL_OS_CAPTURED_COMMAND_IMP
		undefine
			reset
		end

create
	make, make_default

feature {NONE} -- Implementation

	do_with_lines (a_lines: like new_output_lines)
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