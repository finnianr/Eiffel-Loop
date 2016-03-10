note
	description: "Summary description for {EL_VERTICAL_BOX_IMP}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

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
