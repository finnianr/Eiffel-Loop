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
	date: "2020-10-18 13:00:21 GMT (Sunday 18th October 2020)"
	revision: "65"

class
	TAGLIB_AUTOTEST_APP

inherit
	EL_REGRESSION_AUTOTEST_SUB_APPLICATION [TAGLIB_TEST_SET]

create
	make

end