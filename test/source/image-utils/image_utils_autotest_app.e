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
	date: "2020-09-15 11:04:20 GMT (Tuesday 15th September 2020)"
	revision: "7"

class
	IMAGE_UTILS_AUTOTEST_APP

inherit
	EL_REGRESSION_AUTOTEST_SUB_APPLICATION [
		TUPLE [IMAGE_UTILS_TEST_SET]
	]

create
	make

end