note
	description: "Summary description for {EL_DO_NOTHING_CHARACTER_ESCAPER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-27 18:22:33 GMT (Sunday 27th December 2015)"
	revision: "1"

class
	EL_DO_NOTHING_CHARACTER_ESCAPER [S -> STRING_GENERAL create make end]

inherit
	EL_CHARACTER_ESCAPER [S]

feature {NONE} -- Implementation

	append_escape_sequence (str: S; code: NATURAL)
		do
		end

	Characters: STRING_32 = ""

end