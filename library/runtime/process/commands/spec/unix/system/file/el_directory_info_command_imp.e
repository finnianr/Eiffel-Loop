note
	description: "Unix implementation of [$source EL_DIRECTORY_INFO_COMMAND_I] interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:21:01 GMT (Thursday 12th October 2017)"
	revision: "2"

class
	EL_DIRECTORY_INFO_COMMAND_IMP

inherit
	EL_DIRECTORY_INFO_COMMAND_I
		export
			{NONE} all
		end

	EL_OS_COMMAND_IMP
		undefine
			do_command, make_default, new_command_string, reset
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
