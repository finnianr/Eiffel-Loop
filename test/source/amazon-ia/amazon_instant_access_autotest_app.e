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
	date: "2020-11-26 15:23:10 GMT (Thursday 26th November 2020)"
	revision: "67"

class
	AMAZON_INSTANT_ACCESS_AUTOTEST_APP

inherit
	EL_AUTOTEST_SUB_APPLICATION [AMAZON_INSTANT_ACCESS_TEST_SET]

create
	make

end