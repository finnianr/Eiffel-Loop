note
	description: "Finalized executable tasks executed by [$source RBOX_MUSIC_MANAGER] command"
	notes: "[
		Command option: `-task_autotest'
		
		**Test Sets**
		
			[$source COLLATE_SONGS_TASK_TEST_SET]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-04-13 16:56:38 GMT (Monday 13th April 2020)"
	revision: "1"

class
	TASK_AUTOTEST_APP

inherit
	EL_REGRESSION_AUTOTEST_SUB_APPLICATION

create
	make

feature {NONE} -- Implementation

	test_type: TUPLE [COLLATE_SONGS_TASK_TEST_SET]
		do
			create Result
		end

	test_types_all: TUPLE [COLLATE_SONGS_TASK_TEST_SET]
		do
			create Result
		end
end
