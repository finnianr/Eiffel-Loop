note
	description: "Python unescape constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:14 GMT (Thursday 20th September 2018)"
	revision: "7"

class
	EL_PYTHON_UNESCAPE_CONSTANTS

feature {NONE} -- Implementation

	new_escape_table: HASH_TABLE [CHARACTER_32, CHARACTER_32]
		do
			create Result.make (3)
			Result [Escape_character] := Escape_character
			Result ['n'] := '%N'
			Result ['t'] := '%T'
		end

feature {NONE} -- Constants

	Escape_character: CHARACTER_32 = '\'

	Single_quote_unescaper: EL_ZSTRING_UNESCAPER
		local
			table: like new_escape_table
		once
			table := new_escape_table
			table ['%''] := '%''
			create Result.make (Escape_character, table)
		end

	Double_quote_unescaper: EL_ZSTRING_UNESCAPER
		local
			table: like new_escape_table
		once
			table := new_escape_table
			table ['"'] := '"'
			create Result.make (Escape_character, table)
		end

end
