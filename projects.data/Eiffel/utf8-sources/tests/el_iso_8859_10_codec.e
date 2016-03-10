note
	description: "Codec for ISO_8859_10 automatically generated from decoder.c in VTD-XML source"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-17 17:31:58 GMT (Wednesday 17th July 2013)"
	revision: "2"

class
	EL_ISO_8859_10_CODEC

inherit
	EL_ISO_8859_CODEC

create
	make

feature -- Access

	id: INTEGER = 10

feature -- Conversion

	as_upper (code: NATURAL): NATURAL
		local
			offset: NATURAL
		do
			inspect code
				when 97..122, 224..254 then
					offset := 32
				when 177..182, 185..188, 190..191 then
					offset := 16

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
				when 161..166, 169..172, 174..175 then
					offset := 16

			else end
			Result := code + offset
		end

feature -- Character query

	is_alpha (code: NATURAL): BOOLEAN
		do
			inspect code 
				when 65..90, 97..122, 161..166, 168..172, 174..175, 177..182, 185..188, 190..255 then
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
				when 97..122, 224..254, 177..182, 185..188, 190..191 then
					Result := True
			else
			end
		end

	is_lower (code: NATURAL): BOOLEAN
		do
			inspect code 
				when 65..90, 192..222, 161..166, 169..172, 174..175 then
					Result := True

				-- Characters which are only available in a single case
				when 168, 223, 255 then
					Result := True

			else
			end
		end

@f {im

	create_unicode_table: SPECIAL [CHARACTER_32]
			-- Unicode value indexed by ISO_8859_10 character values
		do
			Result := single_byte_unicode_chars
			Result [0xA0] := ' ' -- 
			Result [0xA1] := 'Ą' -- 
			Result [0xA2] := 'Ē' -- 
			Result [0xA3] := 'Ģ' -- 
			Result [0xA4] := 'Ī' -- 
			Result [0xA5] := 'Ĩ' -- 
			Result [0xA6] := 'Ķ' -- 
			Result [0xA7] := '§' -- 
			Result [0xA8] := 'Ļ' -- 
			Result [0xA9] := 'Đ' -- 
			Result [0xAA] := 'Š' -- 
			Result [0xAB] := 'Ŧ' -- 
			Result [0xAC] := 'Ž' -- 
			Result [0xAD] := '­' -- 
			Result [0xAE] := 'Ū' -- 
			Result [0xAF] := 'Ŋ' -- 
			Result [0xB0] := '°' -- 
			Result [0xB1] := 'ą' -- 
			Result [0xB2] := 'ē' -- 
			Result [0xB3] := 'ģ' -- 
			Result [0xB4] := 'ī' -- 
			Result [0xB5] := 'ĩ' -- 
			Result [0xB6] := 'ķ' -- 
			Result [0xB7] := '·' -- 
			Result [0xB9] := 'đ' -- 
			Result [0xBA] := 'š' -- 
			Result [0xBB] := 'ŧ' -- 
			Result [0xBC] := 'ž' -- 
			Result [0xBD] := '―' -- 
			Result [0xBE] := 'ū' -- 
			Result [0xBF] := 'ŋ' -- 
			Result [0xC0] := 'Ā' -- 
			Result [0xC1] := 'Á' -- 
			Result [0xC2] := 'Â' -- 
			Result [0xC3] := 'Ã' -- 
			Result [0xC4] := 'Ä' -- 
			Result [0xC5] := 'Å' -- 
			Result [0xC6] := 'Æ' -- 
			Result [0xC7] := 'Į' -- 
			Result [0xC8] := 'Č' -- 
			Result [0xC9] := 'É' -- 
			Result [0xCA] := 'Ę' -- 
			Result [0xCB] := 'Ë' -- 
			Result [0xCC] := 'Ė' -- 
			Result [0xCD] := 'Í' -- 
			Result [0xCE] := 'Î' -- 
			Result [0xCF] := 'Ï' -- 
			Result [0xD0] := 'Ð' -- 
			Result [0xD1] := 'Ņ' -- 
			Result [0xD2] := 'Ō' -- 
			Result [0xD3] := 'Ó' -- 
			Result [0xD4] := 'Ô' -- 
			Result [0xD5] := 'Õ' -- 
			Result [0xD6] := 'Ö' -- 
			Result [0xD7] := 'Ũ' -- 
			Result [0xD8] := 'Ø' -- 
			Result [0xD9] := 'Ų' -- 
			Result [0xDA] := 'Ú' -- 
			Result [0xDB] := 'Û' -- 
			Result [0xDC] := 'Ü' -- 
			Result [0xDD] := 'Ý' -- 
			Result [0xDE] := 'Þ' -- 
			Result [0xDF] := 'ß' -- 
			Result [0xE0] := 'ā' -- 
			Result [0xE1] := 'á' -- 
			Result [0xE2] := 'â' -- 
			Result [0xE3] := 'ã' -- 
			Result [0xE4] := 'ä' -- 
			Result [0xE5] := 'å' -- 
			Result [0xE6] := 'æ' -- 
			Result [0xE7] := 'į' -- 
			Result [0xE8] := 'č' -- 
			Result [0xE9] := 'é' -- 
			Result [0xEA] := 'ę' -- 
			Result [0xEB] := 'ë' -- 
			Result [0xEC] := 'ė' -- 
			Result [0xED] := 'í' -- 
			Result [0xEE] := 'î' -- 
			Result [0xEF] := 'ï' -- 
			Result [0xF0] := 'ð' -- 
			Result [0xF1] := 'ņ' -- 
			Result [0xF2] := 'ō' -- 
			Result [0xF3] := 'ó' -- 
			Result [0xF4] := 'ô' -- 
			Result [0xF5] := 'õ' -- 
			Result [0xF6] := 'ö' -- 
			Result [0xF7] := 'ũ' -- 
			Result [0xF8] := 'ø' -- 
			Result [0xF9] := 'ų' -- 
			Result [0xFA] := 'ú' -- 
			Result [0xFB] := 'û' -- 
			Result [0xFC] := 'ü' -- 
			Result [0xFD] := 'ý' -- 
			Result [0xFE] := 'þ' -- 
			Result [0xFF] := 'ĸ' -- 
		end

end
