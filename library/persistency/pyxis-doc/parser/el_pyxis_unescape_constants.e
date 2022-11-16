note
	description: "Python unescape constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "12"

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

	new_unescape (uc: CHARACTER_32): EL_STRING_8_UNESCAPER
		do
			create Result.make (Escape_character, new_escape_table (uc))
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