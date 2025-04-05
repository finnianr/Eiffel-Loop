note
	description: "Base class for all {ZSTRING} test sets"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-04 9:11:53 GMT (Friday 4th April 2025)"
	revision: "3"

deferred class
	ZSTRING_EQA_TEST_SET

inherit
	EL_EQA_TEST_SET

	EL_SHARED_TEST_TEXT

	EL_STRING_HANDLER

	EL_ZSTRING_CONSTANTS

feature {NONE} -- Factory

	new_tests_with_immutable: ARRAYED_LIST [STRING_TEST]
		do
			create Result.make (2)
			Result.extend (create {STRING_TEST}.make_empty (Current))
			Result.extend (create {IMMUTABLE_STRING_TEST}.make_empty (Current))
		end

	new_test (str_32: STRING_32): STRING_TEST
		do
			create Result.make (Current, str_32)
		end

	new_immutable_test (str_32: STRING_32): IMMUTABLE_STRING_TEST
		do
			create Result.make (Current, str_32)
		end

	new_caseless_test (str_32: STRING_32): CASELESS_STRING_TEST
		do
			create Result.make (Current, str_32)
		end

end