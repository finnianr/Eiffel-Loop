note
	description: "Expanded cell"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:21 GMT (Saturday 19th May 2018)"
	revision: "3"

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
