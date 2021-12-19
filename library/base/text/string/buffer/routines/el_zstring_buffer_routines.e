note
	description: "Routines to acccess shared buffer of type [$source EL_ZSTRING]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-12-07 18:11:08 GMT (Tuesday 7th December 2021)"
	revision: "6"

expanded class
	EL_ZSTRING_BUFFER_ROUTINES

inherit
	EL_ZSTRING_BUFFER_I

feature {NONE} -- Constants

	Buffer: ZSTRING
		once
			create Result.make_empty
		end
end