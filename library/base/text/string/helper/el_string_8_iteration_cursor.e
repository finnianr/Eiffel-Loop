note
	description: "External forward one-step iteration cursor for `STRING_8'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-03 17:02:30 GMT (Sunday 3rd January 2021)"
	revision: "1"

class
	EL_STRING_8_ITERATION_CURSOR

inherit
	STRING_8_ITERATION_CURSOR
		export
			{STRING_HANDLER} area, area_first_index, area_last_index, make
		end

create
	make_empty

feature {NONE} -- Initialization

	make_empty
		do
			make ("")
		end
end