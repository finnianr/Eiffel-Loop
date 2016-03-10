note
	description: "Codec for ISO_8859_8 automatically generated from decoder.c in VTD-XML source"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-17 17:31:58 GMT (Wednesday 17th July 2013)"
	revision: "2"

class
	EL_ISO_8859_8_CODEC

inherit
	EL_ISO_8859_CODEC

create
	make

feature {NONE} -- Initialization

	initialize_latin_sets
		do
			latin_set_1 := latin_set_from_array (<<
				224, -- 'א'
				225, -- 'ב'
				226, -- 'ג'
				227, -- 'ד'
				228, -- 'ה'
				229, -- 'ו'
				230, -- 'ז'
				231, -- 'ח'
				232, -- 'ט'
				233, -- 'י'
				234, -- 'ך'
				235, -- 'כ'
				236, -- 'ל'
				237, -- 'ם'
				238, -- 'מ'
				239, -- 'ן'
				240, -- 'נ'
				241, -- 'ס'
				242, -- 'ע'
				243, -- 'ף'
				244, -- 'פ'
				245, -- 'ץ'
				246, -- 'צ'
				247, -- 'ק'
				248, -- 'ר'
				249, -- 'ש'
				250  -- 'ת'
			>>)
		end

feature -- Access

	id: INTEGER = 8

feature -- Conversion

	as_upper (code: NATURAL): NATURAL
		local
			offset: NATURAL
		do
			inspect code
				when 97..122, 251..254 then
					offset := 32

			else end
			Result := code - offset
		end

	as_lower (code: NATURAL): NATURAL
		local
			offset: NATURAL
		do
			inspect code
				when 65..90, 219..222 then
					offset := 32

			else end
			Result := code + offset
		end

	unicode_case_change_substitute (c: CHARACTER): CHARACTER_32
			-- Returns Unicode case change character if c does not have a latin case change
			-- or else the Null character
		do
			inspect c
				when 'µ' then
					Result := 'Μ'
				when 'À' then
					Result := 'à'
				when 'Á' then
					Result := 'á'
				when 'Â' then
					Result := 'â'
				when 'Ã' then
					Result := 'ã'
				when 'Ä' then
					Result := 'ä'
				when 'Å' then
					Result := 'å'
				when 'Æ' then
					Result := 'æ'
				when 'Ç' then
					Result := 'ç'
				when 'È' then
					Result := 'è'
				when 'É' then
					Result := 'é'
				when 'Ê' then
					Result := 'ê'
				when 'Ë' then
					Result := 'ë'
				when 'Ì' then
					Result := 'ì'
				when 'Í' then
					Result := 'í'
				when 'Î' then
					Result := 'î'
				when 'Ï' then
					Result := 'ï'
				when 'Ð' then
					Result := 'ð'
				when 'Ñ' then
					Result := 'ñ'
				when 'Ò' then
					Result := 'ò'
				when 'Ó' then
					Result := 'ó'
				when 'Ô' then
					Result := 'ô'
				when 'Õ' then
					Result := 'õ'
				when 'Ö' then
					Result := 'ö'
				when 'Ø' then
					Result := 'ø'
				when 'Ù' then
					Result := 'ù'
				when 'Ú' then
					Result := 'ú'
				when 'ÿ' then
					Result := 'Ÿ'
			else end
		end

	latin_character (uc: CHARACTER_32; unicode: INTEGER): CHARACTER
			-- unicode to latin translation
			-- Returns '%U' if translation is the same as ISO-8859-1 or else not in ISO_8859_8
		do
			inspect uc
				when 'א'..'ת' then
					Result := latin_set_1 [unicode - 1488]
				when '‾' then
					Result := '%/175/'
				when '‗' then
					Result := '%/223/'
				when '÷' then
					Result := '%/186/'
				when '×' then
					Result := '%/170/'
			else end
		end

feature -- Character query

	is_alpha (code: NATURAL): BOOLEAN
		do
			inspect code 
				when 65..90, 97..122, 181, 192..214, 216..222, 251..255 then
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
				when 97..122, 251..254 then
					Result := True
			else
			end
		end

	is_lower (code: NATURAL): BOOLEAN
		do
			inspect code 
				when 65..90, 219..222 then
					Result := True

				-- Characters which are only available in a single case
				when 181, 192, 193, 194, 195, 196, 197, 198, 199, 200, 201, 202, 203, 204, 205, 206, 207, 208, 209, 210, 211, 212, 213, 214, 216, 217, 218, 255 then
					Result := True

			else
			end
		end

feature {NONE} -- Implementation

	create_unicode_table: SPECIAL [CHARACTER_32]
			-- Unicode value indexed by ISO_8859_8 character values
		do
			Result := single_byte_unicode_chars
			Result [0xAA] := '×' -- 
			Result [0xAB] := '«' -- 
			Result [0xAC] := '¬' -- 
			Result [0xAD] := '­' -- 
			Result [0xAE] := '®' -- 
			Result [0xAF] := '‾' -- 
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
			Result [0xBA] := '÷' -- 
			Result [0xBB] := '»' -- 
			Result [0xBC] := '¼' -- 
			Result [0xBD] := '½' -- 
			Result [0xBE] := '¾' -- 
			Result [0xDF] := '‗' -- 
			Result [0xE0] := 'א' -- 
			Result [0xE1] := 'ב' -- 
			Result [0xE2] := 'ג' -- 
			Result [0xE3] := 'ד' -- 
			Result [0xE4] := 'ה' -- 
			Result [0xE5] := 'ו' -- 
			Result [0xE6] := 'ז' -- 
			Result [0xE7] := 'ח' -- 
			Result [0xE8] := 'ט' -- 
			Result [0xE9] := 'י' -- 
			Result [0xEA] := 'ך' -- 
			Result [0xEB] := 'כ' -- 
			Result [0xEC] := 'ל' -- 
			Result [0xED] := 'ם' -- 
			Result [0xEE] := 'מ' -- 
			Result [0xEF] := 'ן' -- 
			Result [0xF0] := 'נ' -- 
			Result [0xF1] := 'ס' -- 
			Result [0xF2] := 'ע' -- 
			Result [0xF3] := 'ף' -- 
			Result [0xF4] := 'פ' -- 
			Result [0xF5] := 'ץ' -- 
			Result [0xF6] := 'צ' -- 
			Result [0xF7] := 'ק' -- 
			Result [0xF8] := 'ר' -- 
			Result [0xF9] := 'ש' -- 
			Result [0xFA] := 'ת' -- 
		end

	latin_set_1: SPECIAL [CHARACTER]

end
