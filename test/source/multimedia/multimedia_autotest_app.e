note
	description: "Finalized executable tests for library [./library/multi-media.html multi-media.ecf]"
	notes: "[
		Command option: `-os_command_autotest'
		
		**Test Sets**
		
			[$source AUDIO_COMMAND_TEST_SET]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-04-05 10:34:38 GMT (Sunday 5th April 2020)"
	revision: "63"

class
	MULTIMEDIA_AUTOTEST_APP

inherit
	EL_AUTOTEST_SUB_APPLICATION

create
	make

feature {NONE} -- Implementation

	test_type: TUPLE [AUDIO_COMMAND_TEST_SET]
		do
			create Result
		end

	test_types_all: TUPLE [AUDIO_COMMAND_TEST_SET]
		do
			create Result
		end

end
