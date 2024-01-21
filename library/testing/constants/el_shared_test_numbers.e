note
	description: "Shared instance of ${EL_TEST_NUMBERS}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:20:36 GMT (Saturday 20th January 2024)"
	revision: "3"

deferred class
	EL_SHARED_TEST_NUMBERS

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Number: EL_TEST_NUMBERS
		once
			create Result
		end
end