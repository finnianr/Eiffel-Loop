note
	description: "Finalized executable tests for library [./library/TagLib.html TagLib.ecf]"
	notes: "[
		Command option: `-taglib_autotest'
		
		**Test Sets**
		
			[$source TAGLIB_TEST_SET]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-05 14:52:16 GMT (Saturday 5th February 2022)"
	revision: "68"

class
	TAGLIB_AUTOTEST_APP

inherit
	EL_CRC_32_AUTOTEST_APPLICATION [TAGLIB_TEST_SET]

create
	make
end