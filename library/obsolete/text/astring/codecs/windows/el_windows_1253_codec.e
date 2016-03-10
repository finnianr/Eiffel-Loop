note
	description: "Codec for WINDOWS_1253 automatically generated from decoder.c in VTD-XML source"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "4"

class
	EL_WINDOWS_1253_CODEC

inherit
	EL_WINDOWS_CODEC

create
	make

feature {NONE} -- Initialization

	initialize_latin_sets
		do
			latin_set_1 := latin_set_from_array (<<
				211, -- 'Σ'
				212, -- 'Τ'
				213, -- 'Υ'
				214, -- 'Φ'
				215, -- 'Χ'
				216, -- 'Ψ'
				217, -- 'Ω'
				218, -- 'Ϊ'
				219, -- 'Ϋ'
				220, -- 'ά'
				221, -- 'έ'
				222, -- 'ή'
				223, -- 'ί'
				224, -- 'ΰ'
				225, -- 'α'
				226, -- 'β'
				227, -- 'γ'
				228, -- 'δ'
				229, -- 'ε'
				230, -- 'ζ'
				231, -- 'η'
				232, -- 'θ'
				233, -- 'ι'
				234, -- 'κ'
				235, -- 'λ'
				236, -- 'μ'
				237, -- 'ν'
				238, -- 'ξ'
				239, -- 'ο'
				240, -- 'π'
				241, -- 'ρ'
				242, -- 'ς'
				243, -- 'σ'
				244, -- 'τ'
				245, -- 'υ'
				246, -- 'φ'
				247, -- 'χ'
				248, -- 'ψ'
				249, -- 'ω'
				250, -- 'ϊ'
				251, -- 'ϋ'
				252, -- 'ό'
				253, -- 'ύ'
				254  -- 'ώ'
			>>)
			latin_set_2 := latin_set_from_array (<<
				190, -- 'Ύ'
				191, -- 'Ώ'
				192, -- 'ΐ'
				193, -- 'Α'
				194, -- 'Β'
				195, -- 'Γ'
				196, -- 'Δ'
				197, -- 'Ε'
				198, -- 'Ζ'
				199, -- 'Η'
				200, -- 'Θ'
				201, -- 'Ι'
				202, -- 'Κ'
				203, -- 'Λ'
				204, -- 'Μ'
				205, -- 'Ν'
				206, -- 'Ξ'
				207, -- 'Ο'
				208, -- 'Π'
				209  -- 'Ρ'
			>>)
			latin_set_3 := latin_set_from_array (<<
				147, -- '“'
				148, -- '”'
				132  -- '„'
			>>)
			latin_set_4 := latin_set_from_array (<<
				145, -- '‘'
				146, -- '’'
				130  -- '‚'
			>>)
			latin_set_5 := latin_set_from_array (<<
				150, -- '–'
				151, -- '—'
				175  -- '―'
			>>)
			latin_set_6 := latin_set_from_array (<<
				184, -- 'Έ'
				185, -- 'Ή'
				186  -- 'Ί'
			>>)
			latin_set_7 := latin_set_from_array (<<
				134, -- '†'
				135, -- '‡'
				149  -- '•'
			>>)
			latin_set_8 := latin_set_from_array (<<
				180, -- '΄'
				161, -- '΅'
				162  -- 'Ά'
			>>)
			latin_set_9 := latin_set_from_array (<<
				139, -- '‹'
				155  -- '›'
			>>)
		end

feature -- Access

	id: INTEGER = 1253

feature -- Conversion

	as_upper (code: NATURAL): NATURAL
		local
			offset: NATURAL
		do
			inspect code
				when 97..122, 225..241, 243..251 then
					offset := 32
				when 181 then
					offset := 23
				when 192 then
					offset := 26
				when 220 then
					offset := 58
				when 221..223 then
					offset := 37
				when 224 then
					offset := 5
				when 242 then
					offset := 31
				when 252 then
					offset := 64
				when 253..254 then
					offset := 63

			else end
			Result := code - offset
		end

	as_lower (code: NATURAL): NATURAL
		local
			offset: NATURAL
		do
			inspect code
				when 65..90, 193..209, 211..219 then
					offset := 32
				when 162 then
					offset := 58
				when 184..186 then
					offset := 37
				when 188 then
					offset := 64
				when 190..191 then
					offset := 63

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
				-- Ò -> ò
				when 210 then
					Result := 'ò'
				-- ÿ -> Ÿ
				when 255 then
					Result := 'Ÿ'
			else end
		end

	latin_character (uc: CHARACTER_32; unicode: INTEGER): CHARACTER
			-- unicode to latin translation
			-- Returns '%U' if translation is the same as ISO-8859-1 or else not in WINDOWS_1253
		do
			inspect uc
				when 'Σ'..'ώ' then
					Result := latin_set_1 [unicode - 931]
				when 'Ύ'..'Ρ' then
					Result := latin_set_2 [unicode - 910]
				when '“'..'„' then
					Result := latin_set_3 [unicode - 8220]
				when '‘'..'‚' then
					Result := latin_set_4 [unicode - 8216]
				when '–'..'―' then
					Result := latin_set_5 [unicode - 8211]
				when 'Έ'..'Ί' then
					Result := latin_set_6 [unicode - 904]
				when '†'..'•' then
					Result := latin_set_7 [unicode - 8224]
				when '΄'..'Ά' then
					Result := latin_set_8 [unicode - 900]
				when '‹'..'›' then
					Result := latin_set_9 [unicode - 8249]
				when '™' then
					Result := '%/153/'
				when '€' then
					Result := '%/128/'
				when '‰' then
					Result := '%/137/'
				when 'Ό' then
					Result := '%/188/'
				when 'ƒ' then
					Result := '%/131/'
				when '…' then
					Result := '%/133/'
			else end
		end

feature -- Character query

	is_alpha (code: NATURAL): BOOLEAN
		do
			inspect code 
				when 65..90, 97..122, 131, 162, 181, 184..186, 188, 190..255 then
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
				when 97..122, 225..241, 243..251, 181, 192, 220, 221..223, 224, 242, 252, 253..254 then
					Result := True
			else
			end
		end

	is_lower (code: NATURAL): BOOLEAN
		do
			inspect code 
				when 65..90, 193..209, 211..219, 162, 184..186, 188, 190..191 then
					Result := True

				-- Characters which are only available in a single case
				when 131, 210, 255 then
					Result := True

			else
			end
		end

feature {NONE} -- Implementation

	create_unicode_table: SPECIAL [CHARACTER_32]
			-- Unicode value indexed by WINDOWS_1253 character values
		do
			Result := single_byte_unicode_chars
			Result [0x80] := '€' -- EURO SIGN
			Result [0x82] := '‚' -- SINGLE LOW-9 QUOTATION MARK
			Result [0x83] := 'ƒ' -- LATIN SMALL LETTER F WITH HOOK
			Result [0x84] := '„' -- DOUBLE LOW-9 QUOTATION MARK
			Result [0x85] := '…' -- HORIZONTAL ELLIPSIS
			Result [0x86] := '†' -- DAGGER
			Result [0x87] := '‡' -- DOUBLE DAGGER
			Result [0x89] := '‰' -- PER MILLE SIGN
			Result [0x8B] := '‹' -- SINGLE LEFT-POINTING ANGLE QUOTATION MARK
			Result [0x91] := '‘' -- LEFT SINGLE QUOTATION MARK
			Result [0x92] := '’' -- RIGHT SINGLE QUOTATION MARK
			Result [0x93] := '“' -- LEFT DOUBLE QUOTATION MARK
			Result [0x94] := '”' -- RIGHT DOUBLE QUOTATION MARK
			Result [0x95] := '•' -- BULLET
			Result [0x96] := '–' -- EN DASH
			Result [0x97] := '—' -- EM DASH
			Result [0x99] := '™' -- TRADE MARK SIGN
			Result [0x9B] := '›' -- SINGLE RIGHT-POINTING ANGLE QUOTATION MARK
			Result [0xA0] := ' ' -- NO-BREAK SPACE
			Result [0xA1] := '΅' -- GREEK DIALYTIKA TONOS
			Result [0xA2] := 'Ά' -- GREEK CAPITAL LETTER ALPHA WITH TONOS
			Result [0xA3] := '£' -- POUND SIGN
			Result [0xA4] := '¤' -- CURRENCY SIGN
			Result [0xA5] := '¥' -- YEN SIGN
			Result [0xA6] := '¦' -- BROKEN BAR
			Result [0xA7] := '§' -- SECTION SIGN
			Result [0xA8] := '¨' -- DIAERESIS
			Result [0xA9] := '©' -- COPYRIGHT SIGN
			Result [0xAB] := '«' -- LEFT-POINTING DOUBLE ANGLE QUOTATION MARK
			Result [0xAC] := '¬' -- NOT SIGN
			Result [0xAD] := '­' -- SOFT HYPHEN
			Result [0xAE] := '®' -- REGISTERED SIGN
			Result [0xAF] := '―' -- HORIZONTAL BAR
			Result [0xB0] := '°' -- DEGREE SIGN
			Result [0xB1] := '±' -- PLUS-MINUS SIGN
			Result [0xB2] := '²' -- SUPERSCRIPT TWO
			Result [0xB3] := '³' -- SUPERSCRIPT THREE
			Result [0xB4] := '΄' -- GREEK TONOS
			Result [0xB5] := 'µ' -- MICRO SIGN
			Result [0xB6] := '¶' -- PILCROW SIGN
			Result [0xB7] := '·' -- MIDDLE DOT
			Result [0xB8] := 'Έ' -- GREEK CAPITAL LETTER EPSILON WITH TONOS
			Result [0xB9] := 'Ή' -- GREEK CAPITAL LETTER ETA WITH TONOS
			Result [0xBA] := 'Ί' -- GREEK CAPITAL LETTER IOTA WITH TONOS
			Result [0xBB] := '»' -- RIGHT-POINTING DOUBLE ANGLE QUOTATION MARK
			Result [0xBC] := 'Ό' -- GREEK CAPITAL LETTER OMICRON WITH TONOS
			Result [0xBD] := '½' -- VULGAR FRACTION ONE HALF
			Result [0xBE] := 'Ύ' -- GREEK CAPITAL LETTER UPSILON WITH TONOS
			Result [0xBF] := 'Ώ' -- GREEK CAPITAL LETTER OMEGA WITH TONOS
			Result [0xC0] := 'ΐ' -- GREEK SMALL LETTER IOTA WITH DIALYTIKA AND TONOS
			Result [0xC1] := 'Α' -- GREEK CAPITAL LETTER ALPHA
			Result [0xC2] := 'Β' -- GREEK CAPITAL LETTER BETA
			Result [0xC3] := 'Γ' -- GREEK CAPITAL LETTER GAMMA
			Result [0xC4] := 'Δ' -- GREEK CAPITAL LETTER DELTA
			Result [0xC5] := 'Ε' -- GREEK CAPITAL LETTER EPSILON
			Result [0xC6] := 'Ζ' -- GREEK CAPITAL LETTER ZETA
			Result [0xC7] := 'Η' -- GREEK CAPITAL LETTER ETA
			Result [0xC8] := 'Θ' -- GREEK CAPITAL LETTER THETA
			Result [0xC9] := 'Ι' -- GREEK CAPITAL LETTER IOTA
			Result [0xCA] := 'Κ' -- GREEK CAPITAL LETTER KAPPA
			Result [0xCB] := 'Λ' -- GREEK CAPITAL LETTER LAMDA
			Result [0xCC] := 'Μ' -- GREEK CAPITAL LETTER MU
			Result [0xCD] := 'Ν' -- GREEK CAPITAL LETTER NU
			Result [0xCE] := 'Ξ' -- GREEK CAPITAL LETTER XI
			Result [0xCF] := 'Ο' -- GREEK CAPITAL LETTER OMICRON
			Result [0xD0] := 'Π' -- GREEK CAPITAL LETTER PI
			Result [0xD1] := 'Ρ' -- GREEK CAPITAL LETTER RHO
			Result [0xD3] := 'Σ' -- GREEK CAPITAL LETTER SIGMA
			Result [0xD4] := 'Τ' -- GREEK CAPITAL LETTER TAU
			Result [0xD5] := 'Υ' -- GREEK CAPITAL LETTER UPSILON
			Result [0xD6] := 'Φ' -- GREEK CAPITAL LETTER PHI
			Result [0xD7] := 'Χ' -- GREEK CAPITAL LETTER CHI
			Result [0xD8] := 'Ψ' -- GREEK CAPITAL LETTER PSI
			Result [0xD9] := 'Ω' -- GREEK CAPITAL LETTER OMEGA
			Result [0xDA] := 'Ϊ' -- GREEK CAPITAL LETTER IOTA WITH DIALYTIKA
			Result [0xDB] := 'Ϋ' -- GREEK CAPITAL LETTER UPSILON WITH DIALYTIKA
			Result [0xDC] := 'ά' -- GREEK SMALL LETTER ALPHA WITH TONOS
			Result [0xDD] := 'έ' -- GREEK SMALL LETTER EPSILON WITH TONOS
			Result [0xDE] := 'ή' -- GREEK SMALL LETTER ETA WITH TONOS
			Result [0xDF] := 'ί' -- GREEK SMALL LETTER IOTA WITH TONOS
			Result [0xE0] := 'ΰ' -- GREEK SMALL LETTER UPSILON WITH DIALYTIKA AND TONOS
			Result [0xE1] := 'α' -- GREEK SMALL LETTER ALPHA
			Result [0xE2] := 'β' -- GREEK SMALL LETTER BETA
			Result [0xE3] := 'γ' -- GREEK SMALL LETTER GAMMA
			Result [0xE4] := 'δ' -- GREEK SMALL LETTER DELTA
			Result [0xE5] := 'ε' -- GREEK SMALL LETTER EPSILON
			Result [0xE6] := 'ζ' -- GREEK SMALL LETTER ZETA
			Result [0xE7] := 'η' -- GREEK SMALL LETTER ETA
			Result [0xE8] := 'θ' -- GREEK SMALL LETTER THETA
			Result [0xE9] := 'ι' -- GREEK SMALL LETTER IOTA
			Result [0xEA] := 'κ' -- GREEK SMALL LETTER KAPPA
			Result [0xEB] := 'λ' -- GREEK SMALL LETTER LAMDA
			Result [0xEC] := 'μ' -- GREEK SMALL LETTER MU
			Result [0xED] := 'ν' -- GREEK SMALL LETTER NU
			Result [0xEE] := 'ξ' -- GREEK SMALL LETTER XI
			Result [0xEF] := 'ο' -- GREEK SMALL LETTER OMICRON
			Result [0xF0] := 'π' -- GREEK SMALL LETTER PI
			Result [0xF1] := 'ρ' -- GREEK SMALL LETTER RHO
			Result [0xF2] := 'ς' -- GREEK SMALL LETTER FINAL SIGMA
			Result [0xF3] := 'σ' -- GREEK SMALL LETTER SIGMA
			Result [0xF4] := 'τ' -- GREEK SMALL LETTER TAU
			Result [0xF5] := 'υ' -- GREEK SMALL LETTER UPSILON
			Result [0xF6] := 'φ' -- GREEK SMALL LETTER PHI
			Result [0xF7] := 'χ' -- GREEK SMALL LETTER CHI
			Result [0xF8] := 'ψ' -- GREEK SMALL LETTER PSI
			Result [0xF9] := 'ω' -- GREEK SMALL LETTER OMEGA
			Result [0xFA] := 'ϊ' -- GREEK SMALL LETTER IOTA WITH DIALYTIKA
			Result [0xFB] := 'ϋ' -- GREEK SMALL LETTER UPSILON WITH DIALYTIKA
			Result [0xFC] := 'ό' -- GREEK SMALL LETTER OMICRON WITH TONOS
			Result [0xFD] := 'ύ' -- GREEK SMALL LETTER UPSILON WITH TONOS
			Result [0xFE] := 'ώ' -- GREEK SMALL LETTER OMEGA WITH TONOS
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
