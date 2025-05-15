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
	date: "2025-05-15 8:48:47 GMT (Thursday 15th May 2025)"
	revision: "11"

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
		EL_ENCRYPTABLE_NOTIFYING_PLAIN_TEXT_FILE,
		EL_CRYPTO_COMMAND_SHELL,
		EL_REFLECTIVE_CHAIN_CHECKSUMS [EL_REFLECTIVELY_SETTABLE]
	]
		do
			create Result
		end

end