note
	description: "Benchmark using pure Latin encodable string data"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-02-18 16:03:23 GMT (Saturday 18th February 2023)"
	revision: "19"

class
	STRING_32_BENCHMARK

inherit
	STRING_BENCHMARK

create
	make

feature {NONE} -- Factory

	new_test_strings (routines, a_format: STRING): TEST_STRING_32
		do
			create Result.make (routines, a_format, escape_character)
		end

end