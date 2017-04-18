note
	description: "Summary description for {EL_EXPANDED_CELL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-01-27 9:41:19 GMT (Friday 27th January 2017)"
	revision: "2"

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
