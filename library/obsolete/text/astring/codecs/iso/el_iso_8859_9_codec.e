note
	description: "Codec for ISO_8859_9 automatically generated from decoder.c in VTD-XML source"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "4"

class
	EL_ISO_8859_9_CODEC

inherit
	EL_ISO_8859_CODEC

create
	make

feature {NONE} -- Initialization

	initialize_latin_sets
		do
			latin_set_1 := latin_set_from_array (<<
				222, -- 'Ş'
				254  -- 'ş'
			>>)
			latin_set_2 := latin_set_from_array (<<
				221, -- 'İ'
				253  -- 'ı'
			>>)
			latin_set_3 := latin_set_from_array (<<
				208, -- 'Ğ'
				240  -- 'ğ'
			>>)
		end

feature -- Access

	id: INTEGER = 9

feature -- Conversion

	as_upper (code: NATURAL): NATURAL
		local
			offset: NATURAL
		do
			inspect code
				when 97..122, 224..246, 248..252, 254 then
					offset := 32
				when 253 then
					offset := 180

			else end
			Result := code - offset
		end

	as_lower (code: NATURAL): NATURAL
		local
			offset: NATURAL
		do
			inspect code
				when 65..90, 192..214, 216..220, 222 then
					offset := 32
				when 221 then
					offset := 116

			else end
			Result := code + offset
		end

	unicode_case_change_substitute (code: NATURAL): CHARACTER_32
			-- Returns Unicode case change character if c does not have a latin case change
			-- or else the Null character
		do
			inspect code
				-- µ -> Μ
				when 181 then
					Result := 'Μ'
				-- ÿ -> Ÿ
				when 255 then
					Result := 'Ÿ'
			else end
		end

	latin_character (uc: CHARACTER_32; unicode: INTEGER): CHARACTER
			-- unicode to latin translation
			-- Returns '%U' if translation is the same as ISO-8859-1 or else not in ISO_8859_9
		do
			inspect uc
				when 'Ş'..'ş' then
					Result := latin_set_1 [unicode - 350]
				when 'İ'..'ı' then
					Result := latin_set_2 [unicode - 304]
				when 'Ğ'..'ğ' then
					Result := latin_set_3 [unicode - 286]
			else end
		end

feature -- Character query

	is_alpha (code: NATURAL): BOOLEAN
		do
			inspect code 
				when 65..90, 97..122, 181, 192..214, 216..246, 248..255 then
					Result := True
			else
			end
		end

	is_numeric (code: NATURAL): BOOLEAN
		do
			inspect code 
				when 48..57 then
					Result := True
			else
			end
		end

	is_upper (code: NATURAL): BOOLEAN
		do
			inspect code 
				when 97..122, 224..246, 248..252, 254, 253 then
					Result := True
			else
			end
		end

	is_lower (code: NATURAL): BOOLEAN
		do
			inspect code 
				when 65..90, 192..214, 216..220, 222, 221 then
					Result := True

				-- Characters which are only available in a single case
				when 181, 223, 255 then
					Result := True

			else
			end
		end

feature {NONE} -- Implementation

	create_unicode_table: SPECIAL [CHARACTER_32]
			-- Unicode value indexed by ISO_8859_9 character values
		do
			Result := single_byte_unicode_chars
			Result [0xA0] := ' ' -- 
			Result [0xA1] := '¡' -- 
			Result [0xA2] := '¢' -- 
			Result [0xA3] := '£' -- 
			Result [0xA4] := '¤' -- 
			Result [0xA5] := '¥' -- 
			Result [0xA6] := '¦' -- 
			Result [0xA7] := '§' -- 
			Result [0xA8] := '¨' -- 
			Result [0xA9] := '©' -- 
			Result [0xAA] := 'ª' -- 
			Result [0xAB] := '«' -- 
			Result [0xAC] := '¬' -- 
			Result [0xAD] := '­' -- 
			Result [0xAE] := '®' -- 
			Result [0xAF] := '¯' -- 
			Result [0xB0] := '°' -- 
			Result [0xB1] := '±' -- 
			Result [0xB2] := '²' -- 
			Result [0xB3] := '³' -- 
			Result [0xB4] := '´' -- 
			Result [0xB5] := 'µ' -- 
			Result [0xB6] := '¶' -- 
			Result [0xB7] := '·' -- 
			Result [0xB8] := '¸' -- 
			Result [0xB9] := '¹' -- 
			Result [0xBA] := 'º' -- 
			Result [0xBB] := '»' -- 
			Result [0xBC] := '¼' -- 
			Result [0xBD] := '½' -- 
			Result [0xBE] := '¾' -- 
			Result [0xBF] := '¿' -- 
			Result [0xC0] := 'À' -- 
			Result [0xC1] := 'Á' -- 
			Result [0xC2] := 'Â' -- 
			Result [0xC3] := 'Ã' -- 
			Result [0xC4] := 'Ä' -- 
			Result [0xC5] := 'Å' -- 
			Result [0xC6] := 'Æ' -- 
			Result [0xC7] := 'Ç' -- 
			Result [0xC8] := 'È' -- 
			Result [0xC9] := 'É' -- 
			Result [0xCA] := 'Ê' -- 
			Result [0xCB] := 'Ë' -- 
			Result [0xCC] := 'Ì' -- 
			Result [0xCD] := 'Í' -- 
			Result [0xCE] := 'Î' -- 
			Result [0xCF] := 'Ï' -- 
			Result [0xD0] := 'Ğ' -- 
			Result [0xD1] := 'Ñ' -- 
			Result [0xD2] := 'Ò' -- 
			Result [0xD3] := 'Ó' -- 
			Result [0xD4] := 'Ô' -- 
			Result [0xD5] := 'Õ' -- 
			Result [0xD6] := 'Ö' -- 
			Result [0xD7] := '×' -- 
			Result [0xD8] := 'Ø' -- 
			Result [0xD9] := 'Ù' -- 
			Result [0xDA] := 'Ú' -- 
			Result [0xDB] := 'Û' -- 
			Result [0xDC] := 'Ü' -- 
			Result [0xDD] := 'İ' -- 
			Result [0xDE] := 'Ş' -- 
			Result [0xDF] := 'ß' -- 
			Result [0xE0] := 'à' -- 
			Result [0xE1] := 'á' -- 
			Result [0xE2] := 'â' -- 
			Result [0xE3] := 'ã' -- 
			Result [0xE4] := 'ä' -- 
			Result [0xE5] := 'å' -- 
			Result [0xE6] := 'æ' -- 
			Result [0xE7] := 'ç' -- 
			Result [0xE8] := 'è' -- 
			Result [0xE9] := 'é' -- 
			Result [0xEA] := 'ê' -- 
			Result [0xEB] := 'ë' -- 
			Result [0xEC] := 'ì' -- 
			Result [0xED] := 'í' -- 
			Result [0xEE] := 'î' -- 
			Result [0xEF] := 'ï' -- 
			Result [0xF0] := 'ğ' -- 
			Result [0xF1] := 'ñ' -- 
			Result [0xF2] := 'ò' -- 
			Result [0xF3] := 'ó' -- 
			Result [0xF4] := 'ô' -- 
			Result [0xF5] := 'õ' -- 
			Result [0xF6] := 'ö' -- 
			Result [0xF7] := '÷' -- 
			Result [0xF8] := 'ø' -- 
			Result [0xF9] := 'ù' -- 
			Result [0xFA] := 'ú' -- 
			Result [0xFB] := 'û' -- 
			Result [0xFC] := 'ü' -- 
			Result [0xFD] := 'ı' -- 
			Result [0xFE] := 'ş' -- 
			Result [0xFF] := 'ÿ' -- 
		end

	latin_set_1: SPECIAL [CHARACTER]

	latin_set_2: SPECIAL [CHARACTER]

	latin_set_3: SPECIAL [CHARACTER]

end
