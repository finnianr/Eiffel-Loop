note
	description: "[
		Finalized executable tests for library [./library/amazon-instant-access.html amazon-instant-access.ecf]
	]"
	notes: "[
		Command option: `-amazon_instant_access_autotest'
		
		**Test Sets**
		
			[$source AMAZON_INSTANT_ACCESS_TEST_SET]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-01 11:57:51 GMT (Monday 1st January 2024)"
	revision: "70"

class
	AMAZON_INSTANT_ACCESS_AUTOTEST_APP

inherit
	EL_AUTOTEST_APPLICATION [AMAZON_INSTANT_ACCESS_TEST_SET]

create
	make

end