note
	description: "Benchmark using pure Latin encodable string data"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:03 GMT (Tuesday 15th November 2022)"
	revision: "18"

class
	STRING_32_BENCHMARK

inherit
	STRING_BENCHMARK

create
	make

feature {NONE} -- Factory

	new_test (routines, a_format: STRING): TEST_STRING_32
		do
			create Result.make (routines, a_format, escape_character)
		end

end