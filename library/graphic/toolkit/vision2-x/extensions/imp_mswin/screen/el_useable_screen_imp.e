note
	description: "Windows implementation of ${EL_USEABLE_SCREEN_I}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:25 GMT (Saturday 20th January 2024)"
	revision: "8"

class
	EL_USEABLE_SCREEN_IMP

inherit
	EL_USEABLE_SCREEN_I
		redefine
			make
		end

	EL_WINDOWS_IMPLEMENTATION

create
	make

feature {NONE} -- Initialization

	make
			--
		do
			Precursor
			create area.make (0, 0, 0, 0)
		end

end