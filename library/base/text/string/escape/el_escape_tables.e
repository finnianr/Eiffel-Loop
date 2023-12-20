note
	description: "Escape tables for common data formats"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-07-21 14:04:58 GMT (Friday 21st July 2023)"
	revision: "7"

class
	EL_ESCAPE_TABLES

feature -- Access

	Bash: EL_ESCAPE_TABLE
		once
			create Result.make_simple ('\', "<>(){}[] '`%"!?&|^$:;,")
		end

	C_language: EL_ESCAPE_TABLE
		once
			Result := new_c_language
			Result ['"'] := '"'
		end

	CSV: EL_ESCAPE_TABLE
		once
			create Result.make ('\', "%N:=n, %R:=r, %T:=t, %":=%", \:=\")
		end

	Eiffel: EL_ESCAPE_TABLE
		-- Eiffel special characters for strings
		once
			create Result.make ('%%', new_eiffel_manifest)
		end

	JSON: EL_ESCAPE_TABLE
		once
			create Result.make ('\', "%B:=b, %F:=f, %N:=n, %R:=r, %T:=t, %":=%", \:=\")
		end

	Python_1: EL_ESCAPE_TABLE
		-- Python escape table with single quotes escapes
		once
			Result := new_c_language
			Result ['%''] := '%''
		end

	Python_2: EL_ESCAPE_TABLE
		-- Python escape table with double quotes escapes
		once
			Result := C_language
		end

	Substitution: EL_ESCAPE_TABLE
		once
			create Result.make ('%%', "S:=%S, %%:=%%")
		end

	XML: EL_ESCAPE_TABLE
		once
			create Result.make_simple ('%U', "<>&'%"")
		end

feature {NONE} -- Implementation

	new_c_language: EL_ESCAPE_TABLE
		do
			create Result.make ('\', "%T:=t, %N:=n, \:=\")
		end

	new_eiffel_manifest: STRING
		-- Eiffel special characters for strings
		local
			special_letters, escape_sequence, item: STRING; list: EL_STRING_8_LIST
		do
			-- " -> %" Double quote
			-- [ -> %( Opening bracket
			-- % -> %% Percent

			special_letters := "ABCDFHLNQRSTUV%"[%%"
			escape_sequence := "%A%B%C%D%F%H%L%N%Q%R%S%T%U%V%"%(%%"
			check
				same_count: special_letters.count = escape_sequence.count
			end
			create list.make (special_letters.count)
			across special_letters as c loop
				create item.make (4)
				item.append_character (escape_sequence [c.cursor_index])
				item.append (":=")
				item.append_character (c.item)
				list.extend (item)
			end
			Result := list.joined (',')
		end
end