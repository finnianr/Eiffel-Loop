note
	description: "Vertical box imp"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:13 GMT (Thursday 20th September 2018)"
	revision: "5"

class
	EL_VERTICAL_BOX_IMP

inherit
	EV_VERTICAL_BOX_IMP

create
	make

feature -- Basic operations

	force_resize (a_width: INTEGER)
		do
			ev_apply_new_size (0, 0, a_width, height, True)
		end
end