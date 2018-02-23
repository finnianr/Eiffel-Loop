note
	description: "Summary description for {EL_UTF_8_ZCODEC}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_UTF_8_ZCODEC

inherit
	EL_ZCODEC
		rename
			single_byte_unicode_chars as new_unicode_table
		redefine
			as_unicode, write_encoded, write_encoded_character
		end

	EL_MODULE_CHARACTER

	EL_MODULE_STRING_32

	EL_MODULE_UTF

create
	make

feature {NONE} -- Initialization

	initialize_latin_sets
		do
		end

feature -- Basic operations

	write_encoded (unicode_in: READABLE_STRING_GENERAL; writeable: EL_WRITEABLE)
		do
			String_32.write_utf_8 (unicode_in, writeable)
		end

	write_encoded_character (uc: CHARACTER_32; writeable: EL_WRITEABLE)
		do
			Character.write_utf_8 (uc, writeable)
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

	as_unicode (utf_encoded: STRING): STRING_32
		-- returns `utf_encoded' string as unicode
		-- (if you are keeping a reference make sure to twin the result)
		do
			Result := Unicode_buffer
			Result.wipe_out
			UTF.utf_8_string_8_into_string_32 (utf_encoded, Result)
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
			Result := code.to_character_32.is_digit
		end

	is_upper (code: NATURAL): BOOLEAN
		do
			Result := code.to_character_32.is_upper
		end

	unicode_case_change_substitute (code: NATURAL): CHARACTER_32
		do
		end

end
