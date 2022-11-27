note
	description: "Routines to acccess shared buffer of type [$source EL_ZSTRING]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "8"

expanded class
	EL_ZSTRING_BUFFER_ROUTINES

inherit
	EL_EXPANDED_ROUTINES

	EL_ZSTRING_BUFFER_I

feature {NONE} -- Constants

	Buffer: ZSTRING
		once
			create Result.make_empty
		end
end