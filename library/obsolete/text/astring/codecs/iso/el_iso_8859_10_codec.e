note
	description: "Codec for ISO_8859_10 automatically generated from decoder.c in VTD-XML source"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "4"

class
	EL_ISO_8859_10_CODEC

inherit
	EL_ISO_8859_CODEC

create
	make

feature {NONE} -- Initialization

	initialize_latin_sets
		do
			latin_set_1 := latin_set_from_array (<<
				171, -- 'Ŧ'
				187, -- 'ŧ'
				215, -- 'Ũ'
				247, -- 'ũ'
				174, -- 'Ū'
				190  -- 'ū'
			>>)
			latin_set_2 := latin_set_from_array (<<
				165, -- 'Ĩ'
				181, -- 'ĩ'
				164, -- 'Ī'
				180  -- 'ī'
			>>)
			latin_set_3 := latin_set_from_array (<<
				175, -- 'Ŋ'
				191, -- 'ŋ'
				210, -- 'Ō'
				242  -- 'ō'
			>>)
			latin_set_4 := latin_set_from_array (<<
				204, -- 'Ė'
				236, -- 'ė'
				202, -- 'Ę'
				234  -- 'ę'
			>>)
			latin_set_5 := latin_set_from_array (<<
				169, -- 'Đ'
				185, -- 'đ'
				162, -- 'Ē'
				178  -- 'ē'
			>>)
			latin_set_6 := latin_set_from_array (<<
				166, -- 'Ķ'
				182, -- 'ķ'
				255  -- 'ĸ'
			>>)
			latin_set_7 := latin_set_from_array (<<
				170, -- 'Š'
				186  -- 'š'
			>>)
			latin_set_8 := latin_set_from_array (<<
				200, -- 'Č'
				232  -- 'č'
			>>)
			latin_set_9 := latin_set_from_array (<<
				161, -- 'Ą'
				177  -- 'ą'
			>>)
			latin_set_10 := latin_set_from_array (<<
				172, -- 'Ž'
				188  -- 'ž'
			>>)
			latin_set_11 := latin_set_from_array (<<
				192, -- 'Ā'
				224  -- 'ā'
			>>)
			latin_set_12 := latin_set_from_array (<<
				217, -- 'Ų'
				249  -- 'ų'
			>>)
			latin_set_13 := latin_set_from_array (<<
				199, -- 'Į'
				231  -- 'į'
			>>)
			latin_set_14 := latin_set_from_array (<<
				163, -- 'Ģ'
				179  -- 'ģ'
			>>)
			latin_set_15 := latin_set_from_array (<<
				209, -- 'Ņ'
				241  -- 'ņ'
			>>)
		end

feature -- Access

	id: INTEGER = 10

feature -- Conversion

	as_upper (code: NATURAL): NATURAL
		local
			offset: NATURAL
		do
			inspect code
				when 97..122, 224..254 then
					offset := 32
				when 177..182, 185..188, 190..191 then
					offset := 16

			else end
			Result := code - offset
		end

	as_lower (code: NATURAL): NATURAL
		local
			offset: NATURAL
		do
			inspect code
				when 65..90, 192..222 then
					offset := 32
				when 161..166, 169..172, 174..175 then
					offset := 16

			else end
			Result := code + offset
		end

	unicode_case_change_substitute (code: NATURAL): CHARACTER_32
			-- Returns Unicode case change character if c does not have a latin case change
			-- or else the Null character
		do
			inspect code
				-- Ļ -> ļ
				when 168 then
					Result := 'ļ'
			else end
		end

	latin_character (uc: CHARACTER_32; unicode: INTEGER): CHARACTER
			-- unicode to latin translation
			-- Returns '%U' if translation is the same as ISO-8859-1 or else not in ISO_8859_10
		do
			inspect uc
				when 'Ŧ'..'ū' then
					Result := latin_set_1 [unicode - 358]
				when 'Ĩ'..'ī' then
					Result := latin_set_2 [unicode - 296]
				when 'Ŋ'..'ō' then
					Result := latin_set_3 [unicode - 330]
				when 'Ė'..'ę' then
					Result := latin_set_4 [unicode - 278]
				when 'Đ'..'ē' then
					Result := latin_set_5 [unicode - 272]
				when 'Ķ'..'ĸ' then
					Result := latin_set_6 [unicode - 310]
				when 'Š'..'š' then
					Result := latin_set_7 [unicode - 352]
				when 'Č'..'č' then
					Result := latin_set_8 [unicode - 268]
				when 'Ą'..'ą' then
					Result := latin_set_9 [unicode - 260]
				when 'Ž'..'ž' then
					Result := latin_set_10 [unicode - 381]
				when 'Ā'..'ā' then
					Result := latin_set_11 [unicode - 256]
				when 'Ų'..'ų' then
					Result := latin_set_12 [unicode - 370]
				when 'Į'..'į' then
					Result := latin_set_13 [unicode - 302]
				when 'Ģ'..'ģ' then
					Result := latin_set_14 [unicode - 290]
				when 'Ņ'..'ņ' then
					Result := latin_set_15 [unicode - 325]
				when 'Ļ' then
					Result := '%/168/'
				when '―' then
					Result := '%/189/'
			else end
		end

feature -- Character query

	is_alpha (code: NATURAL): BOOLEAN
		do
			inspect code 
				when 65..90, 97..122, 161..166, 168..172, 174..175, 177..182, 185..188, 190..255 then
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
				when 97..122, 224..254, 177..182, 185..188, 190..191 then
					Result := True
			else
			end
		end

	is_lower (code: NATURAL): BOOLEAN
		do
			inspect code 
				when 65..90, 192..222, 161..166, 169..172, 174..175 then
					Result := True

				-- Characters which are only available in a single case
				when 168, 223, 255 then
					Result := True

			else
			end
		end

feature {NONE} -- Implementation

	create_unicode_table: SPECIAL [CHARACTER_32]
			-- Unicode value indexed by ISO_8859_10 character values
		do
			Result := single_byte_unicode_chars
			Result [0xA0] := ' ' -- 
			Result [0xA1] := 'Ą' -- 
			Result [0xA2] := 'Ē' -- 
			Result [0xA3] := 'Ģ' -- 
			Result [0xA4] := 'Ī' -- 
			Result [0xA5] := 'Ĩ' -- 
			Result [0xA6] := 'Ķ' -- 
			Result [0xA7] := '§' -- 
			Result [0xA8] := 'Ļ' -- 
			Result [0xA9] := 'Đ' -- 
			Result [0xAA] := 'Š' -- 
			Result [0xAB] := 'Ŧ' -- 
			Result [0xAC] := 'Ž' -- 
			Result [0xAD] := '­' -- 
			Result [0xAE] := 'Ū' -- 
			Result [0xAF] := 'Ŋ' -- 
			Result [0xB0] := '°' -- 
			Result [0xB1] := 'ą' -- 
			Result [0xB2] := 'ē' -- 
			Result [0xB3] := 'ģ' -- 
			Result [0xB4] := 'ī' -- 
			Result [0xB5] := 'ĩ' -- 
			Result [0xB6] := 'ķ' -- 
			Result [0xB7] := '·' -- 
			Result [0xB9] := 'đ' -- 
			Result [0xBA] := 'š' -- 
			Result [0xBB] := 'ŧ' -- 
			Result [0xBC] := 'ž' -- 
			Result [0xBD] := '―' -- 
			Result [0xBE] := 'ū' -- 
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
			Result [0xCF] := 'Ï' -- 
			Result [0xD0] := 'Ð' -- 
			Result [0xD1] := 'Ņ' -- 
			Result [0xD2] := 'Ō' -- 
			Result [0xD3] := 'Ó' -- 
			Result [0xD4] := 'Ô' -- 
			Result [0xD5] := 'Õ' -- 
			Result [0xD6] := 'Ö' -- 
			Result [0xD7] := 'Ũ' -- 
			Result [0xD8] := 'Ø' -- 
			Result [0xD9] := 'Ų' -- 
			Result [0xDA] := 'Ú' -- 
			Result [0xDB] := 'Û' -- 
			Result [0xDC] := 'Ü' -- 
			Result [0xDD] := 'Ý' -- 
			Result [0xDE] := 'Þ' -- 
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
			Result [0xEF] := 'ï' -- 
			Result [0xF0] := 'ð' -- 
			Result [0xF1] := 'ņ' -- 
			Result [0xF2] := 'ō' -- 
			Result [0xF3] := 'ó' -- 
			Result [0xF4] := 'ô' -- 
			Result [0xF5] := 'õ' -- 
			Result [0xF6] := 'ö' -- 
			Result [0xF7] := 'ũ' -- 
			Result [0xF8] := 'ø' -- 
			Result [0xF9] := 'ų' -- 
			Result [0xFA] := 'ú' -- 
			Result [0xFB] := 'û' -- 
			Result [0xFC] := 'ü' -- 
			Result [0xFD] := 'ý' -- 
			Result [0xFE] := 'þ' -- 
			Result [0xFF] := 'ĸ' -- 
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

end
