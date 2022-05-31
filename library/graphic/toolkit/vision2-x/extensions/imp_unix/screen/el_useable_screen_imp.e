note
	description: "Unix implementation of [$source EL_USEABLE_SCREEN_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-05-31 8:34:33 GMT (Tuesday 31st May 2022)"
	revision: "7"

class
	EL_USEABLE_SCREEN_IMP

inherit
	EL_USEABLE_SCREEN_I
		redefine
			make
		end

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
			{EL_GTK_2_C_API}.gtk_get_useable_screen_area (values.base_address)
			create area.make (values [0], values [1], values [2], values [3])
		end

end