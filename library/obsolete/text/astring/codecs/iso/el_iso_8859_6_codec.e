note
	description: "Codec for ISO_8859_6 automatically generated from decoder.c in VTD-XML source"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "4"

class
	EL_ISO_8859_6_CODEC

inherit
	EL_ISO_8859_CODEC

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
				215, -- 'ط'
				216, -- 'ظ'
				217, -- 'ع'
				218  -- 'غ'
			>>)
			latin_set_2 := latin_set_from_array (<<
				224, -- 'ـ'
				225, -- 'ف'
				226, -- 'ق'
				227, -- 'ك'
				228, -- 'ل'
				229, -- 'م'
				230, -- 'ن'
				231, -- 'ه'
				232, -- 'و'
				233, -- 'ى'
				234, -- 'ي'
				235, -- 'ً'
				236, -- 'ٌ'
				237, -- 'ٍ'
				238, -- 'َ'
				239, -- 'ُ'
				240, -- 'ِ'
				241, -- 'ّ'
				242  -- 'ْ'
			>>)
		end

feature -- Access

	id: INTEGER = 6

feature -- Conversion

	as_upper (code: NATURAL): NATURAL
		local
			offset: NATURAL
		do
			inspect code
				when 97..122, 251..254 then
					offset := 32

			else end
			Result := code - offset
		end

	as_lower (code: NATURAL): NATURAL
		local
			offset: NATURAL
		do
			inspect code
				when 65..90, 219..222 then
					offset := 32

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
				-- À -> à
				when 192 then
					Result := 'à'
				-- ó -> Ó
				when 243 then
					Result := 'Ó'
				-- ô -> Ô
				when 244 then
					Result := 'Ô'
				-- õ -> Õ
				when 245 then
					Result := 'Õ'
				-- ö -> Ö
				when 246 then
					Result := 'Ö'
				-- ø -> Ø
				when 248 then
					Result := 'Ø'
				-- ù -> Ù
				when 249 then
					Result := 'Ù'
				-- ú -> Ú
				when 250 then
					Result := 'Ú'
				-- ÿ -> Ÿ
				when 255 then
					Result := 'Ÿ'
			else end
		end

	latin_character (uc: CHARACTER_32; unicode: INTEGER): CHARACTER
			-- unicode to latin translation
			-- Returns '%U' if translation is the same as ISO-8859-1 or else not in ISO_8859_6
		do
			inspect uc
				when 'ء'..'غ' then
					Result := latin_set_1 [unicode - 1569]
				when 'ـ'..'ْ' then
					Result := latin_set_2 [unicode - 1600]
				when '؛' then
					Result := '%/187/'
				when '؟' then
					Result := '%/191/'
				when '،' then
					Result := '%/172/'
			else end
		end

feature -- Character query

	is_alpha (code: NATURAL): BOOLEAN
		do
			inspect code 
				when 65..90, 97..122, 181, 192, 219..223, 243..246, 248..255 then
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
				when 97..122, 251..254 then
					Result := True
			else
			end
		end

	is_lower (code: NATURAL): BOOLEAN
		do
			inspect code 
				when 65..90, 219..222 then
					Result := True

				-- Characters which are only available in a single case
				when 181, 192, 223, 243, 244, 245, 246, 248, 249, 250, 255 then
					Result := True

			else
			end
		end

feature {NONE} -- Implementation

	create_unicode_table: SPECIAL [CHARACTER_32]
			-- Unicode value indexed by ISO_8859_6 character values
		do
			Result := single_byte_unicode_chars
			Result [0xA0] := ' ' -- 
			Result [0xA4] := '¤' -- 
			Result [0xAC] := '،' -- 
			Result [0xAD] := '­' -- 
			Result [0xBB] := '؛' -- 
			Result [0xBF] := '؟' -- 
			Result [0xC1] := 'ء' -- 
			Result [0xC2] := 'آ' -- 
			Result [0xC3] := 'أ' -- 
			Result [0xC4] := 'ؤ' -- 
			Result [0xC5] := 'إ' -- 
			Result [0xC6] := 'ئ' -- 
			Result [0xC7] := 'ا' -- 
			Result [0xC8] := 'ب' -- 
			Result [0xC9] := 'ة' -- 
			Result [0xCA] := 'ت' -- 
			Result [0xCB] := 'ث' -- 
			Result [0xCC] := 'ج' -- 
			Result [0xCD] := 'ح' -- 
			Result [0xCE] := 'خ' -- 
			Result [0xCF] := 'د' -- 
			Result [0xD0] := 'ذ' -- 
			Result [0xD1] := 'ر' -- 
			Result [0xD2] := 'ز' -- 
			Result [0xD3] := 'س' -- 
			Result [0xD4] := 'ش' -- 
			Result [0xD5] := 'ص' -- 
			Result [0xD6] := 'ض' -- 
			Result [0xD7] := 'ط' -- 
			Result [0xD8] := 'ظ' -- 
			Result [0xD9] := 'ع' -- 
			Result [0xDA] := 'غ' -- 
			Result [0xE0] := 'ـ' -- 
			Result [0xE1] := 'ف' -- 
			Result [0xE2] := 'ق' -- 
			Result [0xE3] := 'ك' -- 
			Result [0xE4] := 'ل' -- 
			Result [0xE5] := 'م' -- 
			Result [0xE6] := 'ن' -- 
			Result [0xE7] := 'ه' -- 
			Result [0xE8] := 'و' -- 
			Result [0xE9] := 'ى' -- 
			Result [0xEA] := 'ي' -- 
			Result [0xEB] := 'ً' -- 
			Result [0xEC] := 'ٌ' -- 
			Result [0xED] := 'ٍ' -- 
			Result [0xEE] := 'َ' -- 
			Result [0xEF] := 'ُ' -- 
			Result [0xF0] := 'ِ' -- 
			Result [0xF1] := 'ّ' -- 
			Result [0xF2] := 'ْ' -- 
		end

	latin_set_1: SPECIAL [CHARACTER]

	latin_set_2: SPECIAL [CHARACTER]

end
