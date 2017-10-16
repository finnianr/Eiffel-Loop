note
	description: "Summary description for {EL_DO_NOTHING_CHARACTER_ESCAPER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:20:59 GMT (Thursday 12th October 2017)"
	revision: "2"

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