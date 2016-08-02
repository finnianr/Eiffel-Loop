note
	description: "Summary description for {EL_PYTHON_ESCAPE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-09 13:09:55 GMT (Wednesday 9th December 2015)"
	revision: "1"

class
	EL_PYTHON_UNESCAPE_CONSTANTS

feature {NONE} -- Constants

	Escape_character: CHARACTER_32 = '\'

	Double_quote_escape_table: HASH_TABLE [CHARACTER_32, CHARACTER_32]
		once
			create Result.make (4)
			Result.merge (Basic_escape_tuples)
			Result ['"'] := '"'
		end

	Single_quote_escape_table: HASH_TABLE [CHARACTER_32, CHARACTER_32]
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

end