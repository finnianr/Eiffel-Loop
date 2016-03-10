note
	description: "Codec for ISO_8859_14 automatically generated from decoder.c in VTD-XML source"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "4"

class
	EL_ISO_8859_14_CODEC

inherit
	EL_ISO_8859_CODEC

create
	make

feature {NONE} -- Initialization

	initialize_latin_sets
		do
			latin_set_1 := latin_set_from_array (<<
				168, -- 'Ẁ'
				184, -- 'ẁ'
				170, -- 'Ẃ'
				186, -- 'ẃ'
				189, -- 'Ẅ'
				190  -- 'ẅ'
			>>)
			latin_set_2 := latin_set_from_array (<<
				208, -- 'Ŵ'
				240, -- 'ŵ'
				222, -- 'Ŷ'
				254, -- 'ŷ'
				175  -- 'Ÿ'
			>>)
			latin_set_3 := latin_set_from_array (<<
				187, -- 'Ṡ'
				191  -- 'ṡ'
			>>)
			latin_set_4 := latin_set_from_array (<<
				215, -- 'Ṫ'
				247  -- 'ṫ'
			>>)
			latin_set_5 := latin_set_from_array (<<
				183, -- 'Ṗ'
				185  -- 'ṗ'
			>>)
			latin_set_6 := latin_set_from_array (<<
				172, -- 'Ỳ'
				188  -- 'ỳ'
			>>)
			latin_set_7 := latin_set_from_array (<<
				161, -- 'Ḃ'
				162  -- 'ḃ'
			>>)
			latin_set_8 := latin_set_from_array (<<
				180, -- 'Ṁ'
				181  -- 'ṁ'
			>>)
			latin_set_9 := latin_set_from_array (<<
				178, -- 'Ġ'
				179  -- 'ġ'
			>>)
			latin_set_10 := latin_set_from_array (<<
				164, -- 'Ċ'
				165  -- 'ċ'
			>>)
			latin_set_11 := latin_set_from_array (<<
				166, -- 'Ḋ'
				171  -- 'ḋ'
			>>)
			latin_set_12 := latin_set_from_array (<<
				176, -- 'Ḟ'
				177  -- 'ḟ'
			>>)
		end

feature -- Access

	id: INTEGER = 14

feature -- Conversion

	as_upper (code: NATURAL): NATURAL
		local
			offset: NATURAL
		do
			inspect code
				when 97..122, 224..254 then
					offset := 32
				when 162, 165, 177, 179, 181, 190 then
					offset := 1
				when 171 then
					offset := 5
				when 184, 186, 188 then
					offset := 16
				when 185 then
					offset := 2
				when 191 then
					offset := 4
				when 255 then
					offset := 80

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
				when 161, 164, 176, 178, 180, 189 then
					offset := 1
				when 166 then
					offset := 5
				when 168, 170, 172 then
					offset := 16
				when 175 then
					offset := 80
				when 183 then
					offset := 2
				when 187 then
					offset := 4

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
			-- Returns '%U' if translation is the same as ISO-8859-1 or else not in ISO_8859_14
		do
			inspect uc
				when 'Ẁ'..'ẅ' then
					Result := latin_set_1 [unicode - 7808]
				when 'Ŵ'..'Ÿ' then
					Result := latin_set_2 [unicode - 372]
				when 'Ṡ'..'ṡ' then
					Result := latin_set_3 [unicode - 7776]
				when 'Ṫ'..'ṫ' then
					Result := latin_set_4 [unicode - 7786]
				when 'Ṗ'..'ṗ' then
					Result := latin_set_5 [unicode - 7766]
				when 'Ỳ'..'ỳ' then
					Result := latin_set_6 [unicode - 7922]
				when 'Ḃ'..'ḃ' then
					Result := latin_set_7 [unicode - 7682]
				when 'Ṁ'..'ṁ' then
					Result := latin_set_8 [unicode - 7744]
				when 'Ġ'..'ġ' then
					Result := latin_set_9 [unicode - 288]
				when 'Ċ'..'ċ' then
					Result := latin_set_10 [unicode - 266]
				when 'Ḋ'..'ḋ' then
					Result := latin_set_11 [unicode - 7690]
				when 'Ḟ'..'ḟ' then
					Result := latin_set_12 [unicode - 7710]
			else end
		end

feature -- Character query

	is_alpha (code: NATURAL): BOOLEAN
		do
			inspect code 
				when 65..90, 97..122, 161..162, 164..166, 168, 170..172, 175..181, 183..255 then
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
				when 97..122, 224..254, 162, 165, 177, 179, 181, 190, 171, 184, 186, 188, 185, 191, 255 then
					Result := True
			else
			end
		end

	is_lower (code: NATURAL): BOOLEAN
		do
			inspect code 
				when 65..90, 192..222, 161, 164, 176, 178, 180, 189, 166, 168, 170, 172, 175, 183, 187 then
					Result := True

				-- Characters which are only available in a single case
				when 223 then
					Result := True

			else
			end
		end

feature {NONE} -- Implementation

	create_unicode_table: SPECIAL [CHARACTER_32]
			-- Unicode value indexed by ISO_8859_14 character values
		do
			Result := single_byte_unicode_chars
			Result [0xA0] := ' ' -- NO-BREAK SPACE
			Result [0xA1] := 'Ḃ' -- LATIN CAPITAL LETTER B WITH DOT ABOVE
			Result [0xA2] := 'ḃ' -- LATIN SMALL LETTER B WITH DOT ABOVE
			Result [0xA3] := '£' -- POUND SIGN
			Result [0xA4] := 'Ċ' -- LATIN CAPITAL LETTER C WITH DOT ABOVE
			Result [0xA5] := 'ċ' -- LATIN SMALL LETTER C WITH DOT ABOVE
			Result [0xA6] := 'Ḋ' -- LATIN CAPITAL LETTER D WITH DOT ABOVE
			Result [0xA7] := '§' -- SECTION SIGN
			Result [0xA8] := 'Ẁ' -- LATIN CAPITAL LETTER W WITH GRAVE
			Result [0xA9] := '©' -- COPYRIGHT SIGN
			Result [0xAA] := 'Ẃ' -- LATIN CAPITAL LETTER W WITH ACUTE
			Result [0xAB] := 'ḋ' -- LATIN SMALL LETTER D WITH DOT ABOVE
			Result [0xAC] := 'Ỳ' -- LATIN CAPITAL LETTER Y WITH GRAVE
			Result [0xAD] := '­' -- SOFT HYPHEN
			Result [0xAE] := '®' -- REGISTERED SIGN
			Result [0xAF] := 'Ÿ' -- LATIN CAPITAL LETTER Y WITH DIAERESIS
			Result [0xB0] := 'Ḟ' -- LATIN CAPITAL LETTER F WITH DOT ABOVE
			Result [0xB1] := 'ḟ' -- LATIN SMALL LETTER F WITH DOT ABOVE
			Result [0xB2] := 'Ġ' -- LATIN CAPITAL LETTER G WITH DOT ABOVE
			Result [0xB3] := 'ġ' -- LATIN SMALL LETTER G WITH DOT ABOVE
			Result [0xB4] := 'Ṁ' -- LATIN CAPITAL LETTER M WITH DOT ABOVE
			Result [0xB5] := 'ṁ' -- LATIN SMALL LETTER M WITH DOT ABOVE
			Result [0xB6] := '¶' -- PILCROW SIGN
			Result [0xB7] := 'Ṗ' -- LATIN CAPITAL LETTER P WITH DOT ABOVE
			Result [0xB8] := 'ẁ' -- LATIN SMALL LETTER W WITH GRAVE
			Result [0xB9] := 'ṗ' -- LATIN SMALL LETTER P WITH DOT ABOVE
			Result [0xBA] := 'ẃ' -- LATIN SMALL LETTER W WITH ACUTE
			Result [0xBB] := 'Ṡ' -- LATIN CAPITAL LETTER S WITH DOT ABOVE
			Result [0xBC] := 'ỳ' -- LATIN SMALL LETTER Y WITH GRAVE
			Result [0xBD] := 'Ẅ' -- LATIN CAPITAL LETTER W WITH DIAERESIS
			Result [0xBE] := 'ẅ' -- LATIN SMALL LETTER W WITH DIAERESIS
			Result [0xBF] := 'ṡ' -- LATIN SMALL LETTER S WITH DOT ABOVE
			Result [0xC0] := 'À' -- LATIN CAPITAL LETTER A WITH GRAVE
			Result [0xC1] := 'Á' -- LATIN CAPITAL LETTER A WITH ACUTE
			Result [0xC2] := 'Â' -- LATIN CAPITAL LETTER A WITH CIRCUMFLEX
			Result [0xC3] := 'Ã' -- LATIN CAPITAL LETTER A WITH TILDE
			Result [0xC4] := 'Ä' -- LATIN CAPITAL LETTER A WITH DIAERESIS
			Result [0xC5] := 'Å' -- LATIN CAPITAL LETTER A WITH RING ABOVE
			Result [0xC6] := 'Æ' -- LATIN CAPITAL LETTER AE
			Result [0xC7] := 'Ç' -- LATIN CAPITAL LETTER C WITH CEDILLA
			Result [0xC8] := 'È' -- LATIN CAPITAL LETTER E WITH GRAVE
			Result [0xC9] := 'É' -- LATIN CAPITAL LETTER E WITH ACUTE
			Result [0xCA] := 'Ê' -- LATIN CAPITAL LETTER E WITH CIRCUMFLEX
			Result [0xCB] := 'Ë' -- LATIN CAPITAL LETTER E WITH DIAERESIS
			Result [0xCC] := 'Ì' -- LATIN CAPITAL LETTER I WITH GRAVE
			Result [0xCD] := 'Í' -- LATIN CAPITAL LETTER I WITH ACUTE
			Result [0xCE] := 'Î' -- LATIN CAPITAL LETTER I WITH CIRCUMFLEX
			Result [0xCF] := 'Ï' -- LATIN CAPITAL LETTER I WITH DIAERESIS
			Result [0xD0] := 'Ŵ' -- LATIN CAPITAL LETTER W WITH CIRCUMFLEX
			Result [0xD1] := 'Ñ' -- LATIN CAPITAL LETTER N WITH TILDE
			Result [0xD2] := 'Ò' -- LATIN CAPITAL LETTER O WITH GRAVE
			Result [0xD3] := 'Ó' -- LATIN CAPITAL LETTER O WITH ACUTE
			Result [0xD4] := 'Ô' -- LATIN CAPITAL LETTER O WITH CIRCUMFLEX
			Result [0xD5] := 'Õ' -- LATIN CAPITAL LETTER O WITH TILDE
			Result [0xD6] := 'Ö' -- LATIN CAPITAL LETTER O WITH DIAERESIS
			Result [0xD7] := 'Ṫ' -- LATIN CAPITAL LETTER T WITH DOT ABOVE
			Result [0xD8] := 'Ø' -- LATIN CAPITAL LETTER O WITH STROKE
			Result [0xD9] := 'Ù' -- LATIN CAPITAL LETTER U WITH GRAVE
			Result [0xDA] := 'Ú' -- LATIN CAPITAL LETTER U WITH ACUTE
			Result [0xDB] := 'Û' -- LATIN CAPITAL LETTER U WITH CIRCUMFLEX
			Result [0xDC] := 'Ü' -- LATIN CAPITAL LETTER U WITH DIAERESIS
			Result [0xDD] := 'Ý' -- LATIN CAPITAL LETTER Y WITH ACUTE
			Result [0xDE] := 'Ŷ' -- LATIN CAPITAL LETTER Y WITH CIRCUMFLEX
			Result [0xDF] := 'ß' -- LATIN SMALL LETTER SHARP S
			Result [0xE0] := 'à' -- LATIN SMALL LETTER A WITH GRAVE
			Result [0xE1] := 'á' -- LATIN SMALL LETTER A WITH ACUTE
			Result [0xE2] := 'â' -- LATIN SMALL LETTER A WITH CIRCUMFLEX
			Result [0xE3] := 'ã' -- LATIN SMALL LETTER A WITH TILDE
			Result [0xE4] := 'ä' -- LATIN SMALL LETTER A WITH DIAERESIS
			Result [0xE5] := 'å' -- LATIN SMALL LETTER A WITH RING ABOVE
			Result [0xE6] := 'æ' -- LATIN SMALL LETTER AE
			Result [0xE7] := 'ç' -- LATIN SMALL LETTER C WITH CEDILLA
			Result [0xE8] := 'è' -- LATIN SMALL LETTER E WITH GRAVE
			Result [0xE9] := 'é' -- LATIN SMALL LETTER E WITH ACUTE
			Result [0xEA] := 'ê' -- LATIN SMALL LETTER E WITH CIRCUMFLEX
			Result [0xEB] := 'ë' -- LATIN SMALL LETTER E WITH DIAERESIS
			Result [0xEC] := 'ì' -- LATIN SMALL LETTER I WITH GRAVE
			Result [0xED] := 'í' -- LATIN SMALL LETTER I WITH ACUTE
			Result [0xEE] := 'î' -- LATIN SMALL LETTER I WITH CIRCUMFLEX
			Result [0xEF] := 'ï' -- LATIN SMALL LETTER I WITH DIAERESIS
			Result [0xF0] := 'ŵ' -- LATIN SMALL LETTER W WITH CIRCUMFLEX
			Result [0xF1] := 'ñ' -- LATIN SMALL LETTER N WITH TILDE
			Result [0xF2] := 'ò' -- LATIN SMALL LETTER O WITH GRAVE
			Result [0xF3] := 'ó' -- LATIN SMALL LETTER O WITH ACUTE
			Result [0xF4] := 'ô' -- LATIN SMALL LETTER O WITH CIRCUMFLEX
			Result [0xF5] := 'õ' -- LATIN SMALL LETTER O WITH TILDE
			Result [0xF6] := 'ö' -- LATIN SMALL LETTER O WITH DIAERESIS
			Result [0xF7] := 'ṫ' -- LATIN SMALL LETTER T WITH DOT ABOVE
			Result [0xF8] := 'ø' -- LATIN SMALL LETTER O WITH STROKE
			Result [0xF9] := 'ù' -- LATIN SMALL LETTER U WITH GRAVE
			Result [0xFA] := 'ú' -- LATIN SMALL LETTER U WITH ACUTE
			Result [0xFB] := 'û' -- LATIN SMALL LETTER U WITH CIRCUMFLEX
			Result [0xFC] := 'ü' -- LATIN SMALL LETTER U WITH DIAERESIS
			Result [0xFD] := 'ý' -- LATIN SMALL LETTER Y WITH ACUTE
			Result [0xFE] := 'ŷ' -- LATIN SMALL LETTER Y WITH CIRCUMFLEX
			Result [0xFF] := 'ÿ' -- LATIN SMALL LETTER Y WITH DIAERESIS
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

end
