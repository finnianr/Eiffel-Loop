note
	description: "Python unescape constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:24:49 GMT (Saturday 19th May 2018)"
	revision: "6"

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
