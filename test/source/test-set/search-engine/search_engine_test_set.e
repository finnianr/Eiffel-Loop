note
	description: "Search engine test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-02-14 12:54:43 GMT (Thursday 14th February 2019)"
	revision: "2"

class
	SEARCH_ENGINE_TEST_SET

inherit
	EL_FILE_DATA_TEST_SET
		rename
			new_empty_file_tree as new_file_tree
		redefine
			on_prepare
		end

	EL_MODULE_HEXAGRAM
		undefine
			default_create
		end

feature -- Tests

	test_persistent_word_table
		local
			word_list: like new_word_list
			i: INTEGER; token_table: EL_WORD_TOKEN_TABLE
			tokens: EL_TOKENIZED_STRING
		do
			create token_table.make (100)
			word_list := new_word_list
			from i := 1 until i > 64 loop
				lio.put_integer_field ("hexagram", i)
				lio.put_new_line
				create tokens.make_from_string (token_table, Hexagram.english_titles [i])
				word_list.update_words (token_table)
				if i \\ 8 = 0 then
					word_list.close
					word_list := new_word_list
					assert ("same words", token_table ~ word_list.to_token_table)
				end
				i := i + 1
			end
			word_list.close
		end

	test_encrypted_persistent_word_table
		do
			create encrypter.make_128 ("hexagram")
			test_persistent_word_table
		end

feature {NONE} -- Events

	on_prepare
		do
			Precursor
			encrypter := Default_encrypter
		end

feature {NONE} -- Implementation

	new_word_list: EL_COMMA_SEPARATED_WORDS_LIST
		do
			if encrypter = Default_encrypter then
				create Result.make_from_file (Words_file_path)
			else
				create Result.make_from_file_and_encrypter (Words_file_path, encrypter)
			end
		end

feature {NONE} -- Internal attributes

	encrypter: EL_AES_ENCRYPTER

feature {NONE} -- Constants

	Default_encrypter: EL_AES_ENCRYPTER
		once
			create Result
		end

	Words_file_path: EL_FILE_PATH
		once
			Result := Work_area_dir + "words.dat"
		end

end
