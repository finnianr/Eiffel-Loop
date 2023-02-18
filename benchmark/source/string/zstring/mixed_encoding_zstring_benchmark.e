note
	description: "Benchmark using a mix of Latin and Unicode encoded data"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-02-18 15:52:32 GMT (Saturday 18th February 2023)"
	revision: "7"

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