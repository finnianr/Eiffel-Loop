note
	description: "Codec for WINDOWS_1256 automatically generated from decoder.c in VTD-XML source"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "4"

class
	EL_WINDOWS_1256_CODEC

inherit
	EL_WINDOWS_CODEC

create
	make

feature {NONE} -- Initialization

	initialize_latin_sets
		do
			latin_set_1 := latin_set_from_array (<<
				193, -- 'ء'
				194, -- 'آ'
				195, -- 'أ'
				196, -- 'ؤ'
				197, -- 'إ'
				198, -- 'ئ'
				199, -- 'ا'
				200, -- 'ب'
				201, -- 'ة'
				202, -- 'ت'
				203, -- 'ث'
				204, -- 'ج'
				205, -- 'ح'
				206, -- 'خ'
				207, -- 'د'
				208, -- 'ذ'
				209, -- 'ر'
				210, -- 'ز'
				211, -- 'س'
				212, -- 'ش'
				213, -- 'ص'
				214, -- 'ض'
				216, -- 'ط'
				217, -- 'ظ'
				218, -- 'ع'
				219  -- 'غ'
			>>)
			latin_set_2 := latin_set_from_array (<<
				220, -- 'ـ'
				221, -- 'ف'
				222, -- 'ق'
				223, -- 'ك'
				225, -- 'ل'
				227, -- 'م'
				228, -- 'ن'
				229, -- 'ه'
				230, -- 'و'
				236, -- 'ى'
				237, -- 'ي'
				240, -- 'ً'
				241, -- 'ٌ'
				242, -- 'ٍ'
				243, -- 'َ'
				245, -- 'ُ'
				246, -- 'ِ'
				248, -- 'ّ'
				250  -- 'ْ'
			>>)
			latin_set_3 := latin_set_from_array (<<
				157, -- '‌'
				158, -- '‍'
				253, -- '‎'
				254  -- '‏'
			>>)
			latin_set_4 := latin_set_from_array (<<
				147, -- '“'
				148, -- '”'
				132  -- '„'
			>>)
			latin_set_5 := latin_set_from_array (<<
				134, -- '†'
				135, -- '‡'
				149  -- '•'
			>>)
			latin_set_6 := latin_set_from_array (<<
				145, -- '‘'
				146, -- '’'
				130  -- '‚'
			>>)
			latin_set_7 := latin_set_from_array (<<
				140, -- 'Œ'
				156  -- 'œ'
			>>)
			latin_set_8 := latin_set_from_array (<<
				139, -- '‹'
				155  -- '›'
			>>)
			latin_set_9 := latin_set_from_array (<<
				150, -- '–'
				151  -- '—'
			>>)
		end

feature -- Access

	id: INTEGER = 1256

feature -- Conversion

	as_upper (code: NATURAL): NATURAL
		local
			offset: NATURAL
		do
			inspect code
				when 97..122 then
					offset := 32
				when 156 then
					offset := 16

			else end
			Result := code - offset
		end

	as_lower (code: NATURAL): NATURAL
		local
			offset: NATURAL
		do
			inspect code
				when 65..90 then
					offset := 32
				when 140 then
					offset := 16

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
				-- à -> À
				when 224 then
					Result := 'À'
				-- â -> Â
				when 226 then
					Result := 'Â'
				-- ç -> Ç
				when 231 then
					Result := 'Ç'
				-- è -> È
				when 232 then
					Result := 'È'
				-- é -> É
				when 233 then
					Result := 'É'
				-- ê -> Ê
				when 234 then
					Result := 'Ê'
				-- ë -> Ë
				when 235 then
					Result := 'Ë'
				-- î -> Î
				when 238 then
					Result := 'Î'
				-- ï -> Ï
				when 239 then
					Result := 'Ï'
				-- ô -> Ô
				when 244 then
					Result := 'Ô'
				-- ù -> Ù
				when 249 then
					Result := 'Ù'
				-- û -> Û
				when 251 then
					Result := 'Û'
				-- ü -> Ü
				when 252 then
					Result := 'Ü'
			else end
		end

	latin_character (uc: CHARACTER_32; unicode: INTEGER): CHARACTER
			-- unicode to latin translation
			-- Returns '%U' if translation is the same as ISO-8859-1 or else not in WINDOWS_1256
		do
			inspect uc
				when 'ء'..'غ' then
					Result := latin_set_1 [unicode - 1569]
				when 'ـ'..'ْ' then
					Result := latin_set_2 [unicode - 1600]
				when '‌'..'‏' then
					Result := latin_set_3 [unicode - 8204]
				when '“'..'„' then
					Result := latin_set_4 [unicode - 8220]
				when '†'..'•' then
					Result := latin_set_5 [unicode - 8224]
				when '‘'..'‚' then
					Result := latin_set_6 [unicode - 8216]
				when 'Œ'..'œ' then
					Result := latin_set_7 [unicode - 338]
				when '‹'..'›' then
					Result := latin_set_8 [unicode - 8249]
				when '–'..'—' then
					Result := latin_set_9 [unicode - 8211]
				when 'ہ' then
					Result := '%/192/'
				when 'ے' then
					Result := '%/255/'
				when '™' then
					Result := '%/153/'
				when '€' then
					Result := '%/128/'
				when 'ھ' then
					Result := '%/170/'
				when '‰' then
					Result := '%/137/'
				when '…' then
					Result := '%/133/'
				when 'ٹ' then
					Result := '%/138/'
				when 'ں' then
					Result := '%/159/'
				when 'پ' then
					Result := '%/129/'
				when '؟' then
					Result := '%/191/'
				when '،' then
					Result := '%/161/'
				when 'ˆ' then
					Result := '%/136/'
				when 'ƒ' then
					Result := '%/131/'
				when '؛' then
					Result := '%/186/'
				when 'ژ' then
					Result := '%/142/'
				when 'ک' then
					Result := '%/152/'
				when 'چ' then
					Result := '%/141/'
				when 'گ' then
					Result := '%/144/'
				when 'ڑ' then
					Result := '%/154/'
				when 'ڈ' then
					Result := '%/143/'
			else end
		end

feature -- Character query

	is_alpha (code: NATURAL): BOOLEAN
		do
			inspect code 
				when 65..90, 97..122, 131, 140, 156, 181, 224, 226, 231..235, 238..239, 244, 249, 251..252 then
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
				when 97..122, 156 then
					Result := True
			else
			end
		end

	is_lower (code: NATURAL): BOOLEAN
		do
			inspect code 
				when 65..90, 140 then
					Result := True

				-- Characters which are only available in a single case
				when 131, 181, 224, 226, 231, 232, 233, 234, 235, 238, 239, 244, 249, 251, 252 then
					Result := True

			else
			end
		end

feature {NONE} -- Implementation

	create_unicode_table: SPECIAL [CHARACTER_32]
			-- Unicode value indexed by WINDOWS_1256 character values
		do
			Result := single_byte_unicode_chars
			Result [0x80] := '€' -- EURO SIGN
			Result [0x81] := 'پ' -- ARABIC LETTER PEH
			Result [0x82] := '‚' -- SINGLE LOW-9 QUOTATION MARK
			Result [0x83] := 'ƒ' -- LATIN SMALL LETTER F WITH HOOK
			Result [0x84] := '„' -- DOUBLE LOW-9 QUOTATION MARK
			Result [0x85] := '…' -- HORIZONTAL ELLIPSIS
			Result [0x86] := '†' -- DAGGER
			Result [0x87] := '‡' -- DOUBLE DAGGER
			Result [0x88] := 'ˆ' -- MODIFIER LETTER CIRCUMFLEX ACCENT
			Result [0x89] := '‰' -- PER MILLE SIGN
			Result [0x8A] := 'ٹ' -- ARABIC LETTER TTEH
			Result [0x8B] := '‹' -- SINGLE LEFT-POINTING ANGLE QUOTATION MARK
			Result [0x8C] := 'Œ' -- LATIN CAPITAL LIGATURE OE
			Result [0x8D] := 'چ' -- ARABIC LETTER TCHEH
			Result [0x8E] := 'ژ' -- ARABIC LETTER JEH
			Result [0x8F] := 'ڈ' -- ARABIC LETTER DDAL
			Result [0x90] := 'گ' -- ARABIC LETTER GAF
			Result [0x91] := '‘' -- LEFT SINGLE QUOTATION MARK
			Result [0x92] := '’' -- RIGHT SINGLE QUOTATION MARK
			Result [0x93] := '“' -- LEFT DOUBLE QUOTATION MARK
			Result [0x94] := '”' -- RIGHT DOUBLE QUOTATION MARK
			Result [0x95] := '•' -- BULLET
			Result [0x96] := '–' -- EN DASH
			Result [0x97] := '—' -- EM DASH
			Result [0x98] := 'ک' -- ARABIC LETTER KEHEH
			Result [0x99] := '™' -- TRADE MARK SIGN
			Result [0x9A] := 'ڑ' -- ARABIC LETTER RREH
			Result [0x9B] := '›' -- SINGLE RIGHT-POINTING ANGLE QUOTATION MARK
			Result [0x9C] := 'œ' -- LATIN SMALL LIGATURE OE
			Result [0x9D] := '‌' -- ZERO WIDTH NON-JOINER
			Result [0x9E] := '‍' -- ZERO WIDTH JOINER
			Result [0x9F] := 'ں' -- ARABIC LETTER NOON GHUNNA
			Result [0xA0] := ' ' -- NO-BREAK SPACE
			Result [0xA1] := '،' -- ARABIC COMMA
			Result [0xA2] := '¢' -- CENT SIGN
			Result [0xA3] := '£' -- POUND SIGN
			Result [0xA4] := '¤' -- CURRENCY SIGN
			Result [0xA5] := '¥' -- YEN SIGN
			Result [0xA6] := '¦' -- BROKEN BAR
			Result [0xA7] := '§' -- SECTION SIGN
			Result [0xA8] := '¨' -- DIAERESIS
			Result [0xA9] := '©' -- COPYRIGHT SIGN
			Result [0xAA] := 'ھ' -- ARABIC LETTER HEH DOACHASHMEE
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
			Result [0xBA] := '؛' -- ARABIC SEMICOLON
			Result [0xBB] := '»' -- RIGHT-POINTING DOUBLE ANGLE QUOTATION MARK
			Result [0xBC] := '¼' -- VULGAR FRACTION ONE QUARTER
			Result [0xBD] := '½' -- VULGAR FRACTION ONE HALF
			Result [0xBE] := '¾' -- VULGAR FRACTION THREE QUARTERS
			Result [0xBF] := '؟' -- ARABIC QUESTION MARK
			Result [0xC0] := 'ہ' -- ARABIC LETTER HEH GOAL
			Result [0xC1] := 'ء' -- ARABIC LETTER HAMZA
			Result [0xC2] := 'آ' -- ARABIC LETTER ALEF WITH MADDA ABOVE
			Result [0xC3] := 'أ' -- ARABIC LETTER ALEF WITH HAMZA ABOVE
			Result [0xC4] := 'ؤ' -- ARABIC LETTER WAW WITH HAMZA ABOVE
			Result [0xC5] := 'إ' -- ARABIC LETTER ALEF WITH HAMZA BELOW
			Result [0xC6] := 'ئ' -- ARABIC LETTER YEH WITH HAMZA ABOVE
			Result [0xC7] := 'ا' -- ARABIC LETTER ALEF
			Result [0xC8] := 'ب' -- ARABIC LETTER BEH
			Result [0xC9] := 'ة' -- ARABIC LETTER TEH MARBUTA
			Result [0xCA] := 'ت' -- ARABIC LETTER TEH
			Result [0xCB] := 'ث' -- ARABIC LETTER THEH
			Result [0xCC] := 'ج' -- ARABIC LETTER JEEM
			Result [0xCD] := 'ح' -- ARABIC LETTER HAH
			Result [0xCE] := 'خ' -- ARABIC LETTER KHAH
			Result [0xCF] := 'د' -- ARABIC LETTER DAL
			Result [0xD0] := 'ذ' -- ARABIC LETTER THAL
			Result [0xD1] := 'ر' -- ARABIC LETTER REH
			Result [0xD2] := 'ز' -- ARABIC LETTER ZAIN
			Result [0xD3] := 'س' -- ARABIC LETTER SEEN
			Result [0xD4] := 'ش' -- ARABIC LETTER SHEEN
			Result [0xD5] := 'ص' -- ARABIC LETTER SAD
			Result [0xD6] := 'ض' -- ARABIC LETTER DAD
			Result [0xD7] := '×' -- MULTIPLICATION SIGN
			Result [0xD8] := 'ط' -- ARABIC LETTER TAH
			Result [0xD9] := 'ظ' -- ARABIC LETTER ZAH
			Result [0xDA] := 'ع' -- ARABIC LETTER AIN
			Result [0xDB] := 'غ' -- ARABIC LETTER GHAIN
			Result [0xDC] := 'ـ' -- ARABIC TATWEEL
			Result [0xDD] := 'ف' -- ARABIC LETTER FEH
			Result [0xDE] := 'ق' -- ARABIC LETTER QAF
			Result [0xDF] := 'ك' -- ARABIC LETTER KAF
			Result [0xE0] := 'à' -- LATIN SMALL LETTER A WITH GRAVE
			Result [0xE1] := 'ل' -- ARABIC LETTER LAM
			Result [0xE2] := 'â' -- LATIN SMALL LETTER A WITH CIRCUMFLEX
			Result [0xE3] := 'م' -- ARABIC LETTER MEEM
			Result [0xE4] := 'ن' -- ARABIC LETTER NOON
			Result [0xE5] := 'ه' -- ARABIC LETTER HEH
			Result [0xE6] := 'و' -- ARABIC LETTER WAW
			Result [0xE7] := 'ç' -- LATIN SMALL LETTER C WITH CEDILLA
			Result [0xE8] := 'è' -- LATIN SMALL LETTER E WITH GRAVE
			Result [0xE9] := 'é' -- LATIN SMALL LETTER E WITH ACUTE
			Result [0xEA] := 'ê' -- LATIN SMALL LETTER E WITH CIRCUMFLEX
			Result [0xEB] := 'ë' -- LATIN SMALL LETTER E WITH DIAERESIS
			Result [0xEC] := 'ى' -- ARABIC LETTER ALEF MAKSURA
			Result [0xED] := 'ي' -- ARABIC LETTER YEH
			Result [0xEE] := 'î' -- LATIN SMALL LETTER I WITH CIRCUMFLEX
			Result [0xEF] := 'ï' -- LATIN SMALL LETTER I WITH DIAERESIS
			Result [0xF0] := 'ً' -- ARABIC FATHATAN
			Result [0xF1] := 'ٌ' -- ARABIC DAMMATAN
			Result [0xF2] := 'ٍ' -- ARABIC KASRATAN
			Result [0xF3] := 'َ' -- ARABIC FATHA
			Result [0xF4] := 'ô' -- LATIN SMALL LETTER O WITH CIRCUMFLEX
			Result [0xF5] := 'ُ' -- ARABIC DAMMA
			Result [0xF6] := 'ِ' -- ARABIC KASRA
			Result [0xF7] := '÷' -- DIVISION SIGN
			Result [0xF8] := 'ّ' -- ARABIC SHADDA
			Result [0xF9] := 'ù' -- LATIN SMALL LETTER U WITH GRAVE
			Result [0xFA] := 'ْ' -- ARABIC SUKUN
			Result [0xFB] := 'û' -- LATIN SMALL LETTER U WITH CIRCUMFLEX
			Result [0xFC] := 'ü' -- LATIN SMALL LETTER U WITH DIAERESIS
			Result [0xFD] := '‎' -- LEFT-TO-RIGHT MARK
			Result [0xFE] := '‏' -- RIGHT-TO-LEFT MARK
			Result [0xFF] := 'ے' -- ARABIC LETTER YEH BARREE
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

end
