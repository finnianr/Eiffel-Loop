note
	description: "Windows implementation of [$source EL_USEABLE_SCREEN_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-09-23 16:03:03 GMT (Wednesday 23rd September 2020)"
	revision: "5"

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
			--
		do
			Precursor
			create area.make (0, 0, 0, 0)
		end

end