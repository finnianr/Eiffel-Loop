note
	description: "Summary description for {EL_PYTHON_UNESCAPE_CONSTANTS_2}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-20 14:29:45 GMT (Sunday 20th December 2015)"
	revision: "1"

class
	EL_PYTHON_UNESCAPE_CONSTANTS

feature {NONE} -- Constants

	Escape_character: CHARACTER_32 = '\'

	Double_quote_escape_table_32: HASH_TABLE [CHARACTER_32, CHARACTER_32]
		once
			create Result.make (4)
			Result.merge (Basic_escape_tuples)
			Result ['"'] := '"'
		end

	Single_quote_escape_table_32: HASH_TABLE [CHARACTER_32, CHARACTER_32]
		once
			create Result.make (4)
			Result.merge (Basic_escape_tuples)
			Result ['%''] := '%''
		end

	Basic_escape_tuples: HASH_TABLE [CHARACTER_32, CHARACTER_32]
		once
			create Result.make (3)
			Result [Escape_character] := Escape_character
			Result ['n'] := '%N'
			Result ['t'] := '%T'
		end

	Double_quote_escape_table: EL_ESCAPE_TABLE
		do
			create Result.make (Escape_character, Double_quote_escape_table_32)
		end

	Single_quote_escape_table: EL_ESCAPE_TABLE
		do
			create Result.make (Escape_character, Single_quote_escape_table_32)
		end

end