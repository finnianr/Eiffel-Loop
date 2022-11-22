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
	date: "2022-11-22 10:19:55 GMT (Tuesday 22nd November 2022)"
	revision: "6"

class
	ENCRYPTION_AUTOTEST_APP

inherit
	EL_AUTOTEST_APPLICATION [DIGEST_ROUTINES_TEST_SET, ENCRYPTION_TEST_SET]

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