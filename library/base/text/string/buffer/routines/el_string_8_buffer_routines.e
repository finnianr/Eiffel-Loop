note
	description: "[
		Expanded implementation of [$source EL_STRING_8_BUFFER_I] with shared buffer of type [$source STRING_8]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-12-26 15:38:13 GMT (Sunday 26th December 2021)"
	revision: "6"

expanded class
	EL_STRING_8_BUFFER_ROUTINES

inherit
	EL_EXPANDED_ROUTINES

	EL_STRING_8_BUFFER_I

feature {NONE} -- Constants

	Buffer: STRING
		once
			create Result.make_empty
		end
end