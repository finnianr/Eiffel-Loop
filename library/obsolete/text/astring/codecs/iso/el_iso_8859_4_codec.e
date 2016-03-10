note
	description: "Codec for ISO_8859_4 automatically generated from decoder.c in VTD-XML source"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "4"

class
	EL_ISO_8859_4_CODEC

inherit
	EL_ISO_8859_CODEC

create
	make

feature {NONE} -- Initialization

	initialize_latin_sets
		do
			latin_set_1 := latin_set_from_array (<<
				172, -- 'Ŧ'
				188, -- 'ŧ'
				221, -- 'Ũ'
				253, -- 'ũ'
				222, -- 'Ū'
				254  -- 'ū'
			>>)
			latin_set_2 := latin_set_from_array (<<
				204, -- 'Ė'
				236, -- 'ė'
				202, -- 'Ę'
				234  -- 'ę'
			>>)
			latin_set_3 := latin_set_from_array (<<
				208, -- 'Đ'
				240, -- 'đ'
				170, -- 'Ē'
				186  -- 'ē'
			>>)
			latin_set_4 := latin_set_from_array (<<
				165, -- 'Ĩ'
				181, -- 'ĩ'
				207, -- 'Ī'
				239  -- 'ī'
			>>)
			latin_set_5 := latin_set_from_array (<<
				189, -- 'Ŋ'
				191, -- 'ŋ'
				210, -- 'Ō'
				242  -- 'ō'
			>>)
			latin_set_6 := latin_set_from_array (<<
				211, -- 'Ķ'
				243, -- 'ķ'
				162  -- 'ĸ'
			>>)
			latin_set_7 := latin_set_from_array (<<
				163, -- 'Ŗ'
				179  -- 'ŗ'
			>>)
			latin_set_8 := latin_set_from_array (<<
				217, -- 'Ų'
				249  -- 'ų'
			>>)
			latin_set_9 := latin_set_from_array (<<
				174, -- 'Ž'
				190  -- 'ž'
			>>)
			latin_set_10 := latin_set_from_array (<<
				169, -- 'Š'
				185  -- 'š'
			>>)
			latin_set_11 := latin_set_from_array (<<
				171, -- 'Ģ'
				187  -- 'ģ'
			>>)
			latin_set_12 := latin_set_from_array (<<
				200, -- 'Č'
				232  -- 'č'
			>>)
			latin_set_13 := latin_set_from_array (<<
				161, -- 'Ą'
				177  -- 'ą'
			>>)
			latin_set_14 := latin_set_from_array (<<
				209, -- 'Ņ'
				241  -- 'ņ'
			>>)
			latin_set_15 := latin_set_from_array (<<
				192, -- 'Ā'
				224  -- 'ā'
			>>)
			latin_set_16 := latin_set_from_array (<<
				166, -- 'Ļ'
				182  -- 'ļ'
			>>)
			latin_set_17 := latin_set_from_array (<<
				199, -- 'Į'
				231  -- 'į'
			>>)
		end

feature -- Access

	id: INTEGER = 4

feature -- Conversion

	as_upper (code: NATURAL): NATURAL
		local
			offset: NATURAL
		do
			inspect code
				when 97..122, 224..246, 248..254 then
					offset := 32
				when 177, 179, 181..182, 185..188, 190 then
					offset := 16
				when 191 then
					offset := 2

			else end
			Result := code - offset
		end

	as_lower (code: NATURAL): NATURAL
		local
			offset: NATURAL
		do
			inspect code
				when 65..90, 192..214, 216..222 then
					offset := 32
				when 161, 163, 165..166, 169..172, 174 then
					offset := 16
				when 189 then
					offset := 2

			else end
			Result := code + offset
		end

	unicode_case_change_substitute (code: NATURAL): CHARACTER_32
			-- Returns Unicode case change character if c does not have a latin case change
			-- or else the Null character
		do
		end

	latin_character (uc: CHARACTER_32; unicode: INTEGER): CHARACTER
			-- unicode to latin translation
			-- Returns '%U' if translation is the same as ISO-8859-1 or else not in ISO_8859_4
		do
			inspect uc
				when 'Ŧ'..'ū' then
					Result := latin_set_1 [unicode - 358]
				when 'Ė'..'ę' then
					Result := latin_set_2 [unicode - 278]
				when 'Đ'..'ē' then
					Result := latin_set_3 [unicode - 272]
				when 'Ĩ'..'ī' then
					Result := latin_set_4 [unicode - 296]
				when 'Ŋ'..'ō' then
					Result := latin_set_5 [unicode - 330]
				when 'Ķ'..'ĸ' then
					Result := latin_set_6 [unicode - 310]
				when 'Ŗ'..'ŗ' then
					Result := latin_set_7 [unicode - 342]
				when 'Ų'..'ų' then
					Result := latin_set_8 [unicode - 370]
				when 'Ž'..'ž' then
					Result := latin_set_9 [unicode - 381]
				when 'Š'..'š' then
					Result := latin_set_10 [unicode - 352]
				when 'Ģ'..'ģ' then
					Result := latin_set_11 [unicode - 290]
				when 'Č'..'č' then
					Result := latin_set_12 [unicode - 268]
				when 'Ą'..'ą' then
					Result := latin_set_13 [unicode - 260]
				when 'Ņ'..'ņ' then
					Result := latin_set_14 [unicode - 325]
				when 'Ā'..'ā' then
					Result := latin_set_15 [unicode - 256]
				when 'Ļ'..'ļ' then
					Result := latin_set_16 [unicode - 315]
				when 'Į'..'į' then
					Result := latin_set_17 [unicode - 302]
				when '˛' then
					Result := '%/178/'
				when 'ˇ' then
					Result := '%/183/'
				when '˙' then
					Result := '%/255/'
			else end
		end

feature -- Character query

	is_alpha (code: NATURAL): BOOLEAN
		do
			inspect code 
				when 65..90, 97..122, 161..163, 165..166, 169..172, 174, 177, 179, 181..182, 185..214, 216..246, 248..254 then
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
				when 97..122, 224..246, 248..254, 177, 179, 181..182, 185..188, 190, 191 then
					Result := True
			else
			end
		end

	is_lower (code: NATURAL): BOOLEAN
		do
			inspect code 
				when 65..90, 192..214, 216..222, 161, 163, 165..166, 169..172, 174, 189 then
					Result := True

				-- Characters which are only available in a single case
				when 162, 223 then
					Result := True

			else
			end
		end

feature {NONE} -- Implementation

	create_unicode_table: SPECIAL [CHARACTER_32]
			-- Unicode value indexed by ISO_8859_4 character values
		do
			Result := single_byte_unicode_chars
			Result [0xA0] := ' ' -- 
			Result [0xA1] := 'Ą' -- 
			Result [0xA2] := 'ĸ' -- 
			Result [0xA3] := 'Ŗ' -- 
			Result [0xA4] := '¤' -- 
			Result [0xA5] := 'Ĩ' -- 
			Result [0xA6] := 'Ļ' -- 
			Result [0xA7] := '§' -- 
			Result [0xA8] := '¨' -- 
			Result [0xA9] := 'Š' -- 
			Result [0xAA] := 'Ē' -- 
			Result [0xAB] := 'Ģ' -- 
			Result [0xAC] := 'Ŧ' -- 
			Result [0xAD] := '­' -- 
			Result [0xAE] := 'Ž' -- 
			Result [0xAF] := '¯' -- 
			Result [0xB0] := '°' -- 
			Result [0xB1] := 'ą' -- 
			Result [0xB2] := '˛' -- 
			Result [0xB3] := 'ŗ' -- 
			Result [0xB4] := '´' -- 
			Result [0xB5] := 'ĩ' -- 
			Result [0xB6] := 'ļ' -- 
			Result [0xB7] := 'ˇ' -- 
			Result [0xB8] := '¸' -- 
			Result [0xB9] := 'š' -- 
			Result [0xBA] := 'ē' -- 
			Result [0xBB] := 'ģ' -- 
			Result [0xBC] := 'ŧ' -- 
			Result [0xBD] := 'Ŋ' -- 
			Result [0xBE] := 'ž' -- 
			Result [0xBF] := 'ŋ' -- 
			Result [0xC0] := 'Ā' -- 
			Result [0xC1] := 'Á' -- 
			Result [0xC2] := 'Â' -- 
			Result [0xC3] := 'Ã' -- 
			Result [0xC4] := 'Ä' -- 
			Result [0xC5] := 'Å' -- 
			Result [0xC6] := 'Æ' -- 
			Result [0xC7] := 'Į' -- 
			Result [0xC8] := 'Č' -- 
			Result [0xC9] := 'É' -- 
			Result [0xCA] := 'Ę' -- 
			Result [0xCB] := 'Ë' -- 
			Result [0xCC] := 'Ė' -- 
			Result [0xCD] := 'Í' -- 
			Result [0xCE] := 'Î' -- 
			Result [0xCF] := 'Ī' -- 
			Result [0xD0] := 'Đ' -- 
			Result [0xD1] := 'Ņ' -- 
			Result [0xD2] := 'Ō' -- 
			Result [0xD3] := 'Ķ' -- 
			Result [0xD4] := 'Ô' -- 
			Result [0xD5] := 'Õ' -- 
			Result [0xD6] := 'Ö' -- 
			Result [0xD7] := '×' -- 
			Result [0xD8] := 'Ø' -- 
			Result [0xD9] := 'Ų' -- 
			Result [0xDA] := 'Ú' -- 
			Result [0xDB] := 'Û' -- 
			Result [0xDC] := 'Ü' -- 
			Result [0xDD] := 'Ũ' -- 
			Result [0xDE] := 'Ū' -- 
			Result [0xDF] := 'ß' -- 
			Result [0xE0] := 'ā' -- 
			Result [0xE1] := 'á' -- 
			Result [0xE2] := 'â' -- 
			Result [0xE3] := 'ã' -- 
			Result [0xE4] := 'ä' -- 
			Result [0xE5] := 'å' -- 
			Result [0xE6] := 'æ' -- 
			Result [0xE7] := 'į' -- 
			Result [0xE8] := 'č' -- 
			Result [0xE9] := 'é' -- 
			Result [0xEA] := 'ę' -- 
			Result [0xEB] := 'ë' -- 
			Result [0xEC] := 'ė' -- 
			Result [0xED] := 'í' -- 
			Result [0xEE] := 'î' -- 
			Result [0xEF] := 'ī' -- 
			Result [0xF0] := 'đ' -- 
			Result [0xF1] := 'ņ' -- 
			Result [0xF2] := 'ō' -- 
			Result [0xF3] := 'ķ' -- 
			Result [0xF4] := 'ô' -- 
			Result [0xF5] := 'õ' -- 
			Result [0xF6] := 'ö' -- 
			Result [0xF7] := '÷' -- 
			Result [0xF8] := 'ø' -- 
			Result [0xF9] := 'ų' -- 
			Result [0xFA] := 'ú' -- 
			Result [0xFB] := 'û' -- 
			Result [0xFC] := 'ü' -- 
			Result [0xFD] := 'ũ' -- 
			Result [0xFE] := 'ū' -- 
			Result [0xFF] := '˙' -- 
		end

	latin_set_1: SPECIAL [CHARACTER]

	latin_set_2: SPECIAL [CHARACTER]

	latin_set_3: SPECIAL [CHARACTER]

	latin_set_4: SPECIAL [CHARACTER]

	latin_set_5: SPECIAL [CHARACTER]

	latin_set_6: SPECIAL [CHARACTER]

	latin_set_7: SPECIAL [CHARACTER]

	latin_set_8: SPECIAL [CHARACTER]

	latin_set_9: SPECIAL [CHARACTER]

	latin_set_10: SPECIAL [CHARACTER]

	latin_set_11: SPECIAL [CHARACTER]

	latin_set_12: SPECIAL [CHARACTER]

	latin_set_13: SPECIAL [CHARACTER]

	latin_set_14: SPECIAL [CHARACTER]

	latin_set_15: SPECIAL [CHARACTER]

	latin_set_16: SPECIAL [CHARACTER]

	latin_set_17: SPECIAL [CHARACTER]

end
