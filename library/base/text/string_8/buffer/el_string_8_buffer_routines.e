note
	description: "[
		Expanded implementation of ${EL_STRING_8_BUFFER_I} with shared buffer of type ${STRING_8}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-20 12:53:10 GMT (Tuesday 20th August 2024)"
	revision: "9"

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