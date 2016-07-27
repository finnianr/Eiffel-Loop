note
	description: "Benchmark using a mix of Latin and Unicode encoded data"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-03-17 12:56:19 GMT (Thursday 17th March 2016)"
	revision: "7"

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