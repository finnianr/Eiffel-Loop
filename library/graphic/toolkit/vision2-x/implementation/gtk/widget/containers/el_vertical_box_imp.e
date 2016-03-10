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
			-- Workaround for Windows layout problem
			-- Does nothing in Unix
		do
		end
end
