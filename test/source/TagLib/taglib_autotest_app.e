note
	description: "Finalized executable tests for library [./library/TagLib.html TagLib.ecf]"
	notes: "[
		Command option: `-taglib_autotest'
		
		**Test Sets**
		
			${TAGLIB_TEST_SET}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:27 GMT (Saturday 20th January 2024)"
	revision: "70"

class
	TAGLIB_AUTOTEST_APP

inherit
	EL_CRC_32_AUTOTEST_APPLICATION [TAGLIB_TEST_SET]

create
	make
end