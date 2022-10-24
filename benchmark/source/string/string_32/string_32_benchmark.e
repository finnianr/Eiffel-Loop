note
	description: "Benchmark using pure Latin encodable string data"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-23 19:42:02 GMT (Sunday 23rd October 2022)"
	revision: "16"

class
	STRING_32_BENCHMARK

inherit
	STRING_BENCHMARK [STRING_32]

create
	make

feature {NONE} -- Factory

	new_test (routines, a_format: STRING): TEST_STRING_32
		do
			create Result.make (routines, a_format, escape_character)
		end

end