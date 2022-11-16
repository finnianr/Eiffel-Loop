note
	description: "Horizontal box imp"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "6"

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