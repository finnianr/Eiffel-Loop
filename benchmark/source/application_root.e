note
	description: "Application root"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-29 13:33:41 GMT (Monday 29th March 2021)"
	revision: "55"

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

	Compile: TUPLE
		once
			create Result
		end

end