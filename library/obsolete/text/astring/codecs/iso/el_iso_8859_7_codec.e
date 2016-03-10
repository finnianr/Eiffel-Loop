note
	description: "Codec for ISO_8859_7 automatically generated from decoder.c in VTD-XML source"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "4"

class
	EL_ISO_8859_7_CODEC

inherit
	EL_ISO_8859_CODEC

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
				184, -- 'Έ'
				185, -- 'Ή'
				186  -- 'Ί'
			>>)
			latin_set_4 := latin_set_from_array (<<
				180, -- '΄'
				181, -- '΅'
				182  -- 'Ά'
			>>)
			latin_set_5 := latin_set_from_array (<<
				162, -- 'ʼ'
				161  -- 'ʽ'
			>>)
		end

feature -- Access

	id: INTEGER = 7

feature -- Conversion

	as_upper (code: NATURAL): NATURAL
		local
			offset: NATURAL
		do
			inspect code
				when 97..122, 225..241, 243..251 then
					offset := 32
				when 192 then
					offset := 26
				when 220 then
					offset := 38
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
				when 182 then
					offset := 38
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
			-- Returns '%U' if translation is the same as ISO-8859-1 or else not in ISO_8859_7
		do
			inspect uc
				when 'Σ'..'ώ' then
					Result := latin_set_1 [unicode - 931]
				when 'Ύ'..'Ρ' then
					Result := latin_set_2 [unicode - 910]
				when 'Έ'..'Ί' then
					Result := latin_set_3 [unicode - 904]
				when '΄'..'Ά' then
					Result := latin_set_4 [unicode - 900]
				when 'ʼ'..'ʽ' then
					Result := latin_set_5 [unicode - 700]
				when '―' then
					Result := '%/175/'
				when 'Ό' then
					Result := '%/188/'
			else end
		end

feature -- Character query

	is_alpha (code: NATURAL): BOOLEAN
		do
			inspect code 
				when 65..90, 97..122, 182, 184..186, 188, 190..255 then
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
				when 97..122, 225..241, 243..251, 192, 220, 221..223, 224, 242, 252, 253..254 then
					Result := True
			else
			end
		end

	is_lower (code: NATURAL): BOOLEAN
		do
			inspect code 
				when 65..90, 193..209, 211..219, 182, 184..186, 188, 190..191 then
					Result := True

				-- Characters which are only available in a single case
				when 210, 255 then
					Result := True

			else
			end
		end

feature {NONE} -- Implementation

	create_unicode_table: SPECIAL [CHARACTER_32]
			-- Unicode value indexed by ISO_8859_7 character values
		do
			Result := single_byte_unicode_chars
			Result [0xA0] := ' ' -- 
			Result [0xA1] := 'ʽ' -- 
			Result [0xA2] := 'ʼ' -- 
			Result [0xA3] := '£' -- 
			Result [0xA6] := '¦' -- 
			Result [0xA7] := '§' -- 
			Result [0xA8] := '¨' -- 
			Result [0xA9] := '©' -- 
			Result [0xAB] := '«' -- 
			Result [0xAC] := '¬' -- 
			Result [0xAD] := '­' -- 
			Result [0xAF] := '―' -- 
			Result [0xB0] := '°' -- 
			Result [0xB1] := '±' -- 
			Result [0xB2] := '²' -- 
			Result [0xB3] := '³' -- 
			Result [0xB4] := '΄' -- 
			Result [0xB5] := '΅' -- 
			Result [0xB6] := 'Ά' -- 
			Result [0xB7] := '·' -- 
			Result [0xB8] := 'Έ' -- 
			Result [0xB9] := 'Ή' -- 
			Result [0xBA] := 'Ί' -- 
			Result [0xBB] := '»' -- 
			Result [0xBC] := 'Ό' -- 
			Result [0xBD] := '½' -- 
			Result [0xBE] := 'Ύ' -- 
			Result [0xBF] := 'Ώ' -- 
			Result [0xC0] := 'ΐ' -- 
			Result [0xC1] := 'Α' -- 
			Result [0xC2] := 'Β' -- 
			Result [0xC3] := 'Γ' -- 
			Result [0xC4] := 'Δ' -- 
			Result [0xC5] := 'Ε' -- 
			Result [0xC6] := 'Ζ' -- 
			Result [0xC7] := 'Η' -- 
			Result [0xC8] := 'Θ' -- 
			Result [0xC9] := 'Ι' -- 
			Result [0xCA] := 'Κ' -- 
			Result [0xCB] := 'Λ' -- 
			Result [0xCC] := 'Μ' -- 
			Result [0xCD] := 'Ν' -- 
			Result [0xCE] := 'Ξ' -- 
			Result [0xCF] := 'Ο' -- 
			Result [0xD0] := 'Π' -- 
			Result [0xD1] := 'Ρ' -- 
			Result [0xD3] := 'Σ' -- 
			Result [0xD4] := 'Τ' -- 
			Result [0xD5] := 'Υ' -- 
			Result [0xD6] := 'Φ' -- 
			Result [0xD7] := 'Χ' -- 
			Result [0xD8] := 'Ψ' -- 
			Result [0xD9] := 'Ω' -- 
			Result [0xDA] := 'Ϊ' -- 
			Result [0xDB] := 'Ϋ' -- 
			Result [0xDC] := 'ά' -- 
			Result [0xDD] := 'έ' -- 
			Result [0xDE] := 'ή' -- 
			Result [0xDF] := 'ί' -- 
			Result [0xE0] := 'ΰ' -- 
			Result [0xE1] := 'α' -- 
			Result [0xE2] := 'β' -- 
			Result [0xE3] := 'γ' -- 
			Result [0xE4] := 'δ' -- 
			Result [0xE5] := 'ε' -- 
			Result [0xE6] := 'ζ' -- 
			Result [0xE7] := 'η' -- 
			Result [0xE8] := 'θ' -- 
			Result [0xE9] := 'ι' -- 
			Result [0xEA] := 'κ' -- 
			Result [0xEB] := 'λ' -- 
			Result [0xEC] := 'μ' -- 
			Result [0xED] := 'ν' -- 
			Result [0xEE] := 'ξ' -- 
			Result [0xEF] := 'ο' -- 
			Result [0xF0] := 'π' -- 
			Result [0xF1] := 'ρ' -- 
			Result [0xF2] := 'ς' -- 
			Result [0xF3] := 'σ' -- 
			Result [0xF4] := 'τ' -- 
			Result [0xF5] := 'υ' -- 
			Result [0xF6] := 'φ' -- 
			Result [0xF7] := 'χ' -- 
			Result [0xF8] := 'ψ' -- 
			Result [0xF9] := 'ω' -- 
			Result [0xFA] := 'ϊ' -- 
			Result [0xFB] := 'ϋ' -- 
			Result [0xFC] := 'ό' -- 
			Result [0xFD] := 'ύ' -- 
			Result [0xFE] := 'ώ' -- 
		end

	latin_set_1: SPECIAL [CHARACTER]

	latin_set_2: SPECIAL [CHARACTER]

	latin_set_3: SPECIAL [CHARACTER]

	latin_set_4: SPECIAL [CHARACTER]

	latin_set_5: SPECIAL [CHARACTER]

end
