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
	date: "2021-03-08 12:02:54 GMT (Monday 8th March 2021)"
	revision: "58"

class
	APPLICATION_ROOT

inherit
	EL_MULTI_APPLICATION_ROOT [BUILD_INFO, HORSE_RACE_APP, WORK_DISTRIBUTER_TEST_APP]

create
	make

end