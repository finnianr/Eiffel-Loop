note
	description: "Expanded cell"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "6"

class
	EL_EXPANDED_CELL

inherit
	EV_CELL

	EL_EXPANDABLE
		undefine
			is_equal, copy, default_create
		end

create
	default_create

end