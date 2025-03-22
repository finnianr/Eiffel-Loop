note
	description: "Escape string as CSV (comma separated value)"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-22 8:25:45 GMT (Saturday 22nd March 2025)"
	revision: "4"

class
	EL_CSV_ESCAPER [S -> STRING_GENERAL create make end]

inherit
	EL_STRING_ESCAPER [S]
		rename
			make as make_escaper
		redefine
			escaped, implementation, new_implementation
		end

	EL_SHARED_ESCAPE_TABLE

create
	make

feature {NONE} -- Initialization

	make
		do
			make_escaper (Escape_table.CSV)
		end

feature -- Conversion

	escaped (value: READABLE_STRING_GENERAL; keeping_ref: BOOLEAN): S
		-- return value with characters `%R, %N, ", \' escaped with `\'
		-- and enclose with double quotes if `value.has (',')'
		do
			Result := Precursor (value, keeping_ref)
			if value.has (',') and then attached implementation as imp then
				imp.prepend_character (Result, Double_quote)
				Result.append_code (Double_quote.natural_32_code)
			end
		end

feature {NONE} -- Implementation

	new_implementation: EL_CSV_ESCAPER_IMP [STRING_GENERAL]
		do
			inspect storage_type
				when '1' then
					create {EL_CSV_STRING_8_ESCAPER_IMP} Result.make
				when '4' then
					create {EL_CSV_STRING_32_ESCAPER_IMP} Result.make
				when 'X' then
					create {EL_CSV_ZSTRING_ESCAPER_IMP} Result.make
			else
				create {EL_CSV_STRING_32_ESCAPER_IMP} Result.make
			end
		end

feature {NONE} -- Internal attributes

	implementation: EL_CSV_ESCAPER_IMP [S]

feature {NONE} -- Constants

	Double_quote: CHARACTER_32 = '%"'

end