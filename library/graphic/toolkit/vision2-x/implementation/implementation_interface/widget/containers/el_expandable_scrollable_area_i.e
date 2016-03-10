note
	description: "Summary description for {EL_EXPANDABLE_SCROLLABLE_AREA_I}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-05-28 11:37:36 GMT (Tuesday 28th May 2013)"
	revision: "2"

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
