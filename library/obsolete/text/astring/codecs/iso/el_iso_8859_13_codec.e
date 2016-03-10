note
	description: "Codec for ISO_8859_13 automatically generated from decoder.c in VTD-XML source"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "4"

class
	EL_ISO_8859_13_CODEC

inherit
	EL_ISO_8859_CODEC

create
	make

feature {NONE} -- Initialization

	initialize_latin_sets
		do
			latin_set_1 := latin_set_from_array (<<
				217, -- 'Ł'
				249, -- 'ł'
				209, -- 'Ń'
				241, -- 'ń'
				210, -- 'Ņ'
				242  -- 'ņ'
			>>)
			latin_set_2 := latin_set_from_array (<<
				202, -- 'Ź'
				234, -- 'ź'
				221, -- 'Ż'
				253, -- 'ż'
				222, -- 'Ž'
				254  -- 'ž'
			>>)
			latin_set_3 := latin_set_from_array (<<
				192, -- 'Ą'
				224, -- 'ą'
				195, -- 'Ć'
				227  -- 'ć'
			>>)
			latin_set_4 := latin_set_from_array (<<
				203, -- 'Ė'
				235, -- 'ė'
				198, -- 'Ę'
				230  -- 'ę'
			>>)
			latin_set_5 := latin_set_from_array (<<
				180, -- '“'
				161, -- '”'
				165  -- '„'
			>>)
			latin_set_6 := latin_set_from_array (<<
				170, -- 'Ŗ'
				186  -- 'ŗ'
			>>)
			latin_set_7 := latin_set_from_array (<<
				207, -- 'Ļ'
				239  -- 'ļ'
			>>)
			latin_set_8 := latin_set_from_array (<<
				212, -- 'Ō'
				244  -- 'ō'
			>>)
			latin_set_9 := latin_set_from_array (<<
				216, -- 'Ų'
				248  -- 'ų'
			>>)
			latin_set_10 := latin_set_from_array (<<
				219, -- 'Ū'
				251  -- 'ū'
			>>)
			latin_set_11 := latin_set_from_array (<<
				208, -- 'Š'
				240  -- 'š'
			>>)
			latin_set_12 := latin_set_from_array (<<
				218, -- 'Ś'
				250  -- 'ś'
			>>)
			latin_set_13 := latin_set_from_array (<<
				200, -- 'Č'
				232  -- 'č'
			>>)
			latin_set_14 := latin_set_from_array (<<
				199, -- 'Ē'
				231  -- 'ē'
			>>)
			latin_set_15 := latin_set_from_array (<<
				204, -- 'Ģ'
				236  -- 'ģ'
			>>)
			latin_set_16 := latin_set_from_array (<<
				205, -- 'Ķ'
				237  -- 'ķ'
			>>)
			latin_set_17 := latin_set_from_array (<<
				194, -- 'Ā'
				226  -- 'ā'
			>>)
			latin_set_18 := latin_set_from_array (<<
				193, -- 'Į'
				225  -- 'į'
			>>)
			latin_set_19 := latin_set_from_array (<<
				206, -- 'Ī'
				238  -- 'ī'
			>>)
		end

feature -- Access

	id: INTEGER = 13

feature -- Conversion

	as_upper (code: NATURAL): NATURAL
		local
			offset: NATURAL
		do
			inspect code
				when 97..122, 224..246, 248..254 then
					offset := 32
				when 184, 186, 191 then
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
				when 168, 170, 175 then
					offset := 16

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
			else end
		end

	latin_character (uc: CHARACTER_32; unicode: INTEGER): CHARACTER
			-- unicode to latin translation
			-- Returns '%U' if translation is the same as ISO-8859-1 or else not in ISO_8859_13
		do
			inspect uc
				when 'Ł'..'ņ' then
					Result := latin_set_1 [unicode - 321]
				when 'Ź'..'ž' then
					Result := latin_set_2 [unicode - 377]
				when 'Ą'..'ć' then
					Result := latin_set_3 [unicode - 260]
				when 'Ė'..'ę' then
					Result := latin_set_4 [unicode - 278]
				when '“'..'„' then
					Result := latin_set_5 [unicode - 8220]
				when 'Ŗ'..'ŗ' then
					Result := latin_set_6 [unicode - 342]
				when 'Ļ'..'ļ' then
					Result := latin_set_7 [unicode - 315]
				when 'Ō'..'ō' then
					Result := latin_set_8 [unicode - 332]
				when 'Ų'..'ų' then
					Result := latin_set_9 [unicode - 370]
				when 'Ū'..'ū' then
					Result := latin_set_10 [unicode - 362]
				when 'Š'..'š' then
					Result := latin_set_11 [unicode - 352]
				when 'Ś'..'ś' then
					Result := latin_set_12 [unicode - 346]
				when 'Č'..'č' then
					Result := latin_set_13 [unicode - 268]
				when 'Ē'..'ē' then
					Result := latin_set_14 [unicode - 274]
				when 'Ģ'..'ģ' then
					Result := latin_set_15 [unicode - 290]
				when 'Ķ'..'ķ' then
					Result := latin_set_16 [unicode - 310]
				when 'Ā'..'ā' then
					Result := latin_set_17 [unicode - 256]
				when 'Į'..'į' then
					Result := latin_set_18 [unicode - 302]
				when 'Ī'..'ī' then
					Result := latin_set_19 [unicode - 298]
				when '’' then
					Result := '%/255/'
				when 'Ø' then
					Result := '%/168/'
				when 'æ' then
					Result := '%/191/'
				when 'ø' then
					Result := '%/184/'
				when 'Æ' then
					Result := '%/175/'
			else end
		end

feature -- Character query

	is_alpha (code: NATURAL): BOOLEAN
		do
			inspect code 
				when 65..90, 97..122, 168, 170, 175, 181, 184, 186, 191..214, 216..246, 248..254 then
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
				when 97..122, 224..246, 248..254, 184, 186, 191 then
					Result := True
			else
			end
		end

	is_lower (code: NATURAL): BOOLEAN
		do
			inspect code 
				when 65..90, 192..214, 216..222, 168, 170, 175 then
					Result := True

				-- Characters which are only available in a single case
				when 181, 223 then
					Result := True

			else
			end
		end

feature {NONE} -- Implementation

	create_unicode_table: SPECIAL [CHARACTER_32]
			-- Unicode value indexed by ISO_8859_13 character values
		do
			Result := single_byte_unicode_chars
			Result [0xA0] := ' ' -- 
			Result [0xA1] := '”' -- 
			Result [0xA2] := '¢' -- 
			Result [0xA3] := '£' -- 
			Result [0xA4] := '¤' -- 
			Result [0xA5] := '„' -- 
			Result [0xA6] := '¦' -- 
			Result [0xA7] := '§' -- 
			Result [0xA8] := 'Ø' -- 
			Result [0xA9] := '©' -- 
			Result [0xAA] := 'Ŗ' -- 
			Result [0xAB] := '«' -- 
			Result [0xAC] := '¬' -- 
			Result [0xAD] := '­' -- 
			Result [0xAE] := '®' -- 
			Result [0xAF] := 'Æ' -- 
			Result [0xB0] := '°' -- 
			Result [0xB1] := '±' -- 
			Result [0xB2] := '²' -- 
			Result [0xB3] := '³' -- 
			Result [0xB4] := '“' -- 
			Result [0xB5] := 'µ' -- 
			Result [0xB6] := '¶' -- 
			Result [0xB7] := '·' -- 
			Result [0xB8] := 'ø' -- 
			Result [0xB9] := '¹' -- 
			Result [0xBA] := 'ŗ' -- LATIN SMALL LETTER R WITH CEDILLA
			Result [0xBB] := '»' -- 
			Result [0xBC] := '¼' -- 
			Result [0xBD] := '½' -- 
			Result [0xBE] := '¾' -- 
			Result [0xBF] := 'æ' -- LATIN SMALL LETTER AE
			Result [0xC0] := 'Ą' -- LATIN CAPITAL LETTER A WITH OGONEK
			Result [0xC1] := 'Į' -- LATIN CAPITAL LETTER I WITH OGONEK
			Result [0xC2] := 'Ā' -- LATIN CAPITAL LETTER A WITH MACRON
			Result [0xC3] := 'Ć' -- LATIN CAPITAL LETTER C WITH ACUTE
			Result [0xC4] := 'Ä' -- LATIN CAPITAL LETTER A WITH DIAERESIS
			Result [0xC5] := 'Å' -- LATIN CAPITAL LETTER A WITH RING ABOVE
			Result [0xC6] := 'Ę' -- LATIN CAPITAL LETTER E WITH OGONEK
			Result [0xC7] := 'Ē' -- LATIN CAPITAL LETTER E WITH MACRON
			Result [0xC8] := 'Č' -- LATIN CAPITAL LETTER C WITH CARON
			Result [0xC9] := 'É' -- LATIN CAPITAL LETTER E WITH ACUTE
			Result [0xCA] := 'Ź' -- LATIN CAPITAL LETTER Z WITH ACUTE
			Result [0xCB] := 'Ė' -- LATIN CAPITAL LETTER E WITH DOT ABOVE
			Result [0xCC] := 'Ģ' -- LATIN CAPITAL LETTER G WITH CEDILLA
			Result [0xCD] := 'Ķ' -- LATIN CAPITAL LETTER K WITH CEDILLA
			Result [0xCE] := 'Ī' -- LATIN CAPITAL LETTER I WITH MACRON
			Result [0xCF] := 'Ļ' -- LATIN CAPITAL LETTER L WITH CEDILLA
			Result [0xD0] := 'Š' -- LATIN CAPITAL LETTER S WITH CARON
			Result [0xD1] := 'Ń' -- LATIN CAPITAL LETTER N WITH ACUTE
			Result [0xD2] := 'Ņ' -- LATIN CAPITAL LETTER N WITH CEDILLA
			Result [0xD3] := 'Ó' -- LATIN CAPITAL LETTER O WITH ACUTE
			Result [0xD4] := 'Ō' -- LATIN CAPITAL LETTER O WITH MACRON
			Result [0xD5] := 'Õ' -- LATIN CAPITAL LETTER O WITH TILDE
			Result [0xD6] := 'Ö' -- LATIN CAPITAL LETTER O WITH DIAERESIS
			Result [0xD7] := '×' -- 
			Result [0xD8] := 'Ų' -- LATIN CAPITAL LETTER U WITH OGONEK
			Result [0xD9] := 'Ł' -- LATIN CAPITAL LETTER L WITH STROKE
			Result [0xDA] := 'Ś' -- LATIN CAPITAL LETTER S WITH ACUTE
			Result [0xDB] := 'Ū' -- LATIN CAPITAL LETTER U WITH MACRON
			Result [0xDC] := 'Ü' -- LATIN CAPITAL LETTER U WITH DIAERESIS
			Result [0xDD] := 'Ż' -- LATIN CAPITAL LETTER Z WITH DOT ABOVE
			Result [0xDE] := 'Ž' -- LATIN CAPITAL LETTER Z WITH CARON
			Result [0xDF] := 'ß' -- LATIN SMALL LETTER SHARP S
			Result [0xE0] := 'ą' -- LATIN SMALL LETTER A WITH OGONEK
			Result [0xE1] := 'į' -- LATIN SMALL LETTER I WITH OGONEK
			Result [0xE2] := 'ā' -- LATIN SMALL LETTER A WITH MACRON
			Result [0xE3] := 'ć' -- LATIN SMALL LETTER C WITH ACUTE
			Result [0xE4] := 'ä' -- LATIN SMALL LETTER A WITH DIAERESIS
			Result [0xE5] := 'å' -- LATIN SMALL LETTER A WITH RING ABOVE
			Result [0xE6] := 'ę' -- LATIN SMALL LETTER E WITH OGONEK
			Result [0xE7] := 'ē' -- LATIN SMALL LETTER E WITH MACRON
			Result [0xE8] := 'č' -- LATIN SMALL LETTER C WITH CARON
			Result [0xE9] := 'é' -- LATIN SMALL LETTER E WITH ACUTE
			Result [0xEA] := 'ź' -- LATIN SMALL LETTER Z WITH ACUTE
			Result [0xEB] := 'ė' -- LATIN SMALL LETTER E WITH DOT ABOVE
			Result [0xEC] := 'ģ' -- LATIN SMALL LETTER G WITH CEDILLA
			Result [0xED] := 'ķ' -- LATIN SMALL LETTER K WITH CEDILLA
			Result [0xEE] := 'ī' -- LATIN SMALL LETTER I WITH MACRON
			Result [0xEF] := 'ļ' -- LATIN SMALL LETTER L WITH CEDILLA
			Result [0xF0] := 'š' -- LATIN SMALL LETTER S WITH CARON
			Result [0xF1] := 'ń' -- LATIN SMALL LETTER N WITH ACUTE
			Result [0xF2] := 'ņ' -- LATIN SMALL LETTER N WITH CEDILLA
			Result [0xF3] := 'ó' -- LATIN SMALL LETTER O WITH ACUTE
			Result [0xF4] := 'ō' -- LATIN SMALL LETTER O WITH MACRON
			Result [0xF5] := 'õ' -- LATIN SMALL LETTER O WITH TILDE
			Result [0xF6] := 'ö' -- LATIN SMALL LETTER O WITH DIAERESIS
			Result [0xF7] := '÷' -- 
			Result [0xF8] := 'ų' -- LATIN SMALL LETTER U WITH OGONEK
			Result [0xF9] := 'ł' -- LATIN SMALL LETTER L WITH STROKE
			Result [0xFA] := 'ś' -- LATIN SMALL LETTER S WITH ACUTE
			Result [0xFB] := 'ū' -- LATIN SMALL LETTER U WITH MACRON
			Result [0xFC] := 'ü' -- LATIN SMALL LETTER U WITH DIAERESIS
			Result [0xFD] := 'ż' -- LATIN SMALL LETTER Z WITH DOT ABOVE
			Result [0xFE] := 'ž' -- LATIN SMALL LETTER Z WITH CARON
			Result [0xFF] := '’' -- 
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

	latin_set_18: SPECIAL [CHARACTER]

	latin_set_19: SPECIAL [CHARACTER]

end
