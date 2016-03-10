note
	description: "Codec for ISO_8859_2 automatically generated from decoder.c in VTD-XML source"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "4"

class
	EL_ISO_8859_2_CODEC

inherit
	EL_ISO_8859_CODEC

create
	make

feature {NONE} -- Initialization

	initialize_latin_sets
		do
			latin_set_1 := latin_set_from_array (<<
				170, -- 'Ş'
				186, -- 'ş'
				169, -- 'Š'
				185, -- 'š'
				222, -- 'Ţ'
				254, -- 'ţ'
				171, -- 'Ť'
				187  -- 'ť'
			>>)
			latin_set_2 := latin_set_from_array (<<
				172, -- 'Ź'
				188, -- 'ź'
				175, -- 'Ż'
				191, -- 'ż'
				174, -- 'Ž'
				190  -- 'ž'
			>>)
			latin_set_3 := latin_set_from_array (<<
				195, -- 'Ă'
				227, -- 'ă'
				161, -- 'Ą'
				177, -- 'ą'
				198, -- 'Ć'
				230  -- 'ć'
			>>)
			latin_set_4 := latin_set_from_array (<<
				200, -- 'Č'
				232, -- 'č'
				207, -- 'Ď'
				239, -- 'ď'
				208, -- 'Đ'
				240  -- 'đ'
			>>)
			latin_set_5 := latin_set_from_array (<<
				217, -- 'Ů'
				249, -- 'ů'
				219, -- 'Ű'
				251  -- 'ű'
			>>)
			latin_set_6 := latin_set_from_array (<<
				216, -- 'Ř'
				248, -- 'ř'
				166, -- 'Ś'
				182  -- 'ś'
			>>)
			latin_set_7 := latin_set_from_array (<<
				163, -- 'Ł'
				179, -- 'ł'
				209, -- 'Ń'
				241  -- 'ń'
			>>)
			latin_set_8 := latin_set_from_array (<<
				202, -- 'Ę'
				234, -- 'ę'
				204, -- 'Ě'
				236  -- 'ě'
			>>)
			latin_set_9 := latin_set_from_array (<<
				162, -- '˘'
				255  -- '˙'
			>>)
			latin_set_10 := latin_set_from_array (<<
				165, -- 'Ľ'
				181  -- 'ľ'
			>>)
			latin_set_11 := latin_set_from_array (<<
				192, -- 'Ŕ'
				224  -- 'ŕ'
			>>)
			latin_set_12 := latin_set_from_array (<<
				197, -- 'Ĺ'
				229  -- 'ĺ'
			>>)
			latin_set_13 := latin_set_from_array (<<
				210, -- 'Ň'
				242  -- 'ň'
			>>)
			latin_set_14 := latin_set_from_array (<<
				213, -- 'Ő'
				245  -- 'ő'
			>>)
		end

feature -- Access

	id: INTEGER = 2

feature -- Conversion

	as_upper (code: NATURAL): NATURAL
		local
			offset: NATURAL
		do
			inspect code
				when 97..122, 224..246, 248..254 then
					offset := 32
				when 177, 179, 181..182, 185..188, 190..191 then
					offset := 16

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
				when 161, 163, 165..166, 169..172, 174..175 then
					offset := 16

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
			-- Returns '%U' if translation is the same as ISO-8859-1 or else not in ISO_8859_2
		do
			inspect uc
				when 'Ş'..'ť' then
					Result := latin_set_1 [unicode - 350]
				when 'Ź'..'ž' then
					Result := latin_set_2 [unicode - 377]
				when 'Ă'..'ć' then
					Result := latin_set_3 [unicode - 258]
				when 'Č'..'đ' then
					Result := latin_set_4 [unicode - 268]
				when 'Ů'..'ű' then
					Result := latin_set_5 [unicode - 366]
				when 'Ř'..'ś' then
					Result := latin_set_6 [unicode - 344]
				when 'Ł'..'ń' then
					Result := latin_set_7 [unicode - 321]
				when 'Ę'..'ě' then
					Result := latin_set_8 [unicode - 280]
				when '˘'..'˙' then
					Result := latin_set_9 [unicode - 728]
				when 'Ľ'..'ľ' then
					Result := latin_set_10 [unicode - 317]
				when 'Ŕ'..'ŕ' then
					Result := latin_set_11 [unicode - 340]
				when 'Ĺ'..'ĺ' then
					Result := latin_set_12 [unicode - 313]
				when 'Ň'..'ň' then
					Result := latin_set_13 [unicode - 327]
				when 'Ő'..'ő' then
					Result := latin_set_14 [unicode - 336]
				when '˝' then
					Result := '%/189/'
				when '˛' then
					Result := '%/178/'
				when 'ˇ' then
					Result := '%/183/'
			else end
		end

feature -- Character query

	is_alpha (code: NATURAL): BOOLEAN
		do
			inspect code 
				when 65..90, 97..122, 161, 163, 165..166, 169..172, 174..175, 177, 179, 181..182, 185..188, 190..214, 216..246, 248..254 then
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
				when 97..122, 224..246, 248..254, 177, 179, 181..182, 185..188, 190..191 then
					Result := True
			else
			end
		end

	is_lower (code: NATURAL): BOOLEAN
		do
			inspect code 
				when 65..90, 192..214, 216..222, 161, 163, 165..166, 169..172, 174..175 then
					Result := True

				-- Characters which are only available in a single case
				when 223 then
					Result := True

			else
			end
		end

feature {NONE} -- Implementation

	create_unicode_table: SPECIAL [CHARACTER_32]
			-- Unicode value indexed by ISO_8859_2 character values
		do
			Result := single_byte_unicode_chars
			Result [0xA0] := ' ' -- NO-BREAK SPACE 
			Result [0xA1] := 'Ą' -- LATIN CAPITAL LETTER A WITH OGONEK
			Result [0xA2] := '˘' -- BREVE 
			Result [0xA3] := 'Ł' -- LATIN CAPITAL LETTER L WITH STROKE
			Result [0xA4] := '¤' -- CURRENCY SIGN
			Result [0xA5] := 'Ľ' -- LATIN CAPITAL LETTER L WITH CARON
			Result [0xA6] := 'Ś' -- LATIN CAPITAL LETTER S WITH ACUTE
			Result [0xA7] := '§' -- SECTION SIGN
			Result [0xA8] := '¨' -- DIAERESIS
			Result [0xA9] := 'Š' -- LATIN CAPITAL LETTER S WITH CARON
			Result [0xAA] := 'Ş' -- LATIN CAPITAL LETTER S WITH CEDILLA
			Result [0xAB] := 'Ť' -- LATIN CAPITAL LETTER T WITH CARON
			Result [0xAC] := 'Ź' -- LATIN CAPITAL LETTER Z WITH ACUTE
			Result [0xAD] := '­' -- SOFT HYPHEN
			Result [0xAE] := 'Ž' -- LATIN CAPITAL LETTER Z WITH CARON
			Result [0xAF] := 'Ż' -- LATIN CAPITAL LETTER Z WITH DOT ABOVE
			Result [0xB0] := '°' -- DEGREE SIGN
			Result [0xB1] := 'ą' -- LATIN SMALL LETTER A WITH OGONEK
			Result [0xB2] := '˛' -- OGONEK
			Result [0xB3] := 'ł' -- LATIN SMALL LETTER L WITH STROKE
			Result [0xB4] := '´' -- ACUTE ACCENT
			Result [0xB5] := 'ľ' -- LATIN SMALL LETTER L WITH CARON
			Result [0xB6] := 'ś' -- LATIN SMALL LETTER S WITH ACUTE
			Result [0xB7] := 'ˇ' -- CARON
			Result [0xB8] := '¸' -- CEDILLA
			Result [0xB9] := 'š' -- LATIN SMALL LETTER S WITH CARON
			Result [0xBA] := 'ş' -- LATIN SMALL LETTER S WITH CEDILLA
			Result [0xBB] := 'ť' -- LATIN SMALL LETTER T WITH CARON
			Result [0xBC] := 'ź' -- LATIN SMALL LETTER Z WITH ACUTE
			Result [0xBD] := '˝' -- DOUBLE ACUTE ACCENT
			Result [0xBE] := 'ž' -- LATIN SMALL LETTER Z WITH CARON
			Result [0xBF] := 'ż' -- LATIN SMALL LETTER Z WITH DOT ABOVE
			Result [0xC0] := 'Ŕ' -- LATIN CAPITAL LETTER R WITH ACUTE
			Result [0xC1] := 'Á' -- LATIN CAPITAL LETTER A WITH ACUTE
			Result [0xC2] := 'Â' -- LATIN CAPITAL LETTER A WITH CIRCUMFLEX
			Result [0xC3] := 'Ă' -- LATIN CAPITAL LETTER A WITH BREVE
			Result [0xC4] := 'Ä' -- LATIN CAPITAL LETTER A WITH DIAERESIS
			Result [0xC5] := 'Ĺ' -- LATIN CAPITAL LETTER L WITH ACUTE
			Result [0xC6] := 'Ć' -- LATIN CAPITAL LETTER C WITH ACUTE
			Result [0xC7] := 'Ç' -- LATIN CAPITAL LETTER C WITH CEDILLA
			Result [0xC8] := 'Č' -- LATIN CAPITAL LETTER C WITH CARON
			Result [0xC9] := 'É' -- LATIN CAPITAL LETTER E WITH ACUTE
			Result [0xCA] := 'Ę' -- LATIN CAPITAL LETTER E WITH OGONEK
			Result [0xCB] := 'Ë' -- LATIN CAPITAL LETTER E WITH DIAERESIS
			Result [0xCC] := 'Ě' -- LATIN CAPITAL LETTER E WITH CARON
			Result [0xCD] := 'Í' -- LATIN CAPITAL LETTER I WITH ACUTE
			Result [0xCE] := 'Î' -- LATIN CAPITAL LETTER I WITH CIRCUMFLEX
			Result [0xCF] := 'Ď' -- LATIN CAPITAL LETTER D WITH CARON
			Result [0xD0] := 'Đ' -- LATIN CAPITAL LETTER D WITH STROKE
			Result [0xD1] := 'Ń' -- LATIN CAPITAL LETTER N WITH ACUTE
			Result [0xD2] := 'Ň' -- LATIN CAPITAL LETTER N WITH CARON
			Result [0xD3] := 'Ó' -- LATIN CAPITAL LETTER O WITH ACUTE
			Result [0xD4] := 'Ô' -- LATIN CAPITAL LETTER O WITH CIRCUMFLEX
			Result [0xD5] := 'Ő' -- LATIN CAPITAL LETTER O WITH DOUBLE ACUTE
			Result [0xD6] := 'Ö' -- LATIN CAPITAL LETTER O WITH DIAERESIS
			Result [0xD7] := '×' -- MULTIPLICATION SIGN
			Result [0xD8] := 'Ř' -- LATIN CAPITAL LETTER R WITH CARON
			Result [0xD9] := 'Ů' -- LATIN CAPITAL LETTER U WITH RING ABOVE
			Result [0xDA] := 'Ú' -- LATIN CAPITAL LETTER U WITH ACUTE
			Result [0xDB] := 'Ű' -- LATIN CAPITAL LETTER U WITH DOUBLE ACUTE
			Result [0xDC] := 'Ü' -- LATIN CAPITAL LETTER U WITH DIAERESIS
			Result [0xDD] := 'Ý' -- LATIN CAPITAL LETTER Y WITH ACUTE
			Result [0xDE] := 'Ţ' -- LATIN CAPITAL LETTER T WITH CEDILLA
			Result [0xDF] := 'ß' -- LATIN SMALL LETTER SHARP S
			Result [0xE0] := 'ŕ' -- LATIN SMALL LETTER R WITH ACUTE
			Result [0xE1] := 'á' -- LATIN SMALL LETTER A WITH ACUTE
			Result [0xE2] := 'â' -- LATIN SMALL LETTER A WITH CIRCUMFLEX
			Result [0xE3] := 'ă' -- LATIN SMALL LETTER A WITH BREVE
			Result [0xE4] := 'ä' -- LATIN SMALL LETTER A WITH DIAERESIS
			Result [0xE5] := 'ĺ' -- LATIN SMALL LETTER L WITH ACUTE
			Result [0xE6] := 'ć' -- LATIN SMALL LETTER C WITH ACUTE
			Result [0xE7] := 'ç' -- LATIN SMALL LETTER C WITH CEDILLA
			Result [0xE8] := 'č' -- LATIN SMALL LETTER C WITH CARON
			Result [0xE9] := 'é' -- LATIN SMALL LETTER E WITH ACUTE
			Result [0xEA] := 'ę' -- LATIN SMALL LETTER E WITH OGONEK
			Result [0xEB] := 'ë' -- LATIN SMALL LETTER E WITH DIAERESIS
			Result [0xEC] := 'ě' -- LATIN SMALL LETTER E WITH CARON
			Result [0xED] := 'í' -- LATIN SMALL LETTER I WITH ACUTE
			Result [0xEE] := 'î' -- LATIN SMALL LETTER I WITH CIRCUMFLEX
			Result [0xEF] := 'ď' -- LATIN SMALL LETTER D WITH CARON
			Result [0xF0] := 'đ' -- LATIN SMALL LETTER D WITH STROKE
			Result [0xF1] := 'ń' -- LATIN SMALL LETTER N WITH ACUTE
			Result [0xF2] := 'ň' -- LATIN SMALL LETTER N WITH CARON
			Result [0xF3] := 'ó' -- LATIN SMALL LETTER O WITH ACUTE
			Result [0xF4] := 'ô' -- LATIN SMALL LETTER O WITH CIRCUMFLEX
			Result [0xF5] := 'ő' -- LATIN SMALL LETTER O WITH DOUBLE ACUTE
			Result [0xF6] := 'ö' -- LATIN SMALL LETTER O WITH DIAERESIS
			Result [0xF7] := '÷' -- DIVISION SIGN
			Result [0xF8] := 'ř' -- LATIN SMALL LETTER R WITH CARON
			Result [0xF9] := 'ů' -- LATIN SMALL LETTER U WITH RING ABOVE
			Result [0xFA] := 'ú' -- LATIN SMALL LETTER U WITH ACUTE
			Result [0xFB] := 'ű' -- LATIN SMALL LETTER U WITH DOUBLE ACUTE
			Result [0xFC] := 'ü' -- LATIN SMALL LETTER U WITH DIAERESIS
			Result [0xFD] := 'ý' -- LATIN SMALL LETTER Y WITH ACUTE
			Result [0xFE] := 'ţ' -- LATIN SMALL LETTER T WITH CEDILLA
			Result [0xFF] := '˙' -- DOT ABOVE
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

end
