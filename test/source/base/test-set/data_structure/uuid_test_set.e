note
	description: "Test [$source EL_UUID]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-03-30 10:36:57 GMT (Monday 30th March 2020)"
	revision: "1"

class
	UUID_TEST_SET

inherit
	EL_EQA_TEST_SET

	EL_MODULE_DIGEST

	EL_MODULE_STRING_8

feature -- Basic operations

	do_all (eval: EL_EQA_TEST_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("to_string", agent test_to_string)
		end

feature -- Tests

	test_to_string
		note
			testing: "covers/{EL_UUID}.to_string", "covers/{EL_UUID}.to_delimited"
		local
			uuid: EL_UUID
			same_string, s1, s2: STRING
		do
			same_string := "same string"
			uuid := Digest.md5 (same_string)
			s1 := uuid.to_string; s2 := uuid.out
			assert (same_string, s1 ~ s2)

			String_8.replace_character (s2, '-', ':')
			assert (same_string, uuid.to_delimited (':') ~ s2)
		end

end
