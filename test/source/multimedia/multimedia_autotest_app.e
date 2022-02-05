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
	date: "2022-02-05 14:49:49 GMT (Saturday 5th February 2022)"
	revision: "67"

class
	MULTIMEDIA_AUTOTEST_APP

inherit
	EL_AUTOTEST_APPLICATION [AUDIO_COMMAND_TEST_SET]

create
	make

end