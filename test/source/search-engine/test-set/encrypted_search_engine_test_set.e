note
	description: "Encrypted search engine test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-02-27 13:31:25 GMT (Wednesday 27th February 2019)"
	revision: "1"

class
	ENCRYPTED_SEARCH_ENGINE_TEST_SET

inherit
	SEARCH_ENGINE_TEST_SET
		redefine
			new_word_list
		end

feature {NONE} -- Implementation

	new_word_list: EL_COMMA_SEPARATED_WORDS_LIST
		local
			encrypter: EL_AES_ENCRYPTER
		do
			create encrypter.make ("hexagram", 128)
			create Result.make_encrypted (token_table, Words_file_path, encrypter)
		end
end
