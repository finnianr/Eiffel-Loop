note
	description: "Codec for ISO_8859_3 automatically generated from decoder.c in VTD-XML source"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "4"

class
	EL_ISO_8859_3_CODEC

inherit
	EL_ISO_8859_CODEC

create
	make

feature {NONE} -- Initialization

	initialize_latin_sets
		do
			latin_set_1 := latin_set_from_array (<<
				216, -- 'Ĝ'
				248, -- 'ĝ'
				171, -- 'Ğ'
				187, -- 'ğ'
				213, -- 'Ġ'
				245  -- 'ġ'
			>>)
			latin_set_2 := latin_set_from_array (<<
				222, -- 'Ŝ'
				254, -- 'ŝ'
				170, -- 'Ş'
				186  -- 'ş'
			>>)
			latin_set_3 := latin_set_from_array (<<
				166, -- 'Ĥ'
				182, -- 'ĥ'
				161, -- 'Ħ'
				177  -- 'ħ'
			>>)
			latin_set_4 := latin_set_from_array (<<
				198, -- 'Ĉ'
				230, -- 'ĉ'
				197, -- 'Ċ'
				229  -- 'ċ'
			>>)
			latin_set_5 := latin_set_from_array (<<
				175, -- 'Ż'
				191  -- 'ż'
			>>)
			latin_set_6 := latin_set_from_array (<<
				162, -- '˘'
				255  -- '˙'
			>>)
			latin_set_7 := latin_set_from_array (<<
				221, -- 'Ŭ'
				253  -- 'ŭ'
			>>)
			latin_set_8 := latin_set_from_array (<<
				169, -- 'İ'
				185  -- 'ı'
			>>)
			latin_set_9 := latin_set_from_array (<<
				172, -- 'Ĵ'
				188  -- 'ĵ'
			>>)
		end

feature -- Access

	id: INTEGER = 3

feature -- Conversion

	as_upper (code: NATURAL): NATURAL
		local
			offset: NATURAL
		do
			inspect code
				when 97..122, 224..246, 248..254 then
					offset := 32
				when 177, 182, 186..188, 191 then
					offset := 16
				when 185 then
					offset := 112

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
				when 161, 166, 170..172, 175 then
					offset := 16
				when 169 then
					offset := 64

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
			-- Returns '%U' if translation is the same as ISO-8859-1 or else not in ISO_8859_3
		do
			inspect uc
				when 'Ĝ'..'ġ' then
					Result := latin_set_1 [unicode - 284]
				when 'Ŝ'..'ş' then
					Result := latin_set_2 [unicode - 348]
				when 'Ĥ'..'ħ' then
					Result := latin_set_3 [unicode - 292]
				when 'Ĉ'..'ċ' then
					Result := latin_set_4 [unicode - 264]
				when 'Ż'..'ż' then
					Result := latin_set_5 [unicode - 379]
				when '˘'..'˙' then
					Result := latin_set_6 [unicode - 728]
				when 'Ŭ'..'ŭ' then
					Result := latin_set_7 [unicode - 364]
				when 'İ'..'ı' then
					Result := latin_set_8 [unicode - 304]
				when 'Ĵ'..'ĵ' then
					Result := latin_set_9 [unicode - 308]
			else end
		end

feature -- Character query

	is_alpha (code: NATURAL): BOOLEAN
		do
			inspect code 
				when 65..90, 97..122, 161, 166, 169..172, 175, 177, 181..182, 185..188, 191..214, 216..246, 248..254 then
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
				when 97..122, 224..246, 248..254, 177, 182, 186..188, 191, 185 then
					Result := True
			else
			end
		end

	is_lower (code: NATURAL): BOOLEAN
		do
			inspect code 
				when 65..90, 192..214, 216..222, 161, 166, 170..172, 175, 169 then
					Result := True

				-- Characters which are only available in a single case
				when 181, 223 then
					Result := True

			else
			end
		end

feature {NONE} -- Implementation

	create_unicode_table: SPECIAL [CHARACTER_32]
			-- Unicode value indexed by ISO_8859_3 character values
		do
			Result := single_byte_unicode_chars
			Result [0xA0] := ' ' -- NO-BREAK SPACE
			Result [0xA1] := 'Ħ' -- LATIN CAPITAL LETTER H WITH STROKE
			Result [0xA2] := '˘' -- BREVE
			Result [0xA3] := '£' -- POUND SIGN
			Result [0xA4] := '¤' -- CURRENCY SIGN
			Result [0xA6] := 'Ĥ' -- LATIN CAPITAL LETTER H WITH CIRCUMFLEX
			Result [0xA7] := '§' -- SECTION SIGN
			Result [0xA8] := '¨' -- DIAERESIS
			Result [0xA9] := 'İ' -- LATIN CAPITAL LETTER I WITH DOT ABOVE
			Result [0xAA] := 'Ş' -- LATIN CAPITAL LETTER S WITH CEDILLA
			Result [0xAB] := 'Ğ' -- LATIN CAPITAL LETTER G WITH BREVE
			Result [0xAC] := 'Ĵ' -- LATIN CAPITAL LETTER J WITH CIRCUMFLEX
			Result [0xAD] := '­' -- SOFT HYPHEN
			Result [0xAF] := 'Ż' -- LATIN CAPITAL LETTER Z WITH DOT ABOVE
			Result [0xB0] := '°' -- DEGREE SIGN
			Result [0xB1] := 'ħ' -- LATIN SMALL LETTER H WITH STROKE
			Result [0xB2] := '²' -- SUPERSCRIPT TWO
			Result [0xB3] := '³' -- SUPERSCRIPT THREE
			Result [0xB4] := '´' -- ACUTE ACCENT
			Result [0xB5] := 'µ' -- MICRO SIGN
			Result [0xB6] := 'ĥ' -- LATIN SMALL LETTER H WITH CIRCUMFLEX
			Result [0xB7] := '·' -- MIDDLE DOT
			Result [0xB8] := '¸' -- CEDILLA
			Result [0xB9] := 'ı' -- LATIN SMALL LETTER DOTLESS I
			Result [0xBA] := 'ş' -- LATIN SMALL LETTER S WITH CEDILLA
			Result [0xBB] := 'ğ' -- LATIN SMALL LETTER G WITH BREVE
			Result [0xBC] := 'ĵ' -- LATIN SMALL LETTER J WITH CIRCUMFLEX
			Result [0xBD] := '½' -- VULGAR FRACTION ONE HALF
			Result [0xBF] := 'ż' -- LATIN SMALL LETTER Z WITH DOT ABOVE
			Result [0xC0] := 'À' -- LATIN CAPITAL LETTER A WITH GRAVE
			Result [0xC1] := 'Á' -- LATIN CAPITAL LETTER A WITH ACUTE
			Result [0xC2] := 'Â' -- LATIN CAPITAL LETTER A WITH CIRCUMFLEX
			Result [0xC4] := 'Ä' -- LATIN CAPITAL LETTER A WITH DIAERESIS
			Result [0xC5] := 'Ċ' -- LATIN CAPITAL LETTER C WITH DOT ABOVE
			Result [0xC6] := 'Ĉ' -- LATIN CAPITAL LETTER C WITH CIRCUMFLEX
			Result [0xC7] := 'Ç' -- LATIN CAPITAL LETTER C WITH CEDILLA
			Result [0xC8] := 'È' -- LATIN CAPITAL LETTER E WITH GRAVE
			Result [0xC9] := 'É' -- LATIN CAPITAL LETTER E WITH ACUTE
			Result [0xCA] := 'Ê' -- LATIN CAPITAL LETTER E WITH CIRCUMFLEX
			Result [0xCB] := 'Ë' -- LATIN CAPITAL LETTER E WITH DIAERESIS
			Result [0xCC] := 'Ì' -- LATIN CAPITAL LETTER I WITH GRAVE
			Result [0xCD] := 'Í' -- LATIN CAPITAL LETTER I WITH ACUTE
			Result [0xCE] := 'Î' -- LATIN CAPITAL LETTER I WITH CIRCUMFLEX
			Result [0xCF] := 'Ï' -- LATIN CAPITAL LETTER I WITH DIAERESIS
			Result [0xD1] := 'Ñ' -- LATIN CAPITAL LETTER N WITH TILDE
			Result [0xD2] := 'Ò' -- LATIN CAPITAL LETTER O WITH GRAVE
			Result [0xD3] := 'Ó' -- LATIN CAPITAL LETTER O WITH ACUTE
			Result [0xD4] := 'Ô' -- LATIN CAPITAL LETTER O WITH CIRCUMFLEX
			Result [0xD5] := 'Ġ' -- LATIN CAPITAL LETTER G WITH DOT ABOVE
			Result [0xD6] := 'Ö' -- LATIN CAPITAL LETTER O WITH DIAERESIS
			Result [0xD7] := '×' -- MULTIPLICATION SIGN
			Result [0xD8] := 'Ĝ' -- LATIN CAPITAL LETTER G WITH CIRCUMFLEX
			Result [0xD9] := 'Ù' -- LATIN CAPITAL LETTER U WITH GRAVE
			Result [0xDA] := 'Ú' -- LATIN CAPITAL LETTER U WITH ACUTE
			Result [0xDB] := 'Û' -- LATIN CAPITAL LETTER U WITH CIRCUMFLEX
			Result [0xDC] := 'Ü' -- LATIN CAPITAL LETTER U WITH DIAERESIS
			Result [0xDD] := 'Ŭ' -- LATIN CAPITAL LETTER U WITH BREVE
			Result [0xDE] := 'Ŝ' -- LATIN CAPITAL LETTER S WITH CIRCUMFLEX
			Result [0xDF] := 'ß' -- LATIN SMALL LETTER SHARP S
			Result [0xE0] := 'à' -- LATIN SMALL LETTER A WITH GRAVE
			Result [0xE1] := 'á' -- LATIN SMALL LETTER A WITH ACUTE
			Result [0xE2] := 'â' -- LATIN SMALL LETTER A WITH CIRCUMFLEX
			Result [0xE4] := 'ä' -- LATIN SMALL LETTER A WITH DIAERESIS
			Result [0xE5] := 'ċ' -- LATIN SMALL LETTER C WITH DOT ABOVE
			Result [0xE6] := 'ĉ' -- LATIN SMALL LETTER C WITH CIRCUMFLEX
			Result [0xE7] := 'ç' -- LATIN SMALL LETTER C WITH CEDILLA
			Result [0xE8] := 'è' -- LATIN SMALL LETTER E WITH GRAVE
			Result [0xE9] := 'é' -- LATIN SMALL LETTER E WITH ACUTE
			Result [0xEA] := 'ê' -- LATIN SMALL LETTER E WITH CIRCUMFLEX
			Result [0xEB] := 'ë' -- LATIN SMALL LETTER E WITH DIAERESIS
			Result [0xEC] := 'ì' -- LATIN SMALL LETTER I WITH GRAVE
			Result [0xED] := 'í' -- LATIN SMALL LETTER I WITH ACUTE
			Result [0xEE] := 'î' -- LATIN SMALL LETTER I WITH CIRCUMFLEX
			Result [0xEF] := 'ï' -- LATIN SMALL LETTER I WITH DIAERESIS
			Result [0xF1] := 'ñ' -- LATIN SMALL LETTER N WITH TILDE
			Result [0xF2] := 'ò' -- LATIN SMALL LETTER O WITH GRAVE
			Result [0xF3] := 'ó' -- LATIN SMALL LETTER O WITH ACUTE
			Result [0xF4] := 'ô' -- LATIN SMALL LETTER O WITH CIRCUMFLEX
			Result [0xF5] := 'ġ' -- LATIN SMALL LETTER G WITH DOT ABOVE
			Result [0xF6] := 'ö' -- LATIN SMALL LETTER O WITH DIAERESIS
			Result [0xF7] := '÷' -- DIVISION SIGN
			Result [0xF8] := 'ĝ' -- LATIN SMALL LETTER G WITH CIRCUMFLEX
			Result [0xF9] := 'ù' -- LATIN SMALL LETTER U WITH GRAVE
			Result [0xFA] := 'ú' -- LATIN SMALL LETTER U WITH ACUTE
			Result [0xFB] := 'û' -- LATIN SMALL LETTER U WITH CIRCUMFLEX
			Result [0xFC] := 'ü' -- LATIN SMALL LETTER U WITH DIAERESIS
			Result [0xFD] := 'ŭ' -- LATIN SMALL LETTER U WITH BREVE
			Result [0xFE] := 'ŝ' -- LATIN SMALL LETTER S WITH CIRCUMFLEX
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

end
