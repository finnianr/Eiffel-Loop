note
	description: "Escape characters for value in comma separated format"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_COMMA_SEPARATED_VALUE_ESCAPER

inherit
	EL_ZSTRING_ESCAPER
		rename
			make as make_escaper
		redefine
			escaped, append_escape_sequence
		end

create
	make

feature {NONE} -- Initialization

	make
		do
			make_from_table (Escape_table)
		end

feature -- Conversion

	escaped (value: like READABLE; keeping_ref: BOOLEAN): like once_buffer
		-- return value with characters `%R, %N, ", \' escaped with `\'
		-- and enclose with double quotes if `value.has (',')'
		do
			Result := Precursor (value, keeping_ref)
			if value.has (',') then
				Result.quote (2)
			end
		end

feature {NONE} -- Implementation

	append_escape_sequence (str: ZSTRING; code: NATURAL)
		do
			if code = Double_quote then
				-- Escape " as ""
				str.append_z_code (Double_quote)
			else
				str.append_z_code (escape_code)
			end
			str.append_z_code (code)
		end

feature {NONE} -- Constants

	Escape_table: HASH_TABLE [CHARACTER_32, CHARACTER_32]
		once
			create Result.make (11)
			Result ['%N'] := 'n'
			Result ['%R'] := 'r'
			Result ['%T'] := 't'
			Result ['"'] := '"'
			Result ['\'] := '\'
		end

	Double_quote: NATURAL = 34
end
