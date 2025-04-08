note
	description: "Base class for all {ZSTRING} test sets"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-08 12:55:37 GMT (Tuesday 8th April 2025)"
	revision: "5"

deferred class
	ZSTRING_EQA_TEST_SET

inherit
	EL_EQA_TEST_SET

	EL_SHARED_TEST_TEXT

	EL_STRING_GENERAL_ROUTINES_I

	EL_TEST_TEXT_CONSTANTS; EL_ZSTRING_CONSTANTS

feature {NONE} -- Implementation

	padded_32 (c: CHARACTER_32): IMMUTABLE_STRING_32
		local
			str: STRING_32; outer: IMMUTABLE_STRING_32
		do
			str := "abc"
			across 1 |..| 2 as n loop
				str.append_character (c)
				str.prepend_character (c)
			end
			outer := str
			Result := outer.shared_substring (2, 6)
		end

	padded_8 (c: CHARACTER_8): IMMUTABLE_STRING_8
		local
			str: STRING_8; outer: IMMUTABLE_STRING_8
		do
			str := "abc"
			across 1 |..| 2 as n loop
				str.append_character (c)
				str.prepend_character (c)
			end
			outer := str
			Result := outer.shared_substring (2, 6)
		end

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