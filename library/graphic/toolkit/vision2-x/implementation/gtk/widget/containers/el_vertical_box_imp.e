note
	description: "Summary description for {EL_VERTICAL_BOX_IMP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:20:59 GMT (Thursday 12th October 2017)"
	revision: "2"

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