note
	description: "Benchmark using a mix of Latin and Unicode encoded data"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:03 GMT (Tuesday 15th November 2022)"
	revision: "6"

class
	MIXED_ENCODING_STRING_32_BENCHMARK

inherit
	STRING_32_BENCHMARK
		undefine
			do_performance_tests, do_memory_tests
		end

	MIXED_ENCODING_STRING_BENCHMARK
		undefine
			make
		end

create
	make

end