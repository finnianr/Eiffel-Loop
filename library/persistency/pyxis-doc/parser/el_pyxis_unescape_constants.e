note
	description: "Python unescape constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-31 9:37:13 GMT (Wednesday 31st March 2021)"
	revision: "10"

class
	EL_PYXIS_UNESCAPE_CONSTANTS

feature {NONE} -- Implementation

	new_escape_table (quote_mark: CHARACTER_32): HASH_TABLE [CHARACTER_32, CHARACTER_32]
		do
			create Result.make (3)
			Result [Escape_character] := Escape_character
			Result ['n'] := '%N'
			Result ['t'] := '%T'
			Result [quote_mark] := quote_mark
		end

feature {NONE} -- Constants

	Escape_character: CHARACTER_32 = '\'

	Quote_unescaper: EL_BOOLEAN_INDEXABLE [EL_STRING_8_UNESCAPER]
		-- single quote is False
		-- double quote is True
		local
			single, double: EL_STRING_8_UNESCAPER
		once
			create single.make (Escape_character, new_escape_table ('%''))
			create double.make (Escape_character, new_escape_table ('"'))
			create Result.make (single, double)
		end

end