note
	description: "Temporary once buffer of type [$source STRING_32]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-12-26 15:38:07 GMT (Sunday 26th December 2021)"
	revision: "7"

expanded class
	EL_STRING_32_BUFFER_ROUTINES

inherit
	EL_EXPANDED_ROUTINES

	EL_STRING_32_BUFFER_I

feature {NONE} -- Constants

	Buffer: STRING_32
		once
			create Result.make_empty
		end
end