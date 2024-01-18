note
	description: "Windows implementation of ${EL_USEABLE_SCREEN_I}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-05 17:16:34 GMT (Sunday 5th November 2023)"
	revision: "7"

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