note
	description: "Shared instance of ${EL_TEST_NUMBERS}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "2"

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