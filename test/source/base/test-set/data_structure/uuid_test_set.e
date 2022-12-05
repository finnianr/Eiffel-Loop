note
	description: "Test [$source EL_UUID]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-05 11:06:57 GMT (Monday 5th December 2022)"
	revision: "5"

class
	UUID_TEST_SET

inherit
	EL_EQA_TEST_SET

	EL_MODULE_DIGEST

feature -- Basic operations

	do_all (eval: EL_TEST_SET_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("to_string", agent test_to_string)
		end

feature -- Tests

	test_to_string
		note
			testing: "covers/{EL_UUID}.to_string", "covers/{EL_UUID}.to_delimited"
		local
			uuid: EL_UUID; same_string, s1, s2: STRING
			s: EL_STRING_8_ROUTINES
		do
			same_string := "same string"
			uuid := Digest.md5 (same_string).to_uuid
			s1 := uuid.to_string; s2 := uuid.out
			assert (same_string, s1 ~ s2)

			s.replace_character (s2, '-', ':')
			assert (same_string, uuid.to_delimited (':') ~ s2)
		end

end