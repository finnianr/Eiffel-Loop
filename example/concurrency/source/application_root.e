note
	description: "[
		Root for two concurrency demonstrations:
		
		1. [$source HORSE_RACE_APP]
		2. [$source WORK_DISTRIBUTER_TEST_APP]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-09 0:03:28 GMT (Wednesday 9th February 2022)"
	revision: "60"

class
	APPLICATION_ROOT

inherit
	EL_MULTI_APPLICATION_ROOT [BUILD_INFO,
		HORSE_RACE_APP,
		SINE_WAVE_INTEGRATION_APP
	]

create
	make

end