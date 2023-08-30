note
	description: "Benchmark using pure Latin encodable string data"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-30 17:16:03 GMT (Wednesday 30th August 2023)"
	revision: "20"

class
	STRING_32_BENCHMARK

inherit
	STRING_BENCHMARK

create
	make

feature {NONE} -- Factory

	new_test_strings (routine_name, a_format: STRING): TEST_STRING_32
		do
			create Result.make (routine_name, a_format, escape_character)
		end

end