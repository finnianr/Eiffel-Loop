note
	description: "Test string constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-29 13:51:46 GMT (Sunday   29th   September   2019)"
	revision: "6"

class
	TEST_STRING_CONSTANTS

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

	Text_lines: LIST [STRING_32]
		once
			Result := Text_russian_and_english.split ('%N')
		end

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

	Text_words: ARRAYED_LIST [STRING_32]
		once
			create Result.make (50)
			across Text_lines as line loop
				across line.item.split (' ') as word loop
					Result.extend (word.item)
				end
			end
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

	Text_russian_and_english: STRING_32 = "[
		и рыбку съесть, и в воду не лезть
		Wanting to eat a fish without first catching it from the waters
		Latin-1: ¼ + ¾ = 1
		Latin-15: Slavoj Žižek
		Le Quattro Stagioni ´L´Estate`- I. Allegro non molto
	]"

	Substituted_words: ARRAY [TUPLE]
		once
			Result := <<
				[{STRING_32} "и", {STRING_32} "съесть",{STRING_32} "лезть"],
				["eat", "fish", "catching"],
				[1, 1],
				[15],
				['´']
			>>
		ensure
			same_number: Result.count = Text_russian_and_english.occurrences ('%N') + 1
		end

	Lower_case_characters: STRING_32 = "™ÿaàöžšœ" --

	Lower_case_mu: STRING_32 = "µ symbol"

	Upper_case_characters: STRING_32 = "™ŸAÀÖŽŠŒ"

	Upper_case_mu: STRING_32 = "Μ SYMBOL"

end
