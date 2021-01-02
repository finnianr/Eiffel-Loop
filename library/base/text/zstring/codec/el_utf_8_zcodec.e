note
	description: "Converts to and from UTF-8"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-02 12:40:59 GMT (Saturday 2nd January 2021)"
	revision: "10"

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

	EL_MODULE_CHAR_8

	EL_MODULE_CHAR_32

	EL_MODULE_STRING_32

create
	make

feature {NONE} -- Initialization

	initialize_latin_sets
		do
		end

feature -- Basic operations

	append_general_to_utf_8 (unicode_in: READABLE_STRING_GENERAL; utf_8_out: STRING)
		local
			l_unicode_in: READABLE_STRING_GENERAL; c: EL_UTF_CONVERTER
		do
			if attached {EL_READABLE_ZSTRING} unicode_in as zstr then
				Unicode_buffer.set_from_string (zstr)
				l_unicode_in := Unicode_buffer
			else
				l_unicode_in := unicode_in
			end
			utf_8_out.grow (utf_8_out.count + c.utf_8_bytes_count (l_unicode_in, 1, l_unicode_in.count))
			c.utf_32_string_into_utf_8_string_8 (l_unicode_in, utf_8_out)
		end

	write_encoded (unicode_in: READABLE_STRING_GENERAL; writeable: EL_WRITEABLE)
		do
			String_32.write_utf_8 (unicode_in, writeable)
		end

	write_encoded_character (uc: CHARACTER_32; writeable: EL_WRITEABLE)
		do
			Char_8.write_utf_8 (uc, writeable)
		end

feature -- Conversion

	as_lower (code: NATURAL): NATURAL
		do
			Result := code.to_character_32.as_lower.natural_32_code
		end

	as_unicode (a_utf_8: READABLE_STRING_8; keeping_ref: BOOLEAN): READABLE_STRING_GENERAL
		-- returns `utf_8' string as unicode
		-- when keeping a reference to `Result' specify `keeping_ref' as `True'
		do
			if Utf_8_buffer.is_7_bit_string (a_utf_8) then
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
		do
			Result := Utf_8_buffer
			Result.set_from_general (str)
			if keeping_ref then
				Result := Result.twin
			end
		end

	as_upper (code: NATURAL): NATURAL
		do
			Result := code.to_character_32.as_upper.natural_32_code
		end

	latin_character (uc: CHARACTER_32; unicode: INTEGER): CHARACTER
			--
		do
		end

feature -- Character query

	is_alpha (code: NATURAL): BOOLEAN
		do
			Result := code.to_character_32.is_alpha
		end

	is_lower (code: NATURAL): BOOLEAN
		do
			Result := code.to_character_32.is_lower
		end

	is_numeric (code: NATURAL): BOOLEAN
		do
			Result := Char_32.is_digit (code.to_character_32)
		end

	is_upper (code: NATURAL): BOOLEAN
		do
			Result := code.to_character_32.is_upper
		end

	unicode_case_change_substitute (code: NATURAL): CHARACTER_32
		do
		end

feature -- Constants

	Utf_8_buffer: EL_UTF_8_STRING
		once
			create Result.make (100)
		end

end