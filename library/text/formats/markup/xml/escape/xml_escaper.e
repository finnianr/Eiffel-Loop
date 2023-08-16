note
	description: "XML string escaper"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-02 14:34:28 GMT (Wednesday 2nd August 2023)"
	revision: "17"

class
	XML_ESCAPER [S -> STRING_GENERAL create make end]

inherit
	EL_STRING_ESCAPER [S]
		rename
			make as make_escaper
		redefine
			implementation, Zstring_imp, String_8_imp, String_32_imp
		end

	EL_SHARED_ESCAPE_TABLE

create
	make, make_128_plus

feature {NONE} -- Initialization

	make
		do
			make_escaper (Escape_table.XML)
		end

	make_128_plus
		do
			make
			escape_128_plus := True
		end

feature -- Access

	escape_sequence (uc: CHARACTER_32): STRING
		do
			if attached implementation as imp then
				Result := imp.escape_sequence (imp.to_code (uc), escape_128_plus)
			end
		end

feature -- Status query

	escape_128_plus: BOOLEAN

feature {NONE} -- Internal attributes

	implementation: XML_ESCAPER_IMP [S]

feature {NONE} -- Constants

	STRING_32_imp: XML_STRING_32_ESCAPER_IMP
		once
			create Result.make
		end

	STRING_8_imp: XML_STRING_8_ESCAPER_IMP
		once
			create Result.make
		end

	ZSTRING_imp: XML_ZSTRING_ESCAPER_IMP
		once
			create Result.make
		end

end