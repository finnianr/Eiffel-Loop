note
	description: "Codec for WINDOWS_1251 automatically generated from decoder.c in VTD-XML source"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "4"

class
	EL_WINDOWS_1251_CODEC

inherit
	EL_WINDOWS_CODEC

create
	make

feature {NONE} -- Initialization

	initialize_latin_sets
		do
			latin_set_1 := latin_set_from_array (<<
				161, -- 'Ў'
				143, -- 'Џ'
				192, -- 'А'
				193, -- 'Б'
				194, -- 'В'
				195, -- 'Г'
				196, -- 'Д'
				197, -- 'Е'
				198, -- 'Ж'
				199, -- 'З'
				200, -- 'И'
				201, -- 'Й'
				202, -- 'К'
				203, -- 'Л'
				204, -- 'М'
				205, -- 'Н'
				206, -- 'О'
				207, -- 'П'
				208, -- 'Р'
				209, -- 'С'
				210, -- 'Т'
				211, -- 'У'
				212, -- 'Ф'
				213, -- 'Х'
				214, -- 'Ц'
				215, -- 'Ч'
				216, -- 'Ш'
				217, -- 'Щ'
				218, -- 'Ъ'
				219, -- 'Ы'
				220, -- 'Ь'
				221, -- 'Э'
				222, -- 'Ю'
				223, -- 'Я'
				224, -- 'а'
				225, -- 'б'
				226, -- 'в'
				227, -- 'г'
				228, -- 'д'
				229, -- 'е'
				230, -- 'ж'
				231, -- 'з'
				232, -- 'и'
				233, -- 'й'
				234, -- 'к'
				235, -- 'л'
				236, -- 'м'
				237, -- 'н'
				238, -- 'о'
				239, -- 'п'
				240, -- 'р'
				241, -- 'с'
				242, -- 'т'
				243, -- 'у'
				244, -- 'ф'
				245, -- 'х'
				246, -- 'ц'
				247, -- 'ч'
				248, -- 'ш'
				249, -- 'щ'
				250, -- 'ъ'
				251, -- 'ы'
				252, -- 'ь'
				253, -- 'э'
				254, -- 'ю'
				255  -- 'я'
			>>)
			latin_set_2 := latin_set_from_array (<<
				168, -- 'Ё'
				128, -- 'Ђ'
				129, -- 'Ѓ'
				170, -- 'Є'
				189, -- 'Ѕ'
				178, -- 'І'
				175, -- 'Ї'
				163, -- 'Ј'
				138, -- 'Љ'
				140, -- 'Њ'
				142, -- 'Ћ'
				141  -- 'Ќ'
			>>)
			latin_set_3 := latin_set_from_array (<<
				184, -- 'ё'
				144, -- 'ђ'
				131, -- 'ѓ'
				186, -- 'є'
				190, -- 'ѕ'
				179, -- 'і'
				191, -- 'ї'
				188, -- 'ј'
				154, -- 'љ'
				156, -- 'њ'
				158, -- 'ћ'
				157  -- 'ќ'
			>>)
			latin_set_4 := latin_set_from_array (<<
				147, -- '“'
				148, -- '”'
				132  -- '„'
			>>)
			latin_set_5 := latin_set_from_array (<<
				145, -- '‘'
				146, -- '’'
				130  -- '‚'
			>>)
			latin_set_6 := latin_set_from_array (<<
				134, -- '†'
				135, -- '‡'
				149  -- '•'
			>>)
			latin_set_7 := latin_set_from_array (<<
				139, -- '‹'
				155  -- '›'
			>>)
			latin_set_8 := latin_set_from_array (<<
				165, -- 'Ґ'
				180  -- 'ґ'
			>>)
			latin_set_9 := latin_set_from_array (<<
				150, -- '–'
				151  -- '—'
			>>)
			latin_set_10 := latin_set_from_array (<<
				162, -- 'ў'
				159  -- 'џ'
			>>)
		end

feature -- Access

	id: INTEGER = 1251

feature -- Conversion

	as_upper (code: NATURAL): NATURAL
		local
			offset: NATURAL
		do
			inspect code
				when 97..122, 224..255 then
					offset := 32
				when 131 then
					offset := 2
				when 144, 154, 156..159, 184, 186, 191 then
					offset := 16
				when 162, 179, 190 then
					offset := 1
				when 180 then
					offset := 15
				when 188 then
					offset := 25

			else end
			Result := code - offset
		end

	as_lower (code: NATURAL): NATURAL
		local
			offset: NATURAL
		do
			inspect code
				when 65..90, 192..223 then
					offset := 32
				when 128, 138, 140..143, 168, 170, 175 then
					offset := 16
				when 129 then
					offset := 2
				when 161, 178, 189 then
					offset := 1
				when 163 then
					offset := 25
				when 165 then
					offset := 15

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
			-- Returns '%U' if translation is the same as ISO-8859-1 or else not in WINDOWS_1251
		do
			inspect uc
				when 'Ў'..'я' then
					Result := latin_set_1 [unicode - 1038]
				when 'Ё'..'Ќ' then
					Result := latin_set_2 [unicode - 1025]
				when 'ё'..'ќ' then
					Result := latin_set_3 [unicode - 1105]
				when '“'..'„' then
					Result := latin_set_4 [unicode - 8220]
				when '‘'..'‚' then
					Result := latin_set_5 [unicode - 8216]
				when '†'..'•' then
					Result := latin_set_6 [unicode - 8224]
				when '‹'..'›' then
					Result := latin_set_7 [unicode - 8249]
				when 'Ґ'..'ґ' then
					Result := latin_set_8 [unicode - 1168]
				when '–'..'—' then
					Result := latin_set_9 [unicode - 8211]
				when 'ў'..'џ' then
					Result := latin_set_10 [unicode - 1118]
				when '€' then
					Result := '%/136/'
				when '№' then
					Result := '%/185/'
				when '™' then
					Result := '%/153/'
				when '‰' then
					Result := '%/137/'
				when '…' then
					Result := '%/133/'
			else end
		end

feature -- Character query

	is_alpha (code: NATURAL): BOOLEAN
		do
			inspect code 
				when 65..90, 97..122, 128..129, 131, 138, 140..144, 154, 156..159, 161..163, 165, 168, 170, 175, 178..181, 184, 186, 188..255 then
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
				when 97..122, 224..255, 131, 144, 154, 156..159, 184, 186, 191, 162, 179, 190, 180, 188 then
					Result := True
			else
			end
		end

	is_lower (code: NATURAL): BOOLEAN
		do
			inspect code 
				when 65..90, 192..223, 128, 138, 140..143, 168, 170, 175, 129, 161, 178, 189, 163, 165 then
					Result := True

				-- Characters which are only available in a single case
				when 181 then
					Result := True

			else
			end
		end

feature {NONE} -- Implementation

	create_unicode_table: SPECIAL [CHARACTER_32]
			-- Unicode value indexed by WINDOWS_1251 character values
		do
			Result := single_byte_unicode_chars
			Result [0x80] := 'Ђ' -- CYRILLIC CAPITAL LETTER DJE
			Result [0x81] := 'Ѓ' -- CYRILLIC CAPITAL LETTER GJE
			Result [0x82] := '‚' -- SINGLE LOW-9 QUOTATION MARK
			Result [0x83] := 'ѓ' -- CYRILLIC SMALL LETTER GJE
			Result [0x84] := '„' -- DOUBLE LOW-9 QUOTATION MARK
			Result [0x85] := '…' -- HORIZONTAL ELLIPSIS
			Result [0x86] := '†' -- DAGGER
			Result [0x87] := '‡' -- DOUBLE DAGGER
			Result [0x88] := '€' -- EURO SIGN
			Result [0x89] := '‰' -- PER MILLE SIGN
			Result [0x8A] := 'Љ' -- CYRILLIC CAPITAL LETTER LJE
			Result [0x8B] := '‹' -- SINGLE LEFT-POINTING ANGLE QUOTATION MARK
			Result [0x8C] := 'Њ' -- CYRILLIC CAPITAL LETTER NJE
			Result [0x8D] := 'Ќ' -- CYRILLIC CAPITAL LETTER KJE
			Result [0x8E] := 'Ћ' -- CYRILLIC CAPITAL LETTER TSHE
			Result [0x8F] := 'Џ' -- CYRILLIC CAPITAL LETTER DZHE
			Result [0x90] := 'ђ' -- CYRILLIC SMALL LETTER DJE
			Result [0x91] := '‘' -- LEFT SINGLE QUOTATION MARK
			Result [0x92] := '’' -- RIGHT SINGLE QUOTATION MARK
			Result [0x93] := '“' -- LEFT DOUBLE QUOTATION MARK
			Result [0x94] := '”' -- RIGHT DOUBLE QUOTATION MARK
			Result [0x95] := '•' -- BULLET
			Result [0x96] := '–' -- EN DASH
			Result [0x97] := '—' -- EM DASH
			Result [0x99] := '™' -- TRADE MARK SIGN
			Result [0x9A] := 'љ' -- CYRILLIC SMALL LETTER LJE
			Result [0x9B] := '›' -- SINGLE RIGHT-POINTING ANGLE QUOTATION MARK
			Result [0x9C] := 'њ' -- CYRILLIC SMALL LETTER NJE
			Result [0x9D] := 'ќ' -- CYRILLIC SMALL LETTER KJE
			Result [0x9E] := 'ћ' -- CYRILLIC SMALL LETTER TSHE
			Result [0x9F] := 'џ' -- CYRILLIC SMALL LETTER DZHE
			Result [0xA0] := ' ' -- NO-BREAK SPACE
			Result [0xA1] := 'Ў' -- CYRILLIC CAPITAL LETTER SHORT U
			Result [0xA2] := 'ў' -- CYRILLIC SMALL LETTER SHORT U
			Result [0xA3] := 'Ј' -- CYRILLIC CAPITAL LETTER JE
			Result [0xA4] := '¤' -- CURRENCY SIGN
			Result [0xA5] := 'Ґ' -- CYRILLIC CAPITAL LETTER GHE WITH UPTURN
			Result [0xA6] := '¦' -- BROKEN BAR
			Result [0xA7] := '§' -- SECTION SIGN
			Result [0xA8] := 'Ё' -- CYRILLIC CAPITAL LETTER IO
			Result [0xA9] := '©' -- COPYRIGHT SIGN
			Result [0xAA] := 'Є' -- CYRILLIC CAPITAL LETTER UKRAINIAN IE
			Result [0xAB] := '«' -- LEFT-POINTING DOUBLE ANGLE QUOTATION MARK
			Result [0xAC] := '¬' -- NOT SIGN
			Result [0xAD] := '­' -- SOFT HYPHEN
			Result [0xAE] := '®' -- REGISTERED SIGN
			Result [0xAF] := 'Ї' -- CYRILLIC CAPITAL LETTER YI
			Result [0xB0] := '°' -- DEGREE SIGN
			Result [0xB1] := '±' -- PLUS-MINUS SIGN
			Result [0xB2] := 'І' -- CYRILLIC CAPITAL LETTER BYELORUSSIAN-UKRAINIAN I
			Result [0xB3] := 'і' -- CYRILLIC SMALL LETTER BYELORUSSIAN-UKRAINIAN I
			Result [0xB4] := 'ґ' -- CYRILLIC SMALL LETTER GHE WITH UPTURN
			Result [0xB5] := 'µ' -- MICRO SIGN
			Result [0xB6] := '¶' -- PILCROW SIGN
			Result [0xB7] := '·' -- MIDDLE DOT
			Result [0xB8] := 'ё' -- CYRILLIC SMALL LETTER IO
			Result [0xB9] := '№' -- NUMERO SIGN
			Result [0xBA] := 'є' -- CYRILLIC SMALL LETTER UKRAINIAN IE
			Result [0xBB] := '»' -- RIGHT-POINTING DOUBLE ANGLE QUOTATION MARK
			Result [0xBC] := 'ј' -- CYRILLIC SMALL LETTER JE
			Result [0xBD] := 'Ѕ' -- CYRILLIC CAPITAL LETTER DZE
			Result [0xBE] := 'ѕ' -- CYRILLIC SMALL LETTER DZE
			Result [0xBF] := 'ї' -- CYRILLIC SMALL LETTER YI
			Result [0xC0] := 'А' -- CYRILLIC CAPITAL LETTER A
			Result [0xC1] := 'Б' -- CYRILLIC CAPITAL LETTER BE
			Result [0xC2] := 'В' -- CYRILLIC CAPITAL LETTER VE
			Result [0xC3] := 'Г' -- CYRILLIC CAPITAL LETTER GHE
			Result [0xC4] := 'Д' -- CYRILLIC CAPITAL LETTER DE
			Result [0xC5] := 'Е' -- CYRILLIC CAPITAL LETTER IE
			Result [0xC6] := 'Ж' -- CYRILLIC CAPITAL LETTER ZHE
			Result [0xC7] := 'З' -- CYRILLIC CAPITAL LETTER ZE
			Result [0xC8] := 'И' -- CYRILLIC CAPITAL LETTER I
			Result [0xC9] := 'Й' -- CYRILLIC CAPITAL LETTER SHORT I
			Result [0xCA] := 'К' -- CYRILLIC CAPITAL LETTER KA
			Result [0xCB] := 'Л' -- CYRILLIC CAPITAL LETTER EL
			Result [0xCC] := 'М' -- CYRILLIC CAPITAL LETTER EM
			Result [0xCD] := 'Н' -- CYRILLIC CAPITAL LETTER EN
			Result [0xCE] := 'О' -- CYRILLIC CAPITAL LETTER O
			Result [0xCF] := 'П' -- CYRILLIC CAPITAL LETTER PE
			Result [0xD0] := 'Р' -- CYRILLIC CAPITAL LETTER ER
			Result [0xD1] := 'С' -- CYRILLIC CAPITAL LETTER ES
			Result [0xD2] := 'Т' -- CYRILLIC CAPITAL LETTER TE
			Result [0xD3] := 'У' -- CYRILLIC CAPITAL LETTER U
			Result [0xD4] := 'Ф' -- CYRILLIC CAPITAL LETTER EF
			Result [0xD5] := 'Х' -- CYRILLIC CAPITAL LETTER HA
			Result [0xD6] := 'Ц' -- CYRILLIC CAPITAL LETTER TSE
			Result [0xD7] := 'Ч' -- CYRILLIC CAPITAL LETTER CHE
			Result [0xD8] := 'Ш' -- CYRILLIC CAPITAL LETTER SHA
			Result [0xD9] := 'Щ' -- CYRILLIC CAPITAL LETTER SHCHA
			Result [0xDA] := 'Ъ' -- CYRILLIC CAPITAL LETTER HARD SIGN
			Result [0xDB] := 'Ы' -- CYRILLIC CAPITAL LETTER YERU
			Result [0xDC] := 'Ь' -- CYRILLIC CAPITAL LETTER SOFT SIGN
			Result [0xDD] := 'Э' -- CYRILLIC CAPITAL LETTER E
			Result [0xDE] := 'Ю' -- CYRILLIC CAPITAL LETTER YU
			Result [0xDF] := 'Я' -- CYRILLIC CAPITAL LETTER YA
			Result [0xE0] := 'а' -- CYRILLIC SMALL LETTER A
			Result [0xE1] := 'б' -- CYRILLIC SMALL LETTER BE
			Result [0xE2] := 'в' -- CYRILLIC SMALL LETTER VE
			Result [0xE3] := 'г' -- CYRILLIC SMALL LETTER GHE
			Result [0xE4] := 'д' -- CYRILLIC SMALL LETTER DE
			Result [0xE5] := 'е' -- CYRILLIC SMALL LETTER IE
			Result [0xE6] := 'ж' -- CYRILLIC SMALL LETTER ZHE
			Result [0xE7] := 'з' -- CYRILLIC SMALL LETTER ZE
			Result [0xE8] := 'и' -- CYRILLIC SMALL LETTER I
			Result [0xE9] := 'й' -- CYRILLIC SMALL LETTER SHORT I
			Result [0xEA] := 'к' -- CYRILLIC SMALL LETTER KA
			Result [0xEB] := 'л' -- CYRILLIC SMALL LETTER EL
			Result [0xEC] := 'м' -- CYRILLIC SMALL LETTER EM
			Result [0xED] := 'н' -- CYRILLIC SMALL LETTER EN
			Result [0xEE] := 'о' -- CYRILLIC SMALL LETTER O
			Result [0xEF] := 'п' -- CYRILLIC SMALL LETTER PE
			Result [0xF0] := 'р' -- CYRILLIC SMALL LETTER ER
			Result [0xF1] := 'с' -- CYRILLIC SMALL LETTER ES
			Result [0xF2] := 'т' -- CYRILLIC SMALL LETTER TE
			Result [0xF3] := 'у' -- CYRILLIC SMALL LETTER U
			Result [0xF4] := 'ф' -- CYRILLIC SMALL LETTER EF
			Result [0xF5] := 'х' -- CYRILLIC SMALL LETTER HA
			Result [0xF6] := 'ц' -- CYRILLIC SMALL LETTER TSE
			Result [0xF7] := 'ч' -- CYRILLIC SMALL LETTER CHE
			Result [0xF8] := 'ш' -- CYRILLIC SMALL LETTER SHA
			Result [0xF9] := 'щ' -- CYRILLIC SMALL LETTER SHCHA
			Result [0xFA] := 'ъ' -- CYRILLIC SMALL LETTER HARD SIGN
			Result [0xFB] := 'ы' -- CYRILLIC SMALL LETTER YERU
			Result [0xFC] := 'ь' -- CYRILLIC SMALL LETTER SOFT SIGN
			Result [0xFD] := 'э' -- CYRILLIC SMALL LETTER E
			Result [0xFE] := 'ю' -- CYRILLIC SMALL LETTER YU
			Result [0xFF] := 'я' -- CYRILLIC SMALL LETTER YA
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

end
