note
	description: "Windows implementation of [$source EL_USEABLE_SCREEN_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "6"

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