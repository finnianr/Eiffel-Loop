note
	description: "Temporary once buffer of type [$source STRING_32]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-05-16 18:50:02 GMT (Sunday 16th May 2021)"
	revision: "6"

expanded class
	EL_STRING_32_BUFFER_ROUTINES

inherit
	EL_STRING_32_BUFFER_I

feature {NONE} -- Constants

	Buffer: STRING_32
		once
			create Result.make_empty
		end
end