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
	date: "2021-03-20 17:14:19 GMT (Saturday 20th March 2021)"
	revision: "59"

class
	APPLICATION_ROOT

inherit
	EL_MULTI_APPLICATION_ROOT [BUILD_INFO,
		HORSE_RACE_APP,
		WORK_DISTRIBUTER_TEST_APP
	]

create
	make

end