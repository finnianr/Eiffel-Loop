note
	description: "Python unescape constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-07-20 17:19:07 GMT (Thursday 20th July 2023)"
	revision: "15"

class
	EL_PYXIS_UNESCAPE_CONSTANTS

feature {NONE} -- Implementation

	new_escape_table (quote_mark: CHARACTER_32): EL_ESCAPE_TABLE
		do
			create Result.make (Escape_character, "\:=\, n:=%N, r:=%R, t:=%T")
			Result [quote_mark] := quote_mark
		end

	new_unescape (uc: CHARACTER_32): EL_STRING_8_UNESCAPER
		do
			create Result.make (new_escape_table (uc))
		end

feature {NONE} -- Constants

	Escape_character: CHARACTER_32 = '\'

	Quote_unescaper: EL_BOOLEAN_INDEXABLE [EL_STRING_8_UNESCAPER]
		-- single quote is False
		-- double quote is True
		once
			Result := [new_unescape ('%''), new_unescape ('"')]
		end

end