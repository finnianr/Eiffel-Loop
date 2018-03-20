note
	description: "Unix implementation of [$source EL_USEABLE_SCREEN_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-03-12 8:48:46 GMT (Monday 12th March 2018)"
	revision: "3"

class
	EL_USEABLE_SCREEN_IMP

inherit
	EL_USEABLE_SCREEN_I

	EL_GTK_INIT_API

	EL_OS_IMPLEMENTATION

create
	make

feature {NONE} -- Initialization

	make
		local
			values: SPECIAL [INTEGER]
		do
			create values.make_filled (0, 4)
			c_gtk_get_useable_screen_area (values.base_address)
			create area.make (values [0], values [1], values [2], values [3])
		end

end
