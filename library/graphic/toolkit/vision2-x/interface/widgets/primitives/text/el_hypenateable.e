note
	description: "Summary description for {EL_HYPENATEABLE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-09-02 10:55:13 GMT (Tuesday 2nd September 2014)"
	revision: "5"

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
