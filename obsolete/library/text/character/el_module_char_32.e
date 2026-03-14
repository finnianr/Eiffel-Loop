note
	description: "Shared access to instance of [$source EL_CHARACTER_8_ROUTINES]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-06 14:01:41 GMT (Thursday 6th February 2020)"
	revision: "9"

deferred class
	EL_MODULE_CHAR_32

inherit
	EL_MODULE

feature {NONE} -- Constants

	Char_32: EL_CHARACTER_32_ROUTINES
			--
		once
--			create Result.make
		end
end
