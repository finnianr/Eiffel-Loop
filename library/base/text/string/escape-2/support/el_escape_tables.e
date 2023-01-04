note
	description: "Escape tables for common data formats"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-01-04 18:28:59 GMT (Wednesday 4th January 2023)"
	revision: "2"

class
	EL_ESCAPE_TABLES

feature -- Access

	Bash: EL_ESCAPE_TABLE
		do
			create Result.make_simple ('\', "<>(){}[] '`%"!?&|^$:;,")
		end

	CSV: EL_ESCAPE_TABLE
		once
			create Result.make ('\', <<
				"%N:=n", "%R:=r", "%T:=t", "%":=%"", "\:=\"
			>>)
		end

	JSON: EL_ESCAPE_TABLE
		once
			create Result.make ('\', <<
				"%B:=b", "%F:=f", "%N:=n", "%R:=r", "%T:=t",
				"%":=%"", "\:=\"
			>>)
		end

	Python_1: EL_ESCAPE_TABLE
		-- Python escape table with single quotes escapes
		once
			Result := new_python
			Result ['%''] := '%''
		end

	Python_2: EL_ESCAPE_TABLE
		-- Python escape table with double quotes escapes
		once
			Result := new_python
			Result ['"'] := '"'
		end

feature {NONE} -- Implementation

	new_python: EL_ESCAPE_TABLE
		do
			create Result.make ('\', <<
				"%T:=t", "%N:=n", "\:=\"
			>>)
		end
end