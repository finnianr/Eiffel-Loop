note
	description: "Finalized executable tests for library [./library/encryption.html encryption.ecf]"
	notes: "[
		Command option: `-encryption_autotest'

		**Test Sets**

			${DIGEST_ROUTINES_TEST_SET}
			${ENCRYPTION_TEST_SET}
			${UUID_TEST_SET}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:27 GMT (Saturday 20th January 2024)"
	revision: "10"

class
	ENCRYPTION_AUTOTEST_APP

inherit
	EL_AUTOTEST_APPLICATION [
		DIGEST_ROUTINES_TEST_SET,
		ENCRYPTION_TEST_SET,
		UUID_TEST_SET
	]

create
	make

feature {NONE} -- Implementation

	compile: TUPLE [
		EL_ENCRYPTED_PLAIN_TEXT_LINE_SOURCE,
		EL_ENCRYPTABLE_NOTIFYING_PLAIN_TEXT_FILE
	]
		do
			create Result
		end

end