note
	description: "Escape string as CSV (comma separated value)"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-01-05 10:45:29 GMT (Thursday 5th January 2023)"
	revision: "1"

class
	EL_CSV_ESCAPER [S -> STRING_GENERAL create make end]

inherit
	EL_STRING_ESCAPER [S]
		rename
			make as make_escaper
		redefine
			escaped, implementation, Zstring_imp, String_8_imp, String_32_imp
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
			if value.has (',') and then attached adjusted_implementation as imp then
				imp.prepend_character (Result, Double_quote)
				Result.append_code (Double_quote.natural_32_code)
			end
		end

feature {NONE} -- Internal attributes

	escape_128_plus: BOOLEAN

	implementation: EL_CSV_ESCAPER_IMP [S]

feature {NONE} -- Alternative implementations

	String_32_imp: EL_CSV_STRING_32_ESCAPER_IMP
		once
			create Result.make
		end

	String_8_imp: EL_CSV_STRING_8_ESCAPER_IMP
		once
			create Result.make
		end

	Zstring_imp: EL_CSV_ZSTRING_ESCAPER_IMP
		once
			create Result.make
		end

feature {NONE} -- Constants

	Double_quote: CHARACTER_32 = '%"'

end