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
	date: "2020-09-15 10:23:38 GMT (Tuesday 15th September 2020)"
	revision: "64"

class
	TAGLIB_AUTOTEST_APP

inherit
	EL_REGRESSION_AUTOTEST_SUB_APPLICATION [TUPLE [TAGLIB_TEST_SET]]

create
	make

end