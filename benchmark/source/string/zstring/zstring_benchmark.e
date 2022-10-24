note
	description: "Benchmark using pure Latin encodable string data"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-24 2:45:36 GMT (Monday 24th October 2022)"
	revision: "14"

class
	ZSTRING_BENCHMARK

inherit
	STRING_BENCHMARK [ZSTRING]

create
	make

feature {NONE} -- Factory

	new_test (routines, a_format: STRING): TEST_ZSTRING
		do
			create Result.make (routines, a_format, escape_character)
		end

feature {NONE} -- Constants

	Empty_unencoded: SPECIAL [NATURAL]
		once
			create Result.make_empty (0)
		end

	Xml_escaper: XML_ZSTRING_ESCAPER
		once
			create Result.make_128_plus
		end

end