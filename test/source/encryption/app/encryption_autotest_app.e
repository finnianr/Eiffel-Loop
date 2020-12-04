note
	description: "Finalized executable tests for library [./library/encryption.html encryption.ecf]"
	notes: "[
		Command option: `-encryption_autotest'

		**Test Sets**

			[$source DIGEST_ROUTINES_TEST_SET]
			[$source ENCRYPTION_TEST_SET]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-12-03 10:40:05 GMT (Thursday 3rd December 2020)"
	revision: "3"

class
	ENCRYPTION_AUTOTEST_APP

inherit
	EL_AUTOTEST_SUB_APPLICATION [DIGEST_ROUTINES_TEST_SET, ENCRYPTION_TEST_SET]

create
	make

end