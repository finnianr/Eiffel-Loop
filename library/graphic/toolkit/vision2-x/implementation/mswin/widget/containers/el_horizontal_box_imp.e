note
	description: "Summary description for {EL_HORIZONTAL_BOX_IMP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-09-02 10:55:12 GMT (Tuesday 2nd September 2014)"
	revision: "4"

class
	EL_HORIZONTAL_BOX_IMP

inherit
	EV_HORIZONTAL_BOX_IMP

create
	make

feature -- Basic operations

	force_width (a_width: INTEGER)
		do
			ev_apply_new_size (0, 0, a_width, height, True)
		end
end
