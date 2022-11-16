note
	description: "Hypenateable"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "7"

class
	EL_HYPENATEABLE

feature -- Status query

	is_hyphenated: BOOLEAN
		-- true if words are split across lines by hyphens

feature -- Status setting

	enable_word_hyphenation
		-- enable splitting of words across lines
		do
			is_hyphenated := True
		end

	disable_word_hyphenation
		-- disable text hyphenation
		do
			is_hyphenated := False
		end

end