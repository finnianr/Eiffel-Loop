note
	description: "Search engine test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-20 7:59:13 GMT (Friday 20th September 2024)"
	revision: "20"

class
	SEARCH_ENGINE_TEST_SET

inherit
	EL_FILE_DATA_TEST_SET
		redefine
			on_prepare
		end

	SHARED_HEXAGRAM_STRINGS; EL_SHARED_TEST_TEXT; EL_SHARED_CYCLIC_REDUNDANCY_CHECK_32

	EL_CHARACTER_32_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["word_token_table",					 agent test_word_token_table],
				["persistent_chinese_word_table", agent test_persistent_chinese_word_table],
				["persistent_english_word_table", agent test_persistent_english_word_table]
			>>)
		end

feature -- Tests

	test_persistent_chinese_word_table
		note
			testing: "[
				covers/{EL_WORD_TOKEN_TABLE}.valid_token_list,
				covers/{EL_ZSTRING_ROUTINES_IMP}.last_word_start_index
			]"
		do
			test_persistent_word_table (Chinese)
		end

	test_persistent_english_word_table
		note
			testing: "[
				covers/{EL_WORD_TOKEN_TABLE}.valid_token_list,
				covers/{EL_ZSTRING_ROUTINES_IMP}.last_word_start_index
			]"
		do
			test_persistent_word_table (English)
		end

	test_word_token_table
		-- SEARCH_ENGINE_TEST_SET.test_word_token_table
		local
			table: EL_WORD_TOKEN_TABLE; paragraphs: ZSTRING
			token_list: EL_WORD_TOKEN_LIST
		do
			create table.make (50)
			paragraphs := Text.Mixed_text
			token_list := table.paragraph_list_tokens (paragraphs.split ('%N'))
			if attached crc_generator as crc then
				crc.add_string_32 (token_list)
				assert ("same checksum", crc.checksum = 2487222442)
			end
		end

feature {NONE} -- Events

	on_prepare
		do
			Precursor
			create token_table.make (100)
		end

feature {NONE} -- Implementation

	new_word_list: EL_COMMA_SEPARATED_WORDS_LIST
		do
			create Result.make (token_table, Words_file_path)
		end

	test_persistent_word_table (language: INTEGER)
		local
			word_list: like new_word_list; paragraph_list: EL_ZSTRING_LIST
			i: INTEGER; tokens: EL_WORD_TOKEN_LIST
			l_token_table: like token_table
		do
			word_list := new_word_list
			create paragraph_list.make (1)
			from i := 1 until i > 64 loop
				if i \\ 8 = 0 then
					lio.put_integer_field ("hexagram", i)
					lio.put_new_line
				end
				inspect language
					when English then
						paragraph_list.extend (Hexagram.english_titles [i])
					when Chinese then
						if attached Hexagram.Name_list [i] as name then
							paragraph_list.extend (space.joined (name.pinyin, name.hanzi))
						end
				end
				tokens := token_table.paragraph_tokens (paragraph_list.last)
				assert ("valid_token_list", token_table.valid_token_list (tokens, paragraph_list))
				paragraph_list.wipe_out

				if i \\ 8 = 0 then
					l_token_table := token_table
					create token_table.make (l_token_table.count)

					word_list.close
					word_list := new_word_list
					assert ("same words", l_token_table ~ token_table)
				end
				i := i + 1
			end
			word_list.close
		end

feature {NONE} -- Internal attributes

	token_table: EL_WORD_TOKEN_TABLE

feature {NONE} -- Constants

	Chinese: INTEGER = 1

	English: INTEGER = 2

	Words_file_path: FILE_PATH
		once
			Result := Work_area_dir + "words.dat"
		end

end