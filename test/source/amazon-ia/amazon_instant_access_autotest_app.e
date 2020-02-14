note
	description: "Finalized executable tests for library [./library/amazon-instant-access.html amazon-instant-access.ecf]"
	notes: "[
		Command option: `-amazon_instant_access_autotest'
		
		**Test Sets**
		
			[$source AMAZON_INSTANT_ACCESS_TEST_SET]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-14 13:49:45 GMT (Friday 14th February 2020)"
	revision: "65"

class
	AMAZON_INSTANT_ACCESS_AUTOTEST_APP

inherit
	EL_AUTOTEST_SUB_APPLICATION

create
	make

feature {NONE} -- Implementation

	test_type, test_types_all: TUPLE [AMAZON_INSTANT_ACCESS_TEST_SET]
		do
			create Result
		end

end
