note
	description: "Finalized executable tests for library [./library/image-utils.html image-utils.ecf]"
	notes: "[
		Command option: `-image_utils_autotest'
		
		**Test Sets**
		
			[$source IMAGE_UTILS_TEST_SET]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-19 14:30:23 GMT (Wednesday 19th January 2022)"
	revision: "10"

class
	IMAGE_UTILS_AUTOTEST_APP

inherit
	EL_CRC_32_AUTOTEST_SUB_APPLICATION [IMAGE_UTILS_TEST_SET]

create
	make

end