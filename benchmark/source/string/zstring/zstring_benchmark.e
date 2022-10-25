note
	description: "Benchmark using pure Latin encodable string data"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-25 8:48:33 GMT (Tuesday 25th October 2022)"
	revision: "15"

class
	ZSTRING_BENCHMARK

inherit
	STRING_BENCHMARK

	EL_SHARED_ZSTRING_CODEC

create
	make

feature -- Access

	title: ZSTRING
		do
			Result := Title_template #$ [Codec.id]
		end

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

	Title_template: ZSTRING
		once
			Result := "Pure Latin-%S Encoding"
		end

end