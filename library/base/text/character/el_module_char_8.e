note
	description: "Shared access to instance of [$source EL_CHARACTER_8_ROUTINES]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-06 14:01:50 GMT (Thursday 6th February 2020)"
	revision: "9"

deferred class
	EL_MODULE_CHAR_8

inherit
	EL_MODULE

feature {NONE} -- Constants

	Char_8: EL_CHARACTER_8_ROUTINES
			--
		once
			create Result
		end
end
