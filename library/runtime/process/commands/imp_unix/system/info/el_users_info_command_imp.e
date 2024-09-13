note
	description: "Unix implementation of ${EL_USERS_INFO_COMMAND_I} interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-13 8:27:45 GMT (Friday 13th September 2024)"
	revision: "17"

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
				if line.shared_item.count > 0 then
					user_list.extend (line.item_copy)
				end
			end
		end

feature {NONE} -- Constants

	Template: STRING = "ls $users_dir"

end