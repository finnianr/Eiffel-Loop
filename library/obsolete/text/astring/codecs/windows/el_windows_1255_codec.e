note
	description: "Codec for WINDOWS_1255 automatically generated from decoder.c in VTD-XML source"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "4"

class
	EL_WINDOWS_1255_CODEC

inherit
	EL_WINDOWS_CODEC

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
			latin_set_2 := latin_set_from_array (<<
				192, -- 'ְ'
				193, -- 'ֱ'
				194, -- 'ֲ'
				195, -- 'ֳ'
				196, -- 'ִ'
				197, -- 'ֵ'
				198, -- 'ֶ'
				199, -- 'ַ'
				200, -- 'ָ'
				201  -- 'ֹ'
			>>)
			latin_set_3 := latin_set_from_array (<<
				203, -- 'ֻ'
				204, -- 'ּ'
				205, -- 'ֽ'
				206, -- '־'
				207, -- 'ֿ'
				208, -- '׀'
				209, -- 'ׁ'
				210, -- 'ׂ'
				211  -- '׃'
			>>)
			latin_set_4 := latin_set_from_array (<<
				212, -- 'װ'
				213, -- 'ױ'
				214, -- 'ײ'
				215, -- '׳'
				216  -- '״'
			>>)
			latin_set_5 := latin_set_from_array (<<
				145, -- '‘'
				146, -- '’'
				130  -- '‚'
			>>)
			latin_set_6 := latin_set_from_array (<<
				147, -- '“'
				148, -- '”'
				132  -- '„'
			>>)
			latin_set_7 := latin_set_from_array (<<
				134, -- '†'
				135, -- '‡'
				149  -- '•'
			>>)
			latin_set_8 := latin_set_from_array (<<
				150, -- '–'
				151  -- '—'
			>>)
			latin_set_9 := latin_set_from_array (<<
				139, -- '‹'
				155  -- '›'
			>>)
			latin_set_10 := latin_set_from_array (<<
				253, -- '‎'
				254  -- '‏'
			>>)
		end

feature -- Access

	id: INTEGER = 1255

feature -- Conversion

	as_upper (code: NATURAL): NATURAL
		local
			offset: NATURAL
		do
			inspect code
				when 97..122, 251..252 then
					offset := 32

			else end
			Result := code - offset
		end

	as_lower (code: NATURAL): NATURAL
		local
			offset: NATURAL
		do
			inspect code
				when 65..90, 219..220 then
					offset := 32

			else end
			Result := code + offset
		end

	unicode_case_change_substitute (code: NATURAL): CHARACTER_32
			-- Returns Unicode case change character if c does not have a latin case change
			-- or else the Null character
		do
			inspect code
				-- ƒ -> Ƒ
				when 131 then
					Result := 'Ƒ'
				-- µ -> Μ
				when 181 then
					Result := 'Μ'
				-- Ê -> ê
				when 202 then
					Result := 'ê'
				-- Ù -> ù
				when 217 then
					Result := 'ù'
				-- Ú -> ú
				when 218 then
					Result := 'ú'
				-- Ý -> ý
				when 221 then
					Result := 'ý'
				-- Þ -> þ
				when 222 then
					Result := 'þ'
				-- ÿ -> Ÿ
				when 255 then
					Result := 'Ÿ'
			else end
		end

	latin_character (uc: CHARACTER_32; unicode: INTEGER): CHARACTER
			-- unicode to latin translation
			-- Returns '%U' if translation is the same as ISO-8859-1 or else not in WINDOWS_1255
		do
			inspect uc
				when 'א'..'ת' then
					Result := latin_set_1 [unicode - 1488]
				when 'ְ'..'ֹ' then
					Result := latin_set_2 [unicode - 1456]
				when 'ֻ'..'׃' then
					Result := latin_set_3 [unicode - 1467]
				when 'װ'..'״' then
					Result := latin_set_4 [unicode - 1520]
				when '‘'..'‚' then
					Result := latin_set_5 [unicode - 8216]
				when '“'..'„' then
					Result := latin_set_6 [unicode - 8220]
				when '†'..'•' then
					Result := latin_set_7 [unicode - 8224]
				when '–'..'—' then
					Result := latin_set_8 [unicode - 8211]
				when '‹'..'›' then
					Result := latin_set_9 [unicode - 8249]
				when '‎'..'‏' then
					Result := latin_set_10 [unicode - 8206]
				when 'ƒ' then
					Result := '%/131/'
				when '₪' then
					Result := '%/164/'
				when '™' then
					Result := '%/153/'
				when '€' then
					Result := '%/128/'
				when '‰' then
					Result := '%/137/'
				when '˜' then
					Result := '%/152/'
				when 'ˆ' then
					Result := '%/136/'
				when '×' then
					Result := '%/170/'
				when '÷' then
					Result := '%/186/'
				when '…' then
					Result := '%/133/'
			else end
		end

feature -- Character query

	is_alpha (code: NATURAL): BOOLEAN
		do
			inspect code 
				when 65..90, 97..122, 131, 181, 202, 217..223, 251..252, 255 then
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
				when 97..122, 251..252 then
					Result := True
			else
			end
		end

	is_lower (code: NATURAL): BOOLEAN
		do
			inspect code 
				when 65..90, 219..220 then
					Result := True

				-- Characters which are only available in a single case
				when 131, 181, 202, 217, 218, 221, 222, 223, 255 then
					Result := True

			else
			end
		end

feature {NONE} -- Implementation

	create_unicode_table: SPECIAL [CHARACTER_32]
			-- Unicode value indexed by WINDOWS_1255 character values
		do
			Result := single_byte_unicode_chars
			Result [0x80] := '€' -- EURO SIGN
			Result [0x82] := '‚' -- SINGLE LOW-9 QUOTATION MARK
			Result [0x83] := 'ƒ' -- LATIN SMALL LETTER F WITH HOOK
			Result [0x84] := '„' -- DOUBLE LOW-9 QUOTATION MARK
			Result [0x85] := '…' -- HORIZONTAL ELLIPSIS
			Result [0x86] := '†' -- DAGGER
			Result [0x87] := '‡' -- DOUBLE DAGGER
			Result [0x88] := 'ˆ' -- MODIFIER LETTER CIRCUMFLEX ACCENT
			Result [0x89] := '‰' -- PER MILLE SIGN
			Result [0x8B] := '‹' -- SINGLE LEFT-POINTING ANGLE QUOTATION MARK
			Result [0x91] := '‘' -- LEFT SINGLE QUOTATION MARK
			Result [0x92] := '’' -- RIGHT SINGLE QUOTATION MARK
			Result [0x93] := '“' -- LEFT DOUBLE QUOTATION MARK
			Result [0x94] := '”' -- RIGHT DOUBLE QUOTATION MARK
			Result [0x95] := '•' -- BULLET
			Result [0x96] := '–' -- EN DASH
			Result [0x97] := '—' -- EM DASH
			Result [0x98] := '˜' -- SMALL TILDE
			Result [0x99] := '™' -- TRADE MARK SIGN
			Result [0x9B] := '›' -- SINGLE RIGHT-POINTING ANGLE QUOTATION MARK
			Result [0xA0] := ' ' -- NO-BREAK SPACE
			Result [0xA1] := '¡' -- INVERTED EXCLAMATION MARK
			Result [0xA2] := '¢' -- CENT SIGN
			Result [0xA3] := '£' -- POUND SIGN
			Result [0xA4] := '₪' -- NEW SHEQEL SIGN
			Result [0xA5] := '¥' -- YEN SIGN
			Result [0xA6] := '¦' -- BROKEN BAR
			Result [0xA7] := '§' -- SECTION SIGN
			Result [0xA8] := '¨' -- DIAERESIS
			Result [0xA9] := '©' -- COPYRIGHT SIGN
			Result [0xAA] := '×' -- MULTIPLICATION SIGN
			Result [0xAB] := '«' -- LEFT-POINTING DOUBLE ANGLE QUOTATION MARK
			Result [0xAC] := '¬' -- NOT SIGN
			Result [0xAD] := '­' -- SOFT HYPHEN
			Result [0xAE] := '®' -- REGISTERED SIGN
			Result [0xAF] := '¯' -- MACRON
			Result [0xB0] := '°' -- DEGREE SIGN
			Result [0xB1] := '±' -- PLUS-MINUS SIGN
			Result [0xB2] := '²' -- SUPERSCRIPT TWO
			Result [0xB3] := '³' -- SUPERSCRIPT THREE
			Result [0xB4] := '´' -- ACUTE ACCENT
			Result [0xB5] := 'µ' -- MICRO SIGN
			Result [0xB6] := '¶' -- PILCROW SIGN
			Result [0xB7] := '·' -- MIDDLE DOT
			Result [0xB8] := '¸' -- CEDILLA
			Result [0xB9] := '¹' -- SUPERSCRIPT ONE
			Result [0xBA] := '÷' -- DIVISION SIGN
			Result [0xBB] := '»' -- RIGHT-POINTING DOUBLE ANGLE QUOTATION MARK
			Result [0xBC] := '¼' -- VULGAR FRACTION ONE QUARTER
			Result [0xBD] := '½' -- VULGAR FRACTION ONE HALF
			Result [0xBE] := '¾' -- VULGAR FRACTION THREE QUARTERS
			Result [0xBF] := '¿' -- INVERTED QUESTION MARK
			Result [0xC0] := 'ְ' -- HEBREW POINT SHEVA
			Result [0xC1] := 'ֱ' -- HEBREW POINT HATAF SEGOL
			Result [0xC2] := 'ֲ' -- HEBREW POINT HATAF PATAH
			Result [0xC3] := 'ֳ' -- HEBREW POINT HATAF QAMATS
			Result [0xC4] := 'ִ' -- HEBREW POINT HIRIQ
			Result [0xC5] := 'ֵ' -- HEBREW POINT TSERE
			Result [0xC6] := 'ֶ' -- HEBREW POINT SEGOL
			Result [0xC7] := 'ַ' -- HEBREW POINT PATAH
			Result [0xC8] := 'ָ' -- HEBREW POINT QAMATS
			Result [0xC9] := 'ֹ' -- HEBREW POINT HOLAM
			Result [0xCB] := 'ֻ' -- HEBREW POINT QUBUTS
			Result [0xCC] := 'ּ' -- HEBREW POINT DAGESH OR MAPIQ
			Result [0xCD] := 'ֽ' -- HEBREW POINT METEG
			Result [0xCE] := '־' -- HEBREW PUNCTUATION MAQAF
			Result [0xCF] := 'ֿ' -- HEBREW POINT RAFE
			Result [0xD0] := '׀' -- HEBREW PUNCTUATION PASEQ
			Result [0xD1] := 'ׁ' -- HEBREW POINT SHIN DOT
			Result [0xD2] := 'ׂ' -- HEBREW POINT SIN DOT
			Result [0xD3] := '׃' -- HEBREW PUNCTUATION SOF PASUQ
			Result [0xD4] := 'װ' -- HEBREW LIGATURE YIDDISH DOUBLE VAV
			Result [0xD5] := 'ױ' -- HEBREW LIGATURE YIDDISH VAV YOD
			Result [0xD6] := 'ײ' -- HEBREW LIGATURE YIDDISH DOUBLE YOD
			Result [0xD7] := '׳' -- HEBREW PUNCTUATION GERESH
			Result [0xD8] := '״' -- HEBREW PUNCTUATION GERSHAYIM
			Result [0xE0] := 'א' -- HEBREW LETTER ALEF
			Result [0xE1] := 'ב' -- HEBREW LETTER BET
			Result [0xE2] := 'ג' -- HEBREW LETTER GIMEL
			Result [0xE3] := 'ד' -- HEBREW LETTER DALET
			Result [0xE4] := 'ה' -- HEBREW LETTER HE
			Result [0xE5] := 'ו' -- HEBREW LETTER VAV
			Result [0xE6] := 'ז' -- HEBREW LETTER ZAYIN
			Result [0xE7] := 'ח' -- HEBREW LETTER HET
			Result [0xE8] := 'ט' -- HEBREW LETTER TET
			Result [0xE9] := 'י' -- HEBREW LETTER YOD
			Result [0xEA] := 'ך' -- HEBREW LETTER FINAL KAF
			Result [0xEB] := 'כ' -- HEBREW LETTER KAF
			Result [0xEC] := 'ל' -- HEBREW LETTER LAMED
			Result [0xED] := 'ם' -- HEBREW LETTER FINAL MEM
			Result [0xEE] := 'מ' -- HEBREW LETTER MEM
			Result [0xEF] := 'ן' -- HEBREW LETTER FINAL NUN
			Result [0xF0] := 'נ' -- HEBREW LETTER NUN
			Result [0xF1] := 'ס' -- HEBREW LETTER SAMEKH
			Result [0xF2] := 'ע' -- HEBREW LETTER AYIN
			Result [0xF3] := 'ף' -- HEBREW LETTER FINAL PE
			Result [0xF4] := 'פ' -- HEBREW LETTER PE
			Result [0xF5] := 'ץ' -- HEBREW LETTER FINAL TSADI
			Result [0xF6] := 'צ' -- HEBREW LETTER TSADI
			Result [0xF7] := 'ק' -- HEBREW LETTER QOF
			Result [0xF8] := 'ר' -- HEBREW LETTER RESH
			Result [0xF9] := 'ש' -- HEBREW LETTER SHIN
			Result [0xFA] := 'ת' -- HEBREW LETTER TAV
			Result [0xFD] := '‎' -- LEFT-TO-RIGHT MARK
			Result [0xFE] := '‏' -- RIGHT-TO-LEFT MARK
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
