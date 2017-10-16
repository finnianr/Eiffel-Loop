note
	description: "Summary description for {EL_BASH_PATH_CHARACTER_ESCAPER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:20:59 GMT (Thursday 12th October 2017)"
	revision: "2"

class
	EL_BASH_PATH_CHARACTER_ESCAPER [S -> STRING_GENERAL create make end]

inherit
	EL_CHARACTER_ESCAPER [S]

feature {NONE} -- Implementation

	append_escape_sequence (str: S; code: NATURAL)
		do
			str.append_code (('\').natural_32_code)
			str.append_code (code)
		end

feature {NONE} -- Constants

	Characters: STRING_32 = "<>(){}[]'`%"\!?&|^$:;, "

end