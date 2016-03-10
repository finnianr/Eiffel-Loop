note
	description: "Codec for ISO_8859_11 automatically generated from decoder.c in VTD-XML source"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "4"

class
	EL_ISO_8859_11_CODEC

inherit
	EL_ISO_8859_CODEC

create
	make

feature {NONE} -- Initialization

	initialize_latin_sets
		do
			latin_set_1 := latin_set_from_array (<<
				161, -- 'ก'
				162, -- 'ข'
				163, -- 'ฃ'
				164, -- 'ค'
				165, -- 'ฅ'
				166, -- 'ฆ'
				167, -- 'ง'
				168, -- 'จ'
				169, -- 'ฉ'
				170, -- 'ช'
				171, -- 'ซ'
				172, -- 'ฌ'
				173, -- 'ญ'
				174, -- 'ฎ'
				175, -- 'ฏ'
				176, -- 'ฐ'
				177, -- 'ฑ'
				178, -- 'ฒ'
				179, -- 'ณ'
				180, -- 'ด'
				181, -- 'ต'
				182, -- 'ถ'
				183, -- 'ท'
				184, -- 'ธ'
				185, -- 'น'
				186, -- 'บ'
				187, -- 'ป'
				188, -- 'ผ'
				189, -- 'ฝ'
				190, -- 'พ'
				191, -- 'ฟ'
				192, -- 'ภ'
				193, -- 'ม'
				194, -- 'ย'
				195, -- 'ร'
				196, -- 'ฤ'
				197, -- 'ล'
				198, -- 'ฦ'
				199, -- 'ว'
				200, -- 'ศ'
				201, -- 'ษ'
				202, -- 'ส'
				203, -- 'ห'
				204, -- 'ฬ'
				205, -- 'อ'
				206, -- 'ฮ'
				207, -- 'ฯ'
				208, -- 'ะ'
				209, -- 'ั'
				210, -- 'า'
				211, -- 'ำ'
				212, -- 'ิ'
				213, -- 'ี'
				214, -- 'ึ'
				215, -- 'ื'
				216, -- 'ุ'
				217, -- 'ู'
				218  -- 'ฺ'
			>>)
			latin_set_2 := latin_set_from_array (<<
				223, -- '฿'
				224, -- 'เ'
				225, -- 'แ'
				226, -- 'โ'
				227, -- 'ใ'
				228, -- 'ไ'
				229, -- 'ๅ'
				230, -- 'ๆ'
				231, -- '็'
				232, -- '่'
				233, -- '้'
				234, -- '๊'
				235, -- '๋'
				236, -- '์'
				237, -- 'ํ'
				238, -- '๎'
				239, -- '๏'
				240, -- '๐'
				241, -- '๑'
				242, -- '๒'
				243, -- '๓'
				244, -- '๔'
				245, -- '๕'
				246, -- '๖'
				247, -- '๗'
				248, -- '๘'
				249, -- '๙'
				250, -- '๚'
				251  -- '๛'
			>>)
		end

feature -- Access

	id: INTEGER = 11

feature -- Conversion

	as_upper (code: NATURAL): NATURAL
		local
			offset: NATURAL
		do
			inspect code
				when 97..122, 252..254 then
					offset := 32

			else end
			Result := code - offset
		end

	as_lower (code: NATURAL): NATURAL
		local
			offset: NATURAL
		do
			inspect code
				when 65..90, 220..222 then
					offset := 32

			else end
			Result := code + offset
		end

	unicode_case_change_substitute (code: NATURAL): CHARACTER_32
			-- Returns Unicode case change character if c does not have a latin case change
			-- or else the Null character
		do
			inspect code
				-- Û -> û
				when 219 then
					Result := 'û'
				-- ÿ -> Ÿ
				when 255 then
					Result := 'Ÿ'
			else end
		end

	latin_character (uc: CHARACTER_32; unicode: INTEGER): CHARACTER
			-- unicode to latin translation
			-- Returns '%U' if translation is the same as ISO-8859-1 or else not in ISO_8859_11
		do
			inspect uc
				when 'ก'..'ฺ' then
					Result := latin_set_1 [unicode - 3585]
				when '฿'..'๛' then
					Result := latin_set_2 [unicode - 3647]
			else end
		end

feature -- Character query

	is_alpha (code: NATURAL): BOOLEAN
		do
			inspect code 
				when 65..90, 97..122, 219..222, 252..255 then
					Result := True
			else
			end
		end

	is_numeric (code: NATURAL): BOOLEAN
		do
			inspect code 
				when 48..57, 240..249 then
					Result := True
			else
			end
		end

	is_upper (code: NATURAL): BOOLEAN
		do
			inspect code 
				when 97..122, 252..254 then
					Result := True
			else
			end
		end

	is_lower (code: NATURAL): BOOLEAN
		do
			inspect code 
				when 65..90, 220..222 then
					Result := True

				-- Characters which are only available in a single case
				when 219, 255 then
					Result := True

			else
			end
		end

feature {NONE} -- Implementation

	create_unicode_table: SPECIAL [CHARACTER_32]
			-- Unicode value indexed by ISO_8859_11 character values
		do
			Result := single_byte_unicode_chars
			Result [0xA1] := 'ก' -- THAI CHARACTER KO KAI
			Result [0xA2] := 'ข' -- THAI CHARACTER KHO KHAI
			Result [0xA3] := 'ฃ' -- THAI CHARACTER KHO KHUAT
			Result [0xA4] := 'ค' -- THAI CHARACTER KHO KHWAI
			Result [0xA5] := 'ฅ' -- THAI CHARACTER KHO KHON
			Result [0xA6] := 'ฆ' -- THAI CHARACTER KHO RAKHANG
			Result [0xA7] := 'ง' -- THAI CHARACTER NGO NGU
			Result [0xA8] := 'จ' -- THAI CHARACTER CHO CHAN
			Result [0xA9] := 'ฉ' -- THAI CHARACTER CHO CHING
			Result [0xAA] := 'ช' -- THAI CHARACTER CHO CHANG
			Result [0xAB] := 'ซ' -- THAI CHARACTER SO SO
			Result [0xAC] := 'ฌ' -- THAI CHARACTER CHO CHOE
			Result [0xAD] := 'ญ' -- THAI CHARACTER YO YING
			Result [0xAE] := 'ฎ' -- THAI CHARACTER DO CHADA
			Result [0xAF] := 'ฏ' -- THAI CHARACTER TO PATAK
			Result [0xB0] := 'ฐ' -- THAI CHARACTER THO THAN
			Result [0xB1] := 'ฑ' -- THAI CHARACTER THO NANGMONTHO
			Result [0xB2] := 'ฒ' -- THAI CHARACTER THO PHUTHAO
			Result [0xB3] := 'ณ' -- THAI CHARACTER NO NEN
			Result [0xB4] := 'ด' -- THAI CHARACTER DO DEK
			Result [0xB5] := 'ต' -- THAI CHARACTER TO TAO
			Result [0xB6] := 'ถ' -- THAI CHARACTER THO THUNG
			Result [0xB7] := 'ท' -- THAI CHARACTER THO THAHAN
			Result [0xB8] := 'ธ' -- THAI CHARACTER THO THONG
			Result [0xB9] := 'น' -- THAI CHARACTER NO NU
			Result [0xBA] := 'บ' -- THAI CHARACTER BO BAIMAI
			Result [0xBB] := 'ป' -- THAI CHARACTER PO PLA
			Result [0xBC] := 'ผ' -- THAI CHARACTER PHO PHUNG
			Result [0xBD] := 'ฝ' -- THAI CHARACTER FO FA
			Result [0xBE] := 'พ' -- THAI CHARACTER PHO PHAN
			Result [0xBF] := 'ฟ' -- THAI CHARACTER FO FAN
			Result [0xC0] := 'ภ' -- THAI CHARACTER PHO SAMPHAO
			Result [0xC1] := 'ม' -- THAI CHARACTER MO MA
			Result [0xC2] := 'ย' -- THAI CHARACTER YO YAK
			Result [0xC3] := 'ร' -- THAI CHARACTER RO RUA
			Result [0xC4] := 'ฤ' -- THAI CHARACTER RU
			Result [0xC5] := 'ล' -- THAI CHARACTER LO LING
			Result [0xC6] := 'ฦ' -- THAI CHARACTER LU
			Result [0xC7] := 'ว' -- THAI CHARACTER WO WAEN
			Result [0xC8] := 'ศ' -- THAI CHARACTER SO SALA
			Result [0xC9] := 'ษ' -- THAI CHARACTER SO RUSI
			Result [0xCA] := 'ส' -- THAI CHARACTER SO SUA
			Result [0xCB] := 'ห' -- THAI CHARACTER HO HIP
			Result [0xCC] := 'ฬ' -- THAI CHARACTER LO CHULA
			Result [0xCD] := 'อ' -- THAI CHARACTER O ANG
			Result [0xCE] := 'ฮ' -- THAI CHARACTER HO NOKHUK
			Result [0xCF] := 'ฯ' -- THAI CHARACTER PAIYANNOI
			Result [0xD0] := 'ะ' -- THAI CHARACTER SARA A
			Result [0xD1] := 'ั' -- THAI CHARACTER MAI HAN-AKAT
			Result [0xD2] := 'า' -- THAI CHARACTER SARA AA
			Result [0xD3] := 'ำ' -- THAI CHARACTER SARA AM
			Result [0xD4] := 'ิ' -- THAI CHARACTER SARA I
			Result [0xD5] := 'ี' -- THAI CHARACTER SARA II
			Result [0xD6] := 'ึ' -- THAI CHARACTER SARA UE
			Result [0xD7] := 'ื' -- THAI CHARACTER SARA UEE
			Result [0xD8] := 'ุ' -- THAI CHARACTER SARA U
			Result [0xD9] := 'ู' -- THAI CHARACTER SARA UU
			Result [0xDA] := 'ฺ' -- THAI CHARACTER PHINTHU
			Result [0xDF] := '฿' -- THAI CURRENCY SYMBOL BAHT
			Result [0xE0] := 'เ' -- THAI CHARACTER SARA E
			Result [0xE1] := 'แ' -- THAI CHARACTER SARA AE
			Result [0xE2] := 'โ' -- THAI CHARACTER SARA O
			Result [0xE3] := 'ใ' -- THAI CHARACTER SARA AI MAIMUAN
			Result [0xE4] := 'ไ' -- THAI CHARACTER SARA AI MAIMALAI
			Result [0xE5] := 'ๅ' -- THAI CHARACTER LAKKHANGYAO
			Result [0xE6] := 'ๆ' -- THAI CHARACTER MAIYAMOK
			Result [0xE7] := '็' -- THAI CHARACTER MAITAIKHU
			Result [0xE8] := '่' -- THAI CHARACTER MAI EK
			Result [0xE9] := '้' -- THAI CHARACTER MAI THO
			Result [0xEA] := '๊' -- THAI CHARACTER MAI TRI
			Result [0xEB] := '๋' -- THAI CHARACTER MAI CHATTAWA
			Result [0xEC] := '์' -- THAI CHARACTER THANTHAKHAT
			Result [0xED] := 'ํ' -- THAI CHARACTER NIKHAHIT
			Result [0xEE] := '๎' -- THAI CHARACTER YAMAKKAN
			Result [0xEF] := '๏' -- THAI CHARACTER FONGMAN
			Result [0xF0] := '๐' -- THAI DIGIT ZERO
			Result [0xF1] := '๑' -- THAI DIGIT ONE
			Result [0xF2] := '๒' -- THAI DIGIT TWO
			Result [0xF3] := '๓' -- THAI DIGIT THREE
			Result [0xF4] := '๔' -- THAI DIGIT FOUR
			Result [0xF5] := '๕' -- THAI DIGIT FIVE
			Result [0xF6] := '๖' -- THAI DIGIT SIX
			Result [0xF7] := '๗' -- THAI DIGIT SEVEN
			Result [0xF8] := '๘' -- THAI DIGIT EIGHT
			Result [0xF9] := '๙' -- THAI DIGIT NINE
			Result [0xFA] := '๚' -- THAI CHARACTER ANGKHANKHU
			Result [0xFB] := '๛' -- THAI CHARACTER KHOMUT
		end

	latin_set_1: SPECIAL [CHARACTER]

	latin_set_2: SPECIAL [CHARACTER]

end
