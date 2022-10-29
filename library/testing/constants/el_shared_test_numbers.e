note
	description: "Shared instance of [$source EL_TEST_NUMBERS]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-29 8:58:27 GMT (Saturday 29th October 2022)"
	revision: "1"

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