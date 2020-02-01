note
	description: "Shared access to [$source EL_CHARACTER_8_ROUTINES]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-01 16:58:21 GMT (Saturday 1st February 2020)"
	revision: "8"

deferred class
	EL_MODULE_CHAR_32

inherit
	EL_MODULE

feature {NONE} -- Constants

	Char_32: EL_CHARACTER_32_ROUTINES
			--
		once
			create Result.make
		end
end
