note
	description: "Benchmark using a mix of Latin and Unicode encoded data"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-25 8:48:28 GMT (Tuesday 25th October 2022)"
	revision: "5"

class
	MIXED_ENCODING_ZSTRING_BENCHMARK

inherit
	ZSTRING_BENCHMARK
		undefine
			do_performance_tests, do_memory_tests
		redefine
			Title_template
		end

	MIXED_ENCODING_STRING_BENCHMARK
		undefine
			make
		end

create
	make

feature {NONE} -- Constants

	Title_template: ZSTRING
		once
			Result := "Mixed Latin-%S and Unicode Encoding"
		end
end