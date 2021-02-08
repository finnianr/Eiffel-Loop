note
	description: "[
		Finalized executable tests for library [./library/public-key-encryption.html public-key-encryption.ecf]
	]"
	notes: "[
		Command option: `-public_key_encryption_autotest'

		**Test Sets**

			[$source RSA_PUBLIC_KEY_ENCRYPTION_TEST_SET]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-02-08 19:01:41 GMT (Monday 8th February 2021)"
	revision: "1"

class
	PUBLIC_KEY_ENCRYPTION_AUTOTEST_APP

inherit
	EL_AUTOTEST_SUB_APPLICATION [RSA_PUBLIC_KEY_ENCRYPTION_TEST_SET]

create
	make
end