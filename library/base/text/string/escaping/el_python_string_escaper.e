note
	description: "Summary description for {EL_PYTHON_STRING_ESCAPER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:20:59 GMT (Thursday 12th October 2017)"
	revision: "2"

class
	EL_PYTHON_STRING_ESCAPER [S -> STRING_GENERAL create make end]

inherit
	EL_CHARACTER_ESCAPER [S]

create
	make

feature {NONE} -- Initialization

	make (quote_count: INTEGER)
		require
			single_or_double_quotes: quote_count = 1 or quote_count = 2
		do
			if quote_count = 1 then
				characters := Single_quote_characters
			else
				characters := Double_quote_characters
			end
		end

feature {NONE} -- Implementation

	append_escape_sequence (str: S; code: NATURAL)
		do
			str.append_code (('\').natural_32_code)
			str.append_code (code)
		end

	characters: STRING_32

feature {NONE} -- Constants

	Single_quote_characters: STRING_32 = "%T%N\'"

	Double_quote_characters: STRING_32 = "%T%N\%""
end