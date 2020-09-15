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
	date: "2020-09-15 10:22:12 GMT (Tuesday 15th September 2020)"
	revision: "64"

class
	MULTIMEDIA_AUTOTEST_APP

inherit
	EL_AUTOTEST_SUB_APPLICATION [TUPLE [AUDIO_COMMAND_TEST_SET]]

create
	make

end