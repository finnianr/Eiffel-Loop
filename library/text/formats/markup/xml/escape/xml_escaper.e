note
	description: "XML string escaper"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-22 8:16:06 GMT (Saturday 22nd March 2025)"
	revision: "18"

class
	XML_ESCAPER [S -> STRING_GENERAL create make end]

inherit
	EL_STRING_ESCAPER [S]
		rename
			make as make_escaper
		redefine
			implementation, new_implementation
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

feature {NONE} -- Implementation

	new_implementation: XML_ESCAPER_IMP [STRING_GENERAL]
		do
			inspect storage_type
				when '1' then
					create {XML_STRING_8_ESCAPER_IMP} Result.make
				when '4' then
					create {XML_STRING_32_ESCAPER_IMP} Result.make
				when 'X' then
					create {XML_ZSTRING_ESCAPER_IMP} Result.make
			else
				create {XML_STRING_32_ESCAPER_IMP} Result.make
			end
		end

feature {NONE} -- Internal attributes

	implementation: XML_ESCAPER_IMP [S]

end