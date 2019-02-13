note
	description: "Comma separated words"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-02-13 14:55:19 GMT (Wednesday 13th February 2019)"
	revision: "1"

class
	EL_COMMA_SEPARATED_WORDS

inherit
	EL_REFLECTIVELY_SETTABLE_STORABLE
		rename
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
			create Result.make_with_separator (words, ',', False)
		end

feature -- Element change

	set_words (a_words: ZSTRING)
		do
			words.share (a_words)
		end

feature {NONE} -- Constants

	Field_hash: NATURAL = 2464806956

end
