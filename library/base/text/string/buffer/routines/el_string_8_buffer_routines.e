note
	description: "[
		Expanded implementation of [$source EL_STRING_8_BUFFER_I] with shared buffer of type [$source STRING]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-04-30 12:11:44 GMT (Friday 30th April 2021)"
	revision: "4"

expanded class
	EL_STRING_8_BUFFER_ROUTINES

inherit
	EL_STRING_8_BUFFER_I

feature {NONE} -- Constants

	Buffer: STRING
		once
			create Result.make_empty
		end
end