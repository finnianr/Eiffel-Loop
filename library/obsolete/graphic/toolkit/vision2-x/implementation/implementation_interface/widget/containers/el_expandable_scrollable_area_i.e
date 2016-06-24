note
	description: "Summary description for {EL_EXPANDABLE_SCROLLABLE_AREA_I}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:33:27 GMT (Thursday 11th December 2014)"
	revision: "5"

deferred class
	EL_EXPANDABLE_SCROLLABLE_AREA_I

inherit
	EV_CELL_I

feature {EL_EXPANDABLE_SCROLLABLE_AREA} -- Element change

	on_initial_resize (a_x, a_y, a_width, a_height: INTEGER)
		deferred
		end

	on_resize (a_x, a_y, a_width, a_height: INTEGER)
		deferred
		end

end
