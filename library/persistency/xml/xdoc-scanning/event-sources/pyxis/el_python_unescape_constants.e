note
	description: "Summary description for {EL_PYTHON_UNESCAPE_CONSTANTS_2}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-04-09 13:37:51 GMT (Monday 9th April 2018)"
	revision: "4"

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
