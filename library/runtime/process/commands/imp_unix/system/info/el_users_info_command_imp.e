note
	description: "Unix implementation of [$source EL_USERS_INFO_COMMAND_I] interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-21 12:03:50 GMT (Monday 21st February 2022)"
	revision: "11"

class
	EL_USERS_INFO_COMMAND_IMP

inherit
	EL_USERS_INFO_COMMAND_I
		export
			{NONE} all
		end

	EL_OS_COMMAND_IMP
		undefine
			do_command, new_command_parts
		end

create
	make

feature {NONE} -- Implementation

	do_with_lines (lines: like new_output_lines)
		do
			across lines as line loop
				if line.item.count > 0 then
					user_list.extend (line.item)
				end
			end
		end

feature {NONE} -- Constants

	Template: STRING = "ls $users_dir"

end