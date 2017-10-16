note
	description: "Benchmark using a mix of Latin and Unicode encoded data"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:21:02 GMT (Thursday 12th October 2017)"
	revision: "2"

class
	MIXED_ENCODING_ZSTRING_BENCHMARK

inherit
	ZSTRING_BENCHMARK
		undefine
			do_performance_tests, do_memory_tests
		end

	MIXED_ENCODING_STRING_BENCHMARK
		undefine
			make, set_escape_character
		end

create
	make
end