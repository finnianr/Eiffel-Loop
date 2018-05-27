note
	description: "Hypenateable"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:24:48 GMT (Saturday 19th May 2018)"
	revision: "4"

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