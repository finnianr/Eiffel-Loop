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
	date: "2020-02-14 13:58:45 GMT (Friday 14th February 2020)"
	revision: "62"

class
	TAGLIB_AUTOTEST_APP

inherit
	EL_AUTOTEST_SUB_APPLICATION

create
	make

feature {NONE} -- Implementation

	test_type, test_types_all: TUPLE [TAGLIB_TEST_SET]
		do
			create Result
		end

end
