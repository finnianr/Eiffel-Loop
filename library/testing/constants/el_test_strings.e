note
	description: "Test string constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-12-19 16:23:12 GMT (Sunday 19th December 2021)"
	revision: "14"

deferred class
	EL_TEST_STRINGS

inherit
	EL_ANY_SHARED

feature {NONE} -- Implementation

	text_lines: EL_STRING_32_LIST
		do
			create Result.make_with_lines (Text_russian_and_english)
		end

	text_russian: STRING_32
		do
			Result := Text_russian_and_english.substring (1, Text_russian_and_english.index_of ('%N', 1) - 1)
		end

	text_words: EL_STRING_32_LIST
		do
			create Result.make (50)
			across text_lines as line loop
				across line.item.split (' ') as word loop
					Result.extend (word.item)
				end
			end
		end

feature {NONE} -- Characters

	Ogham_space_mark: CHARACTER_32
		once
			Result := (0x1680).to_character_32
		end

	Tab_character: CHARACTER_32
		once
			Result := '%T'
		end

feature {NONE} -- Constants

	Escaped_substitution_marker: STRING = "%%%S"

	Text_characters: ARRAY [CHARACTER_32]
		local
			table: HASH_TABLE [CHARACTER_32, CHARACTER_32]
		once
			create table.make_equal (50)
			across Text_russian_and_english as c loop
				table.put (c.item, c.item)
			end
			Result := table.current_keys
		end

	Text_word_intervals: ARRAYED_LIST [INTEGER_INTERVAL]
		local
			i, j: INTEGER
		once
			create Result.make (20)
			from i := 0 until j > 0 and i = 0 loop
				j := Text_russian_and_english.index_of (' ', i + 1)
				if j = 0 then
					j := Text_russian_and_english.count + 1
				end
				Result.extend ((i + 1) |..| (j - 1))
				i := Text_russian_and_english.index_of (' ', j - 1)
			end
		end

feature {NONE} -- String_32 contants

	Lower_case_characters: STRING_32 = "™ÿaàöžšœ" --

	Lower_case_mu: STRING_32 = "µ symbol"

	Text_russian_and_english: STRING_32 = "[
		и рыбку съесть, и в воду не лезть
		Wanting to eat a fish without first catching it from the waters
		Latin-1: ¼ + ¾ = 1
		Latin-15: Slavoj Žižek
		Le Quattro Stagioni ´L´Estate`- I. Allegro non molto
		Price € 100
	]"

	Upper_case_characters: STRING_32 = "™ŸAÀÖŽŠŒ"

	Upper_case_mu: STRING_32 = "Μ SYMBOL"

end