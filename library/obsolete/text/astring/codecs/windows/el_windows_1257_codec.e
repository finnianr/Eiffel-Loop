note
	description: "Codec for WINDOWS_1257 automatically generated from decoder.c in VTD-XML source"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "4"

class
	EL_WINDOWS_1257_CODEC

inherit
	EL_WINDOWS_CODEC

create
	make

feature {NONE} -- Initialization

	initialize_latin_sets
		do
			latin_set_1 := latin_set_from_array (<<
				202, -- 'Ź'
				234, -- 'ź'
				221, -- 'Ż'
				253, -- 'ż'
				222, -- 'Ž'
				254  -- 'ž'
			>>)
			latin_set_2 := latin_set_from_array (<<
				217, -- 'Ł'
				249, -- 'ł'
				209, -- 'Ń'
				241, -- 'ń'
				210, -- 'Ņ'
				242  -- 'ņ'
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
				147, -- '“'
				148, -- '”'
				132  -- '„'
			>>)
			latin_set_6 := latin_set_from_array (<<
				145, -- '‘'
				146, -- '’'
				130  -- '‚'
			>>)
			latin_set_7 := latin_set_from_array (<<
				134, -- '†'
				135, -- '‡'
				149  -- '•'
			>>)
			latin_set_8 := latin_set_from_array (<<
				218, -- 'Ś'
				250  -- 'ś'
			>>)
			latin_set_9 := latin_set_from_array (<<
				139, -- '‹'
				155  -- '›'
			>>)
			latin_set_10 := latin_set_from_array (<<
				207, -- 'Ļ'
				239  -- 'ļ'
			>>)
			latin_set_11 := latin_set_from_array (<<
				212, -- 'Ō'
				244  -- 'ō'
			>>)
			latin_set_12 := latin_set_from_array (<<
				170, -- 'Ŗ'
				186  -- 'ŗ'
			>>)
			latin_set_13 := latin_set_from_array (<<
				216, -- 'Ų'
				248  -- 'ų'
			>>)
			latin_set_14 := latin_set_from_array (<<
				150, -- '–'
				151  -- '—'
			>>)
			latin_set_15 := latin_set_from_array (<<
				208, -- 'Š'
				240  -- 'š'
			>>)
			latin_set_16 := latin_set_from_array (<<
				219, -- 'Ū'
				251  -- 'ū'
			>>)
			latin_set_17 := latin_set_from_array (<<
				200, -- 'Č'
				232  -- 'č'
			>>)
			latin_set_18 := latin_set_from_array (<<
				194, -- 'Ā'
				226  -- 'ā'
			>>)
			latin_set_19 := latin_set_from_array (<<
				199, -- 'Ē'
				231  -- 'ē'
			>>)
			latin_set_20 := latin_set_from_array (<<
				205, -- 'Ķ'
				237  -- 'ķ'
			>>)
			latin_set_21 := latin_set_from_array (<<
				206, -- 'Ī'
				238  -- 'ī'
			>>)
			latin_set_22 := latin_set_from_array (<<
				193, -- 'Į'
				225  -- 'į'
			>>)
			latin_set_23 := latin_set_from_array (<<
				204, -- 'Ģ'
				236  -- 'ģ'
			>>)
		end

feature -- Access

	id: INTEGER = 1257

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
			-- Returns '%U' if translation is the same as ISO-8859-1 or else not in WINDOWS_1257
		do
			inspect uc
				when 'Ź'..'ž' then
					Result := latin_set_1 [unicode - 377]
				when 'Ł'..'ņ' then
					Result := latin_set_2 [unicode - 321]
				when 'Ą'..'ć' then
					Result := latin_set_3 [unicode - 260]
				when 'Ė'..'ę' then
					Result := latin_set_4 [unicode - 278]
				when '“'..'„' then
					Result := latin_set_5 [unicode - 8220]
				when '‘'..'‚' then
					Result := latin_set_6 [unicode - 8216]
				when '†'..'•' then
					Result := latin_set_7 [unicode - 8224]
				when 'Ś'..'ś' then
					Result := latin_set_8 [unicode - 346]
				when '‹'..'›' then
					Result := latin_set_9 [unicode - 8249]
				when 'Ļ'..'ļ' then
					Result := latin_set_10 [unicode - 315]
				when 'Ō'..'ō' then
					Result := latin_set_11 [unicode - 332]
				when 'Ŗ'..'ŗ' then
					Result := latin_set_12 [unicode - 342]
				when 'Ų'..'ų' then
					Result := latin_set_13 [unicode - 370]
				when '–'..'—' then
					Result := latin_set_14 [unicode - 8211]
				when 'Š'..'š' then
					Result := latin_set_15 [unicode - 352]
				when 'Ū'..'ū' then
					Result := latin_set_16 [unicode - 362]
				when 'Č'..'č' then
					Result := latin_set_17 [unicode - 268]
				when 'Ā'..'ā' then
					Result := latin_set_18 [unicode - 256]
				when 'Ē'..'ē' then
					Result := latin_set_19 [unicode - 274]
				when 'Ķ'..'ķ' then
					Result := latin_set_20 [unicode - 310]
				when 'Ī'..'ī' then
					Result := latin_set_21 [unicode - 298]
				when 'Į'..'į' then
					Result := latin_set_22 [unicode - 302]
				when 'Ģ'..'ģ' then
					Result := latin_set_23 [unicode - 290]
				when '…' then
					Result := '%/133/'
				when '¸' then
					Result := '%/143/'
				when '‰' then
					Result := '%/137/'
				when '€' then
					Result := '%/128/'
				when '™' then
					Result := '%/153/'
				when 'Æ' then
					Result := '%/175/'
				when '¯' then
					Result := '%/157/'
				when 'æ' then
					Result := '%/191/'
				when 'ø' then
					Result := '%/184/'
				when 'ˇ' then
					Result := '%/142/'
				when '¨' then
					Result := '%/141/'
				when '˙' then
					Result := '%/255/'
				when '˛' then
					Result := '%/158/'
				when 'Ø' then
					Result := '%/168/'
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
			-- Unicode value indexed by WINDOWS_1257 character values
		do
			Result := single_byte_unicode_chars
			Result [0x80] := '€' -- EURO SIGN
			Result [0x82] := '‚' -- SINGLE LOW-9 QUOTATION MARK
			Result [0x84] := '„' -- DOUBLE LOW-9 QUOTATION MARK
			Result [0x85] := '…' -- HORIZONTAL ELLIPSIS
			Result [0x86] := '†' -- DAGGER
			Result [0x87] := '‡' -- DOUBLE DAGGER
			Result [0x89] := '‰' -- PER MILLE SIGN
			Result [0x8B] := '‹' -- SINGLE LEFT-POINTING ANGLE QUOTATION MARK
			Result [0x8D] := '¨' -- DIAERESIS
			Result [0x8E] := 'ˇ' -- CARON
			Result [0x8F] := '¸' -- CEDILLA
			Result [0x91] := '‘' -- LEFT SINGLE QUOTATION MARK
			Result [0x92] := '’' -- RIGHT SINGLE QUOTATION MARK
			Result [0x93] := '“' -- LEFT DOUBLE QUOTATION MARK
			Result [0x94] := '”' -- RIGHT DOUBLE QUOTATION MARK
			Result [0x95] := '•' -- BULLET
			Result [0x96] := '–' -- EN DASH
			Result [0x97] := '—' -- EM DASH
			Result [0x99] := '™' -- TRADE MARK SIGN
			Result [0x9B] := '›' -- SINGLE RIGHT-POINTING ANGLE QUOTATION MARK
			Result [0x9D] := '¯' -- MACRON
			Result [0x9E] := '˛' -- OGONEK
			Result [0xA0] := ' ' -- NO-BREAK SPACE
			Result [0xA2] := '¢' -- CENT SIGN
			Result [0xA3] := '£' -- POUND SIGN
			Result [0xA4] := '¤' -- CURRENCY SIGN
			Result [0xA6] := '¦' -- BROKEN BAR
			Result [0xA7] := '§' -- SECTION SIGN
			Result [0xA8] := 'Ø' -- LATIN CAPITAL LETTER O WITH STROKE
			Result [0xA9] := '©' -- COPYRIGHT SIGN
			Result [0xAA] := 'Ŗ' -- LATIN CAPITAL LETTER R WITH CEDILLA
			Result [0xAB] := '«' -- LEFT-POINTING DOUBLE ANGLE QUOTATION MARK
			Result [0xAC] := '¬' -- NOT SIGN
			Result [0xAD] := '­' -- SOFT HYPHEN
			Result [0xAE] := '®' -- REGISTERED SIGN
			Result [0xAF] := 'Æ' -- LATIN CAPITAL LETTER AE
			Result [0xB0] := '°' -- DEGREE SIGN
			Result [0xB1] := '±' -- PLUS-MINUS SIGN
			Result [0xB2] := '²' -- SUPERSCRIPT TWO
			Result [0xB3] := '³' -- SUPERSCRIPT THREE
			Result [0xB4] := '´' -- ACUTE ACCENT
			Result [0xB5] := 'µ' -- MICRO SIGN
			Result [0xB6] := '¶' -- PILCROW SIGN
			Result [0xB7] := '·' -- MIDDLE DOT
			Result [0xB8] := 'ø' -- LATIN SMALL LETTER O WITH STROKE
			Result [0xB9] := '¹' -- SUPERSCRIPT ONE
			Result [0xBA] := 'ŗ' -- LATIN SMALL LETTER R WITH CEDILLA
			Result [0xBB] := '»' -- RIGHT-POINTING DOUBLE ANGLE QUOTATION MARK
			Result [0xBC] := '¼' -- VULGAR FRACTION ONE QUARTER
			Result [0xBD] := '½' -- VULGAR FRACTION ONE HALF
			Result [0xBE] := '¾' -- VULGAR FRACTION THREE QUARTERS
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
			Result [0xD7] := '×' -- MULTIPLICATION SIGN
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
			Result [0xF7] := '÷' -- DIVISION SIGN
			Result [0xF8] := 'ų' -- LATIN SMALL LETTER U WITH OGONEK
			Result [0xF9] := 'ł' -- LATIN SMALL LETTER L WITH STROKE
			Result [0xFA] := 'ś' -- LATIN SMALL LETTER S WITH ACUTE
			Result [0xFB] := 'ū' -- LATIN SMALL LETTER U WITH MACRON
			Result [0xFC] := 'ü' -- LATIN SMALL LETTER U WITH DIAERESIS
			Result [0xFD] := 'ż' -- LATIN SMALL LETTER Z WITH DOT ABOVE
			Result [0xFE] := 'ž' -- LATIN SMALL LETTER Z WITH CARON
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

	latin_set_15: SPECIAL [CHARACTER]

	latin_set_16: SPECIAL [CHARACTER]

	latin_set_17: SPECIAL [CHARACTER]

	latin_set_18: SPECIAL [CHARACTER]

	latin_set_19: SPECIAL [CHARACTER]

	latin_set_20: SPECIAL [CHARACTER]

	latin_set_21: SPECIAL [CHARACTER]

	latin_set_22: SPECIAL [CHARACTER]

	latin_set_23: SPECIAL [CHARACTER]

end
