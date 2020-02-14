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
	date: "2020-02-14 13:53:32 GMT (Friday 14th February 2020)"
	revision: "1"

class
	ENCRYPTION_AUTOTEST_APP

inherit
	EL_AUTOTEST_SUB_APPLICATION

create
	make

feature {NONE} -- Implementation

	test_type: TUPLE [ENCRYPTION_TEST_SET]
		do
			create Result
		end

	test_types_all: TUPLE [DIGEST_ROUTINES_TEST_SET, ENCRYPTION_TEST_SET]
		do
			create Result
		end

end
