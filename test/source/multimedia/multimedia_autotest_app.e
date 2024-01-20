note
	description: "Finalized executable tests for library [./library/multi-media.html multi-media.ecf]"
	notes: "[
		Command option: `-multimedia_autotest'
		
		**Test Sets**
		
			${AUDIO_COMMAND_TEST_SET}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:27 GMT (Saturday 20th January 2024)"
	revision: "69"

class
	MULTIMEDIA_AUTOTEST_APP

inherit
	EL_AUTOTEST_APPLICATION [AUDIO_COMMAND_TEST_SET]

create
	make

end