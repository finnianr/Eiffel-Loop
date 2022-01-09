note
	description: "Finalized executable tests for library [./library/multi-media.html multi-media.ecf]"
	notes: "[
		Command option: `-multimedia_autotest'
		
		**Test Sets**
		
			[$source AUDIO_COMMAND_TEST_SET]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-09 10:40:54 GMT (Sunday 9th January 2022)"
	revision: "66"

class
	MULTIMEDIA_AUTOTEST_APP

inherit
	EL_AUTOTEST_SUB_APPLICATION [AUDIO_COMMAND_TEST_SET]

create
	make

end