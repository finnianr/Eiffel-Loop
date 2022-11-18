note
	description: "Script variable assignment parser"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:03 GMT (Tuesday 15th November 2022)"
	revision: "2"

class
	SCRIPT_VARIABLE_ASSIGNMENT_PARSER

create
	make

feature {NONE} -- Initialization

	make (line_utf_8: STRING)
		-- parse contents of `line_utf_8'
		require
			valid_line: line_utf_8.count > 0 and then line_utf_8 [1] = '#'
		do
			-- parsing code here
		end

feature -- Access

	name: STRING_32

	value_list: ARRAYED_LIST [ANY]
end