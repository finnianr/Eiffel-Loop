note
	description: "[
		Text view for pure latin encoded text of type `EL_ZSTRING'
		Use `EL_MIXED_ENCODING_ZSTRING_TEXT_VIEW' for text with mixed encodings of Latin and Unicode
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-07 16:30:53 GMT (Thursday 7th July 2016)"
	revision: "5"

class
	EL_ZSTRING_VIEW

inherit
	EL_STRING_VIEW
		rename
			code as z_code,
			code_at_absolute as z_code_at_absolute
		redefine
			make, to_string, to_string_8
		end

create
	make

feature {NONE} -- Initialization

	make (a_text: like text)
		require else
			valid_encoding: not is_mixed_encoding implies not a_text.has_mixed_encoding
		do
			text := a_text; area := a_text.area
			Precursor (a_text)
		end

feature -- Status query

	is_mixed_encoding: BOOLEAN
		do
			Result := False
		end

feature -- Access

	z_code (i: INTEGER): NATURAL_32
			-- Character at position `i'
		do
			Result := area.item (offset + i - 1).natural_32_code
		end

	z_code_at_absolute (i: INTEGER): NATURAL_32
			-- Character at position `i'
		do
			Result := area.item (i - 1).natural_32_code
		end

	occurrences (a_code: like z_code): INTEGER
		local
			l_area: like area; i, l_count: INTEGER; c: CHARACTER
		do
			l_area := area; l_count := count
			c := a_code.to_character_8
			from i := 0 until i = l_count loop
				if l_area.item (offset + i - 1) = c then
					Result := Result + 1
				end
				i := i + 1
			end
		end

	to_string: EL_ZSTRING
		do
			Result := text.substring (offset + 1, offset + count)
		end

	to_string_8: STRING
		do
			Result := to_string.to_latin_1
		end

	to_string_general: READABLE_STRING_GENERAL
		do
			Result := to_string.to_unicode
		end

feature {NONE} -- Internal attributes

	area: like text.area

	text: EL_ZSTRING

end