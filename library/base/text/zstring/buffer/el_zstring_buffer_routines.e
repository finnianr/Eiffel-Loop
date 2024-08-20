note
	description: "Routines to acccess shared buffer of type ${EL_ZSTRING}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-20 11:27:31 GMT (Tuesday 20th August 2024)"
	revision: "10"

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