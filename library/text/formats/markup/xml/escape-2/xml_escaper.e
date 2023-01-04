note
	description: "XML string escaper"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-01-04 18:30:42 GMT (Wednesday 4th January 2023)"
	revision: "14"

class
	XML_ESCAPER [S -> STRING_GENERAL create make end]

inherit
	EL_STRING_ESCAPER [S]
		rename
			make as make_escaper
		redefine
			adjusted_implementation, implementation, Zstring_imp, String_8_imp, String_32_imp
		end

create
	make, make_128_plus

feature {NONE} -- Initialization

	make
		do
			make_escaper (XML_table)
		end

	make_128_plus
		do
			make
			escape_128_plus := True
		end

feature {NONE} -- Implementation

	adjusted_implementation: like implementation
		do
			Result := implementation
			Result.set_escape_128_plus (escape_128_plus)
		end

feature {NONE} -- Internal attributes

	escape_128_plus: BOOLEAN

	implementation: XML_ESCAPER_IMP [S]

feature {NONE} -- Constants

	String_8_imp: XML_STRING_8_ESCAPER_IMP
		once
			create Result.make
		end

	String_32_imp: XML_STRING_32_ESCAPER_IMP
		once
			create Result.make
		end

	XML_table: EL_ESCAPE_TABLE
		do
			create Result.make_simple ('%U', "<>&'%"")
		end

	Zstring_imp: XML_ZSTRING_ESCAPER_IMP
		once
			create Result.make
		end

end