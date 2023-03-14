note
	description: "Application root"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-13 14:25:26 GMT (Monday 13th March 2023)"
	revision: "58"

class
	APPLICATION_ROOT

inherit
	EL_MULTI_APPLICATION_ROOT [BUILD_INFO,
		BENCHMARK_APP,
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