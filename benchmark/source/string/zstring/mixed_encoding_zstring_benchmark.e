note
	description: "Benchmark using a mix of Latin and Unicode encoded data"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-23 19:15:56 GMT (Sunday 23rd October 2022)"
	revision: "4"

class
	MIXED_ENCODING_ZSTRING_BENCHMARK

inherit
	ZSTRING_BENCHMARK
		undefine
			do_performance_tests, do_memory_tests
		end

	MIXED_ENCODING_STRING_BENCHMARK [ZSTRING]
		undefine
			make
		end

create
	make
end