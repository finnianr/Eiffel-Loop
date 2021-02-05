note
	description: "Application root"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-02-05 13:08:22 GMT (Friday 5th February 2021)"
	revision: "54"

class
	APPLICATION_ROOT

inherit
	EL_MULTI_APPLICATION_ROOT [BUILD_INFO,
		BENCHMARK_APP,
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