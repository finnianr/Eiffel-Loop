note
	description: "[
		Finalized executable tests for library [./library/public-key-encryption.html public-key-encryption.ecf]
	]"
	notes: "[
		Command option: `-public_key_encryption_autotest'

		**Test Sets**

			${RSA_PUBLIC_KEY_ENCRYPTION_TEST_SET}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-23 6:08:15 GMT (Monday 23rd September 2024)"
	revision: "5"

class
	PUBLIC_KEY_ENCRYPTION_AUTOTEST_APP

inherit
	EL_AUTOTEST_APPLICATION [RSA_PUBLIC_KEY_ENCRYPTION_TEST_SET]

create
	make

feature {NONE} -- Access

	compile: TUPLE [EL_SIGNED_EIFFEL_CLASS]
		do
			create Result
		end

end