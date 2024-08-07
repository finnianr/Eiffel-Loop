note
	description: "Unix implementation of ${EL_USERS_INFO_COMMAND_I} interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-03-29 11:45:23 GMT (Friday 29th March 2024)"
	revision: "16"

class
	EL_USERS_INFO_COMMAND_IMP

inherit
	EL_USERS_INFO_COMMAND_I
		export
			{NONE} all
		end
	
	EL_UNIX_IMPLEMENTATION

	EL_CAPTURED_OS_COMMAND_IMP
		undefine
			make_default
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