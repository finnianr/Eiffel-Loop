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
	date: "2020-10-18 13:00:03 GMT (Sunday 18th October 2020)"
	revision: "8"

class
	IMAGE_UTILS_AUTOTEST_APP

inherit
	EL_REGRESSION_AUTOTEST_SUB_APPLICATION [IMAGE_UTILS_TEST_SET]

create
	make

end