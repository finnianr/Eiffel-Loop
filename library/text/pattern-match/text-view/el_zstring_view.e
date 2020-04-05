note
	description: "[
		Text view for pure latin encoded text of type [$source EL_ZSTRING]
		Use [$source EL_MIXED_ENCODING_ZSTRING_VIEW] for text with mixed encodings of Latin and Unicode
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-13 13:11:48 GMT (Monday 13th January 2020)"
	revision: "5"

class
	EL_ZSTRING_VIEW

inherit
	EL_STRING_VIEW
		rename
			code as z_code,
			code_at_absolute as z_code_at_absolute
		redefine
			append_substring_to, make, to_string, to_string_8
		end

	EL_ZCODE_CONVERSION

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

feature -- Basic operations

	append_substring_to (str: STRING_GENERAL; start_index, end_index: INTEGER)
		local
			i: INTEGER
		do
			if attached {ZSTRING} str as zstr then
				zstr.grow (end_index - start_index + 1 + zstr.count)
				from i := start_index until i > end_index or else i > count loop
					zstr.append_z_code (z_code (i))
					i := i + 1
				end
			else
				from i := start_index until i > end_index or else i > count loop
					str.append_code (z_code_to_unicode (z_code (i)))
					i := i + 1
				end
			end
		end

feature {NONE} -- Internal attributes

	area: SPECIAL [CHARACTER_8]

	text: EL_ZSTRING

end
