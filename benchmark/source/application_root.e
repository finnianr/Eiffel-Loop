note
	description: "Application root"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-25 10:21:48 GMT (Friday 25th April 2025)"
	revision: "59"

class
	APPLICATION_ROOT

inherit
	EL_MULTI_APPLICATION_ROOT [BUILD_INFO,
		BENCHMARK_APP,
		MEMORY_BENCHMARK_APP,
		PRIMES_BENCHMARK_APP,
		STRING_BENCHMARK_APP,
		ZSTRING_BENCHMARK_APP
	]

create
	make

feature {NONE} -- Constants

	Compile: TUPLE [EL_MUTEX_VALUE [BOOLEAN]]
		once
			create Result
		end

end