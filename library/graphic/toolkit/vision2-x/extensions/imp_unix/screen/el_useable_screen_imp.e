note
	description: "Unix implementation of [$source EL_USEABLE_SCREEN_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-07-30 12:41:48 GMT (Thursday 30th July 2020)"
	revision: "5"

class
	EL_USEABLE_SCREEN_IMP

inherit
	EL_USEABLE_SCREEN_I

	CAIRO_GTK_INIT_API

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
