note
	description: "[
		Benchmark shell menu ${MEMORY_BENCHMARK_SHELL} for object memory footprint related tests
	]"
	notes: "[
		Usage:
			el_benchmark -memory_benchmark
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-25 10:53:43 GMT (Friday 25th April 2025)"
	revision: "1"

class
	MEMORY_BENCHMARK_APP

inherit
	BENCHMARK_SHELL_APPLICATION [MEMORY_BENCHMARK_SHELL]

create
	make

end