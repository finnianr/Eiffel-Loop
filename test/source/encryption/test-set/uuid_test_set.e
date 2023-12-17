note
	description: "Test [$source EL_UUID]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-17 10:36:50 GMT (Sunday 17th December 2023)"
	revision: "9"

class
	UUID_TEST_SET

inherit
	EL_EQA_TEST_SET

	EL_MODULE_DIGEST

	EL_UUID_FACTORY
		export
			{NONE} all
		undefine
			default_create
		end

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["to_string",		  agent test_to_string],
				["to_7_characters", agent test_to_7_characters]
			>>)
		end

feature -- Tests

	test_to_7_characters
		-- UUID_TEST_SET.test_to_7_characters
		note
			testing: "[
				covers/{EL_UUID}.to_7_character_code,
				covers/{EL_BASE_32_CONVERTER}.to_natural_64
			]"
		local
			base_32: EL_BASE_32_CONVERTER; uuid: EL_UUID
			data_1_to_35: NATURAL_64; code, previous_code: STRING
		do
			create previous_code.make_empty
			across 1 |..| 50 as n loop
				uuid := new_uuid
				code := uuid.to_7_character_code
				assert ("is a new code", code /~ previous_code)
				data_1_to_35 := uuid.data_5 & uuid.Thirty_five_bit_mask
				assert ("same data", base_32.to_natural_64 (code) = data_1_to_35)
				previous_code := code
			end
		end

	test_to_string
		note
			testing: "[
				covers/{EL_UUID}.to_string, covers/{EL_UUID}.to_delimited
			]"
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