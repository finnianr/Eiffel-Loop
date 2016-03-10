note
	description: "Codec for ISO_8859_5 automatically generated from decoder.c in VTD-XML source"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "4"

class
	EL_ISO_8859_5_CODEC

inherit
	EL_ISO_8859_CODEC

create
	make

feature {NONE} -- Initialization

	initialize_latin_sets
		do
			latin_set_1 := latin_set_from_array (<<
				174, -- 'Ў'
				175, -- 'Џ'
				176, -- 'А'
				177, -- 'Б'
				178, -- 'В'
				179, -- 'Г'
				180, -- 'Д'
				181, -- 'Е'
				182, -- 'Ж'
				183, -- 'З'
				184, -- 'И'
				185, -- 'Й'
				186, -- 'К'
				187, -- 'Л'
				188, -- 'М'
				189, -- 'Н'
				190, -- 'О'
				191, -- 'П'
				192, -- 'Р'
				193, -- 'С'
				194, -- 'Т'
				195, -- 'У'
				196, -- 'Ф'
				197, -- 'Х'
				198, -- 'Ц'
				199, -- 'Ч'
				200, -- 'Ш'
				201, -- 'Щ'
				202, -- 'Ъ'
				203, -- 'Ы'
				204, -- 'Ь'
				205, -- 'Э'
				206, -- 'Ю'
				207, -- 'Я'
				208, -- 'а'
				209, -- 'б'
				210, -- 'в'
				211, -- 'г'
				212, -- 'д'
				213, -- 'е'
				214, -- 'ж'
				215, -- 'з'
				216, -- 'и'
				217, -- 'й'
				218, -- 'к'
				219, -- 'л'
				220, -- 'м'
				221, -- 'н'
				222, -- 'о'
				223, -- 'п'
				224, -- 'р'
				225, -- 'с'
				226, -- 'т'
				227, -- 'у'
				228, -- 'ф'
				229, -- 'х'
				230, -- 'ц'
				231, -- 'ч'
				232, -- 'ш'
				233, -- 'щ'
				234, -- 'ъ'
				235, -- 'ы'
				236, -- 'ь'
				237, -- 'э'
				238, -- 'ю'
				239  -- 'я'
			>>)
			latin_set_2 := latin_set_from_array (<<
				241, -- 'ё'
				242, -- 'ђ'
				243, -- 'ѓ'
				244, -- 'є'
				245, -- 'ѕ'
				246, -- 'і'
				247, -- 'ї'
				248, -- 'ј'
				249, -- 'љ'
				250, -- 'њ'
				251, -- 'ћ'
				252  -- 'ќ'
			>>)
			latin_set_3 := latin_set_from_array (<<
				161, -- 'Ё'
				162, -- 'Ђ'
				163, -- 'Ѓ'
				164, -- 'Є'
				165, -- 'Ѕ'
				166, -- 'І'
				167, -- 'Ї'
				168, -- 'Ј'
				169, -- 'Љ'
				170, -- 'Њ'
				171, -- 'Ћ'
				172  -- 'Ќ'
			>>)
			latin_set_4 := latin_set_from_array (<<
				254, -- 'ў'
				255  -- 'џ'
			>>)
		end

feature -- Access

	id: INTEGER = 5

feature -- Conversion

	as_upper (code: NATURAL): NATURAL
		local
			offset: NATURAL
		do
			inspect code
				when 97..122, 208..239 then
					offset := 32
				when 241..252, 254..255 then
					offset := 80

			else end
			Result := code - offset
		end

	as_lower (code: NATURAL): NATURAL
		local
			offset: NATURAL
		do
			inspect code
				when 65..90, 176..207 then
					offset := 32
				when 161..172, 174..175 then
					offset := 80

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
			-- Returns '%U' if translation is the same as ISO-8859-1 or else not in ISO_8859_5
		do
			inspect uc
				when 'Ў'..'я' then
					Result := latin_set_1 [unicode - 1038]
				when 'ё'..'ќ' then
					Result := latin_set_2 [unicode - 1105]
				when 'Ё'..'Ќ' then
					Result := latin_set_3 [unicode - 1025]
				when 'ў'..'џ' then
					Result := latin_set_4 [unicode - 1118]
				when '§' then
					Result := '%/253/'
				when '№' then
					Result := '%/240/'
			else end
		end

feature -- Character query

	is_alpha (code: NATURAL): BOOLEAN
		do
			inspect code 
				when 65..90, 97..122, 161..172, 174..239, 241..252, 254..255 then
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
				when 97..122, 208..239, 241..252, 254..255 then
					Result := True
			else
			end
		end

	is_lower (code: NATURAL): BOOLEAN
		do
			inspect code 
				when 65..90, 176..207, 161..172, 174..175 then
					Result := True

			else
			end
		end

feature {NONE} -- Implementation

	create_unicode_table: SPECIAL [CHARACTER_32]
			-- Unicode value indexed by ISO_8859_5 character values
		do
			Result := single_byte_unicode_chars
			Result [0xA0] := ' ' -- 
			Result [0xA1] := 'Ё' -- 
			Result [0xA2] := 'Ђ' -- 
			Result [0xA3] := 'Ѓ' -- 
			Result [0xA4] := 'Є' -- 
			Result [0xA5] := 'Ѕ' -- 
			Result [0xA6] := 'І' -- 
			Result [0xA7] := 'Ї' -- 
			Result [0xA8] := 'Ј' -- 
			Result [0xA9] := 'Љ' -- 
			Result [0xAA] := 'Њ' -- 
			Result [0xAB] := 'Ћ' -- 
			Result [0xAC] := 'Ќ' -- 
			Result [0xAD] := '­' -- 
			Result [0xAE] := 'Ў' -- 
			Result [0xAF] := 'Џ' -- 
			Result [0xB0] := 'А' -- 
			Result [0xB1] := 'Б' -- 
			Result [0xB2] := 'В' -- 
			Result [0xB3] := 'Г' -- 
			Result [0xB4] := 'Д' -- 
			Result [0xB5] := 'Е' -- 
			Result [0xB6] := 'Ж' -- 
			Result [0xB7] := 'З' -- 
			Result [0xB8] := 'И' -- 
			Result [0xB9] := 'Й' -- 
			Result [0xBA] := 'К' -- 
			Result [0xBB] := 'Л' -- 
			Result [0xBC] := 'М' -- 
			Result [0xBD] := 'Н' -- 
			Result [0xBE] := 'О' -- 
			Result [0xBF] := 'П' -- 
			Result [0xC0] := 'Р' -- 
			Result [0xC1] := 'С' -- 
			Result [0xC2] := 'Т' -- 
			Result [0xC3] := 'У' -- 
			Result [0xC4] := 'Ф' -- 
			Result [0xC5] := 'Х' -- 
			Result [0xC6] := 'Ц' -- 
			Result [0xC7] := 'Ч' -- 
			Result [0xC8] := 'Ш' -- 
			Result [0xC9] := 'Щ' -- 
			Result [0xCA] := 'Ъ' -- 
			Result [0xCB] := 'Ы' -- 
			Result [0xCC] := 'Ь' -- 
			Result [0xCD] := 'Э' -- 
			Result [0xCE] := 'Ю' -- 
			Result [0xCF] := 'Я' -- 
			Result [0xD0] := 'а' -- 
			Result [0xD1] := 'б' -- 
			Result [0xD2] := 'в' -- 
			Result [0xD3] := 'г' -- 
			Result [0xD4] := 'д' -- 
			Result [0xD5] := 'е' -- 
			Result [0xD6] := 'ж' -- 
			Result [0xD7] := 'з' -- 
			Result [0xD8] := 'и' -- 
			Result [0xD9] := 'й' -- 
			Result [0xDA] := 'к' -- 
			Result [0xDB] := 'л' -- 
			Result [0xDC] := 'м' -- 
			Result [0xDD] := 'н' -- 
			Result [0xDE] := 'о' -- 
			Result [0xDF] := 'п' -- 
			Result [0xE0] := 'р' -- 
			Result [0xE1] := 'с' -- 
			Result [0xE2] := 'т' -- 
			Result [0xE3] := 'у' -- 
			Result [0xE4] := 'ф' -- 
			Result [0xE5] := 'х' -- 
			Result [0xE6] := 'ц' -- 
			Result [0xE7] := 'ч' -- 
			Result [0xE8] := 'ш' -- 
			Result [0xE9] := 'щ' -- 
			Result [0xEA] := 'ъ' -- 
			Result [0xEB] := 'ы' -- 
			Result [0xEC] := 'ь' -- 
			Result [0xED] := 'э' -- 
			Result [0xEE] := 'ю' -- 
			Result [0xEF] := 'я' -- 
			Result [0xF0] := '№' -- 
			Result [0xF1] := 'ё' -- 
			Result [0xF2] := 'ђ' -- 
			Result [0xF3] := 'ѓ' -- 
			Result [0xF4] := 'є' -- 
			Result [0xF5] := 'ѕ' -- 
			Result [0xF6] := 'і' -- 
			Result [0xF7] := 'ї' -- 
			Result [0xF8] := 'ј' -- 
			Result [0xF9] := 'љ' -- 
			Result [0xFA] := 'њ' -- 
			Result [0xFB] := 'ћ' -- 
			Result [0xFC] := 'ќ' -- 
			Result [0xFD] := '§' -- 
			Result [0xFE] := 'ў' -- 
			Result [0xFF] := 'џ' -- 
		end

	latin_set_1: SPECIAL [CHARACTER]

	latin_set_2: SPECIAL [CHARACTER]

	latin_set_3: SPECIAL [CHARACTER]

	latin_set_4: SPECIAL [CHARACTER]

end
