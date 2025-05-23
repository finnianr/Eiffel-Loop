note
	description: "Converts to and from UTF-8"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-20 11:52:26 GMT (Sunday 20th April 2025)"
	revision: "29"

class
	EL_UTF_8_ZCODEC

inherit
	EL_ZCODEC
		rename
			single_byte_unicode_chars as new_unicode_table,
			append_encoded_to_string_8 as append_general_to_utf_8
		redefine
			as_unicode, write_encoded, write_encoded_character, is_numeric, append_general_to_utf_8
		end

	EL_SHARED_UTF_8_STRING
		rename
			UTF_8_string as UTF_8_buffer
		end

create
	make

feature {NONE} -- Initialization

	initialize_latin_sets
		do
		end

feature -- Basic operations

	append_general_to_utf_8 (a_unicode_in: READABLE_STRING_GENERAL; utf_8_out: STRING)
		local
			sg: EL_STRING_GENERAL_ROUTINES
		do
			if attached {ZSTRING} a_unicode_in as zstr then
				zstr.append_to_utf_8 (utf_8_out)

			elseif attached sg.super_readable_general (a_unicode_in) as unicode_in then
				utf_8_out.grow (utf_8_out.count + unicode_in.utf_8_byte_count)
				unicode_in.append_to_utf_8 (utf_8_out)
			end
		end

	write_encoded (unicode_in: READABLE_STRING_GENERAL; writeable: EL_WRITABLE)
		do
			Utf_8_buffer.set_from_general (unicode_in)
			writeable.write_encoded_string_8 (Utf_8_buffer)
		end

	write_encoded_character (uc: CHARACTER_32; writeable: EL_WRITABLE)
		local
			c: EL_CHARACTER_32_ROUTINES
		do
			c.write_utf_8 (uc, writeable)
		end

feature -- Conversion

	as_lower (code: NATURAL): NATURAL
		do
			Result := code.to_character_32.as_lower.natural_32_code
		end

	as_upper (code: NATURAL): NATURAL
		do
			Result := code.to_character_32.as_upper.natural_32_code
		end

	as_unicode (a_utf_8: READABLE_STRING_8; keeping_ref: BOOLEAN): READABLE_STRING_GENERAL
		-- returns `utf_8' string as unicode
		-- when keeping a reference to `Result' specify `keeping_ref' as `True'
		do
			if Empty_string.is_ascii_string (a_utf_8) then
				Result := a_utf_8
			else
				Unicode_buffer.set_from_utf_8 (a_utf_8)
				Result := Unicode_buffer
			end
			if keeping_ref then
				Result := Result.twin
			end
		end

	as_utf_8 (str: READABLE_STRING_GENERAL; keeping_ref: BOOLEAN): EL_UTF_8_STRING
		-- returns general string `str' as UTF-8 encoded string
		-- when keeping a reference to `Result' specify `keeping_ref' as `True'
		obsolete
			"Use String_8_scope and copied_utf_8_item instead"
		do
			Result := Utf_8_buffer
			Result.set_from_general (str)
			if keeping_ref then
				Result := Result.twin
			end
		end

	latin_character (uc: CHARACTER_32): CHARACTER
			--
		do
		end

	to_lower_offset (code: NATURAL): INTEGER
		do
			Result := code.to_character_32.as_lower.code - code.to_integer_32
		end

	to_upper_offset (code: NATURAL): INTEGER
		do
			Result := code.to_character_32.as_upper.code - code.to_integer_32
		end

feature -- Character query

	in_latin_1_disjoint_set (c: CHARACTER): BOOLEAN
		do
			Result := c.code > 0x7F
		end

	is_alpha (code: NATURAL): BOOLEAN
		do
			Result := code.to_character_32.is_alpha
		end

	is_lower (code: NATURAL): BOOLEAN
		do
			Result := code.to_character_32.is_lower
		end

	is_numeric (code: NATURAL): BOOLEAN
		local
			c: EL_CHARACTER_32_ROUTINES
		do
			Result := c.is_digit (code.to_character_32)
		end

	is_upper (code: NATURAL): BOOLEAN
		do
			Result := code.to_character_32.is_upper
		end

	unicode_case_change_substitute (code: NATURAL): CHARACTER_32
		do
		end

end