note
	description: "[
		Expanded implementation of ${EL_STRING_8_BUFFER_I} with shared buffer of type ${STRING_8}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:24 GMT (Saturday 20th January 2024)"
	revision: "8"

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