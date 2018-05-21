note
	description: "Horizontal box imp"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:21 GMT (Saturday 19th May 2018)"
	revision: "3"

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