note
	description: "Windows implementation of [$source EL_USEABLE_SCREEN_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-03-12 9:03:08 GMT (Monday 12th March 2018)"
	revision: "3"

class
	EL_USEABLE_SCREEN_IMP

inherit
	EL_USEABLE_SCREEN_I

	EL_OS_IMPLEMENTATION

create
	make

feature {NONE} -- Initialization

	make
			--
		do
			create area.make (0, 0, 0, 0)
		end

end
