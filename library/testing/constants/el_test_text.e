note
	description: "Test string routines and constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-06 9:10:26 GMT (Thursday 6th March 2025)"
	revision: "40"

class
	EL_TEST_TEXT

inherit
	ANY

	EL_MODULE_TUPLE

	EL_SHARED_TEST_NUMBERS

	EL_ENCODING_TYPE

feature -- Access

	all_encodings: ARRAYED_LIST [NATURAL]
		local
			base: EL_ENCODING; encoding: NATURAL
		do
			create Result.make (15 + 9)
			create base.make_default
			across 1 |..| 15 as range loop
				encoding := Latin | range.item.to_natural_32
				if base.is_valid (encoding) then
					Result.extend (encoding)
				end
			end
			across 1250 |..| 1258 as range loop
				encoding := Windows | range.item.to_natural_32
				if base.is_valid (encoding) then
					Result.extend (encoding)
				end
			end
		end

	doubles_array_manifest (upper: INTEGER_REF): STRING
		do
			create Result.make (Number.Doubles_list.count * 4)
			Result.append ("<< ")
			across Number.Doubles_list as n until
				attached upper as u and then n.cursor_index > u.item
			loop
				if n.cursor_index > 1 then
					Result.append (", ")
				end
				Result.append (Number.double_to_string (n.item).out)
			end
			Result.append (" >>")
		end

	natural_encoding (line: STRING_32; type: NATURAL): NATURAL
		-- most natural encoding for `line' for encoding `type' from `lines'
		do
			inspect type
				when Windows then
					Result := natural_windows_x (line)

				when Latin then
					Result := natural_latin_x (line)
			else
				Result := Utf_8
			end
		end

	natural_latin_x (line: STRING_32): NATURAL
		-- most natural Latin-x encoding for `line' from `lines'
		do
			if across {STRING_32} "€Ž" as c some line.has (c.item)  end then
				Result := Latin | 15

			elseif line.has ('и')  then
				Result := Latin | 5
			else
				Result := Latin | 1
			end
		end

	natural_windows_x (line: STRING_32): NATURAL
		-- most natural Windows-x encoding for `line' from `lines'
		do
			if line.has ('и') then
				Result := Windows | 1251

			elseif line.has ('¼') then
				Result := Windows | 1252
			else
				Result := Windows | 1250
			end
		end

feature -- Eiffel

	Eiffel_assignment: STRING = "[
		str := "1%N2%"/3"
	]"

	Eiffel_type_declarations: STRING = "[
		STRING
		ARRAY [STRING]
		HASH_TABLE [STRING, STRING]
		ARRAY [HASH_TABLE [STRING, STRING]]
		HASH_TABLE [ARRAY [HASH_TABLE [STRING, STRING]], STRING]
	]"

feature -- Lists

	continents: ARRAY [STRING]
		do
			Result := << "Europe", "Asia" , "Africa", "North America", "South America", "Antarctica" >>
		end

	cyrillic_line: ZSTRING
		do
			Result := cyrillic_line_32
		end

	cyrillic_line_32: STRING_32
		local
			s: EL_STRING_32_ROUTINES
		do
			Result := s.substring_to (Mixed_text, '%N')
		end

	lines: EL_ZSTRING_LIST
		do
			create Result.make_with_lines (Mixed_text)
		end

	lines_32: EL_STRING_32_LIST
		do
			create Result.make_with_lines (Mixed_text)
		end

	lines_8, latin_1_list: EL_STRING_8_LIST
		-- only Latin-1 encoded lines
		do
			create Result.make (5)
			across lines_32 as list loop
				if list.item.is_valid_as_string_8 then
					Result.extend (list.item.to_string_8)
				end
			end
		end

	symbol_32_list: EL_STRING_32_LIST
		local
			uc: EL_CHARACTER_32
		do
			create Result.make (5)
			across << Euro_symbol, G_clef [1], Mu_symbol, Dollor_symbol, Tab_character >> as c loop
				uc := c.item
				Result.extend (uc.to_string)
			end
		end

	latin_1_words, words_8: EL_STRING_8_LIST
		do
			create Result.make (50)
			across lines_32 as line loop
				across line.item.split (' ') as split loop
					if attached split.item as word and then word.is_valid_as_string_8 then
						Result.extend (word.to_string_8)
					end
				end
			end
		end

	words: EL_STRING_32_LIST
		do
			create Result.make (50)
			across lines_32 as line loop
				across line.item.split (' ') as word loop
					Result.extend (word.item)
				end
			end
		end

feature -- Characters

	Dollor_symbol: CHARACTER_32 = '$'

	Euro_symbol: CHARACTER_32 = '€'

	G_clef: STRING_32 = "𝄞"

	Mu_symbol: CHARACTER_32 = 'µ'

	Ogham_space_mark: CHARACTER_32
		once
			Result := (0x1680).to_character_32
		end

	Tab_character: CHARACTER_32
		once
			Result := '%T'
		end

feature -- Substitution testing

	Country: TUPLE [name, code, population: STRING]
		once
			create Result
			Tuple.fill (Result, "name, code, population")
		end

	Country_template_canonical: STRING = "Country: ${name}; Code: ${code}; Population: ${population}; Code again: ${code}"

	country_substituted (name, code: READABLE_STRING_GENERAL; population: INTEGER): STRING
		local
			dollor: STRING
		do
			Result := country_template
			dollor := "$"
			Result.replace_substring_all (dollor + Country.name , name.to_string_8)
			Result.replace_substring_all (dollor + Country.code , code.to_string_8)
			Result.replace_substring_all (dollor + Country.population , population.out)
		end

	country_template: STRING
		do
			Result := country_template_canonical.twin
			across "{}" as c loop
				Result.prune_all (c.item)
			end
		end

feature -- STRING_32 contants

	Lower_case_characters: STRING_32 = "™ÿaàöžšœ" --

	Lower_case_mu: STRING_32 = "µ symbol"

	Mixed_text: STRING_32 = "[
		и рыбку съесть, и в воду не лезть
		Wanting to eat a fish without first catching it from the waters
		Dunboyne is Dún Búinne
		Latin-1: ¼ + ¾ = 1
		Latin-15: Slavoj Žižek
		Le Quattro Stagioni ´L´Estate`- I. Allegro non molto
		Price € 100
	]"

	Upper_case_characters: STRING_32 = "™ŸAÀÖŽŠŒ"

	Upper_case_mu: STRING_32 = "Μ SYMBOL"

feature -- Constants

	Character_set: ARRAY [CHARACTER_32]
		local
			hash_set: EL_HASH_SET [CHARACTER_32]
		once
			create hash_set.make_from (Mixed_text, False)
			Result := hash_set.to_list.to_array
		end

	Escaped_substitution_marker: STRING = "%%%S"

	Substituted_words: ARRAY [TUPLE]
		once
			Result := <<
				[{STRING_32} "и", {STRING_32} "съесть", {STRING_32} "лезть"],
				["eat", "fish", "catching"],
				["Dún", 'ú'],
				[1, 1],
				[15],
				['´'],
				[Euro_symbol]
			>>
		ensure
			same_number: Result.count = Mixed_text.occurrences ('%N') + 1
		end

	Word_intervals: ARRAYED_LIST [INTEGER_INTERVAL]
		local
			i, j: INTEGER
		once
			create Result.make (20)
			from i := 0 until j > 0 and i = 0 loop
				j := Mixed_text.index_of (' ', i + 1)
				if j = 0 then
					j := Mixed_text.count + 1
				end
				Result.extend ((i + 1) |..| (j - 1))
				i := Mixed_text.index_of (' ', j - 1)
			end
		end

end