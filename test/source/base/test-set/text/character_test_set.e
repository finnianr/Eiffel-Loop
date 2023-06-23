note
	description: "Character routines test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-06-23 9:04:16 GMT (Friday 23rd June 2023)"
	revision: "1"

class
	CHARACTER_TEST_SET

inherit
	EL_EQA_TEST_SET

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["character_8_as_lower", agent test_character_8_as_lower]
			>>)
		end

feature -- Tests

	test_character_8_as_lower
		-- TEXT_DATA_TEST_SET.test_character_8_as_lower
		local
			i: INTEGER; c: CHARACTER; c32: EL_CHARACTER_32_ROUTINES
			uc: CHARACTER_32
		do
			from i := 1 until i > 0xFF loop
				c := i.to_character_8
				if c.is_alpha and c.is_upper then
					uc := c
					assert ("as_lower OK", c.as_lower = c32.to_lower (uc).to_character_8)
				end
				i := i + 1
			end
		end

	test_character_32_status_queries
		do
--			Bug in finalized exe for compiler version 16.05
--			assert ("not is_space", not ({CHARACTER_32}'€').is_space)
--			assert ("not is_digit ", not ({CHARACTER_32}'€').is_digit)

			assert ("not is_alpha", not ({CHARACTER_32}'€').is_alpha)
			assert ("not is_punctuation", not ({CHARACTER_32}'€').is_punctuation)
			assert ("not is_control", not ({CHARACTER_32}'€').is_control)
		end

	test_is_substitute_white
		-- TEXT_DATA_TEST_SET.test_is_substitute_white
		local
			c: CHARACTER
		do
			c := (26).to_character_8
			assert ("no space", not c.is_space)
		end

end