note
	description: "Unix implementation of [$source EL_USEABLE_SCREEN_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-09-23 16:02:46 GMT (Wednesday 23rd September 2020)"
	revision: "6"

class
	EL_USEABLE_SCREEN_IMP

inherit
	EL_USEABLE_SCREEN_I
		redefine
			make
		end

	CAIRO_GTK_INIT_API

	EL_OS_IMPLEMENTATION

create
	make

feature {NONE} -- Initialization

	make
		local
			values: SPECIAL [INTEGER]
		do
			Precursor
			create values.make_filled (0, 4)
			c_gtk_get_useable_screen_area (values.base_address)
			create area.make (values [0], values [1], values [2], values [3])
		end

end