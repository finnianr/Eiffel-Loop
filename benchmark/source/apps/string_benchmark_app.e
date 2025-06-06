note
	description: "[
		Benchmark shell menu ${STRING_BENCHMARK_SHELL} for string related performance tests
	]"
	notes: "[
		Usage:
			el_benchmark -string_benchmark
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-25 10:53:52 GMT (Friday 25th April 2025)"
	revision: "29"

class
	STRING_BENCHMARK_APP

inherit
	BENCHMARK_SHELL_APPLICATION [STRING_BENCHMARK_SHELL]

create
	make
end