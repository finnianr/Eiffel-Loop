note
	description: "Converts to and from UTF-8"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-07 8:47:21 GMT (Thursday 7th May 2020)"
	revision: "6"

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

	EL_UTF_CONVERTER
		rename
			utf_32_string_into_utf_8_string_8 as write_string_general_to_utf_8
		export
			{NONE} all
			{ANY} write_string_general_to_utf_8, is_valid_utf_8_string_8
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

	append_general_to_utf_8 (general_in: READABLE_STRING_GENERAL; utf_8_out: STRING)
		local
			str_32: STRING_32
		do
			str_32 := Unicode_buffer; str_32.wipe_out
			if attached {EL_READABLE_ZSTRING} general_in as zstring_in then
				zstring_in.append_to_string_32 (str_32)
			else
				str_32.append_string_general (general_in)
			end
			utf_8_out.grow (utf_8_out.count + utf_8_bytes_count (str_32, 1, str_32.count))
			string_32_into_utf_8_string_8 (str_32, utf_8_out)
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

	as_unicode (a_utf_8: STRING; keeping_ref: BOOLEAN): READABLE_STRING_GENERAL
		-- returns `utf_8' string as unicode
		-- when keeping a reference to `Result' specify `keeping_ref' as `True'
		local
			str_32: STRING_32
		do
			if is_single_byte_utf_8 (a_utf_8) then
				Result := a_utf_8
			else
				str_32 := Unicode_buffer
				str_32.wipe_out
				utf_8_string_8_into_string_32 (a_utf_8, str_32)
				Result := str_32
			end
			if keeping_ref then
				Result := Result.twin
			end
		end

	as_utf_8 (str: READABLE_STRING_GENERAL; keeping_ref: BOOLEAN): STRING
		-- returns general string `str' as UTF-8 encoded string
		-- when keeping a reference to `Result' specify `keeping_ref' as `True'
		do
			Result := Utf_8_buffer; Result.wipe_out
			write_string_general_to_utf_8 (str, Result)
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

feature {NONE} -- Implementation

	is_single_byte_utf_8 (a_utf_8: STRING): BOOLEAN
		local
			l_area: SPECIAL [CHARACTER_8]; i: INTEGER
		do
			l_area := a_utf_8.area; Result := True
			from i := 0 until not Result or i = l_area.count loop
				if l_area [i] > '%/127/' then
					Result := False
				end
				i := i + 1
			end
		end

feature -- Constants

	Utf_8_buffer: STRING
		once
			create Result.make (100)
		end
end
