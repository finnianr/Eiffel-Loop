note
	description: "Search engine test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-14 11:32:23 GMT (Friday 14th February 2020)"
	revision: "8"

class
	SEARCH_ENGINE_TEST_SET

inherit
	EL_GENERATED_FILE_DATA_TEST_SET
		rename
			new_empty_file_tree as new_file_tree
		redefine
			on_prepare
		end

	SHARED_HEXAGRAM_STRINGS
		undefine
			default_create
		end

feature -- Basic operations

	do_all (eval: EL_EQA_TEST_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("persistent_word_table", agent test_persistent_word_table)
		end

feature -- Tests

	test_persistent_word_table
		local
			word_list: like new_word_list
			i: INTEGER; tokens: EL_WORD_TOKEN_LIST
			l_token_table: like token_table
		do
			word_list := new_word_list
			from i := 1 until i > 64 loop
				lio.put_integer_field ("hexagram", i)
				lio.put_new_line
				tokens := token_table.paragraph_tokens (Hexagram.english_titles [i])
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

feature {NONE} -- Internal attributes

	token_table: EL_WORD_TOKEN_TABLE

feature {NONE} -- Constants

	Words_file_path: EL_FILE_PATH
		once
			Result := Work_area_dir + "words.dat"
		end

end
