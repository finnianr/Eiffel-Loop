note
	description: "A list of comma separated words for use with ${EL_COMMA_SEPARATED_WORDS_LIST}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:26 GMT (Saturday 20th January 2024)"
	revision: "9"

class
	EL_COMMA_SEPARATED_WORDS

inherit
	EL_REFLECTIVELY_SETTABLE_STORABLE
		rename
			foreign_naming as eiffel_naming,
			read_version as read_default_version
		export
			{NONE} all
		end

	EL_SETTABLE_FROM_ZSTRING
		export
			{NONE} all
		end

create
	make_default, make

convert
	make ({EL_ZSTRING_LIST})

feature {NONE} -- Initialization

	make (a_word_list: EL_ZSTRING_LIST)
		do
			make_default
			words.share (a_word_list.joined (','))
		end

feature -- Access

	words: ZSTRING
		-- comma separated list of words

	word_list: EL_ZSTRING_LIST
		do
			create Result.make_split (words, ',')
		end

feature -- Measurement

	byte_count (reader: EL_MEMORY_READER_WRITER): INTEGER
		-- Estimated byte count
		do
			Result := reader.size_of_string (words)
			if attached {EL_ENCRYPTABLE} reader as encryptable then
				Result := encryptable.encrypter.encrypted_size (Result)
			end
		end

feature -- Element change

	set_words (a_words: ZSTRING)
		do
			words.share (a_words)
		end

feature {NONE} -- Constants

	Field_hash: NATURAL = 2464806956

end