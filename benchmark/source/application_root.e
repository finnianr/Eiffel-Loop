note
	description: "Application root"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:03 GMT (Tuesday 15th November 2022)"
	revision: "57"

class
	APPLICATION_ROOT

inherit
	EL_MULTI_APPLICATION_ROOT [BUILD_INFO,
		BENCHMARK_APP,
		PRIMES_BENCHMARK_APP,
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