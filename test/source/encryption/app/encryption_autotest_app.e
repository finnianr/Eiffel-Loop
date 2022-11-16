note
	description: "Finalized executable tests for library [./library/encryption.html encryption.ecf]"
	notes: "[
		Command option: `-encryption_autotest'

		**Test Sets**

			[$source DIGEST_ROUTINES_TEST_SET]
			[$source ENCRYPTION_TEST_SET]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:03 GMT (Tuesday 15th November 2022)"
	revision: "5"

class
	ENCRYPTION_AUTOTEST_APP

inherit
	EL_AUTOTEST_APPLICATION [DIGEST_ROUTINES_TEST_SET, ENCRYPTION_TEST_SET]

create
	make

end