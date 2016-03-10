note
	description: "Codec for ISO_8859_15 automatically generated from decoder.c in VTD-XML source"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "4"

class
	EL_ISO_8859_15_CODEC

inherit
	EL_ISO_8859_CODEC

create
	make

feature {NONE} -- Initialization

	initialize_latin_sets
		do
			latin_set_1 := latin_set_from_array (<<
				180, -- 'Ž'
				184  -- 'ž'
			>>)
			latin_set_2 := latin_set_from_array (<<
				166, -- 'Š'
				168  -- 'š'
			>>)
			latin_set_3 := latin_set_from_array (<<
				188, -- 'Œ'
				189  -- 'œ'
			>>)
		end

feature -- Access

	id: INTEGER = 15

feature -- Conversion

	as_upper (code: NATURAL): NATURAL
		local
			offset: NATURAL
		do
			inspect code
				when 97..122, 224..246, 248..254 then
					offset := 32
				when 168 then
					offset := 2
				when 184 then
					offset := 4
				when 189 then
					offset := 1
				when 255 then
					offset := 65

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
				when 166 then
					offset := 2
				when 180 then
					offset := 4
				when 188 then
					offset := 1
				when 190 then
					offset := 65

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
			-- Returns '%U' if translation is the same as ISO-8859-1 or else not in ISO_8859_15
		do
			inspect uc
				when 'Ž'..'ž' then
					Result := latin_set_1 [unicode - 381]
				when 'Š'..'š' then
					Result := latin_set_2 [unicode - 352]
				when 'Œ'..'œ' then
					Result := latin_set_3 [unicode - 338]
				when 'Ÿ' then
					Result := '%/190/'
				when '€' then
					Result := '%/164/'
			else end
		end

feature -- Character query

	is_alpha (code: NATURAL): BOOLEAN
		do
			inspect code 
				when 65..90, 97..122, 166, 168, 180..181, 184, 188..190, 192..214, 216..246, 248..255 then
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
				when 97..122, 224..246, 248..254, 168, 184, 189, 255 then
					Result := True
			else
			end
		end

	is_lower (code: NATURAL): BOOLEAN
		do
			inspect code 
				when 65..90, 192..214, 216..222, 166, 180, 188, 190 then
					Result := True

				-- Characters which are only available in a single case
				when 181, 223 then
					Result := True

			else
			end
		end

feature {NONE} -- Implementation

	create_unicode_table: SPECIAL [CHARACTER_32]
			-- Unicode value indexed by ISO_8859_15 character values
		do
			Result := single_byte_unicode_chars
			Result [0xA4] := '€' -- 
			Result [0xA6] := 'Š' -- 
			Result [0xA8] := 'š' -- 
			Result [0xB4] := 'Ž' -- 
			Result [0xB8] := 'ž' -- 
			Result [0xBC] := 'Œ' -- 
			Result [0xBD] := 'œ' -- 
			Result [0xBE] := 'Ÿ' -- 
		end

	latin_set_1: SPECIAL [CHARACTER]

	latin_set_2: SPECIAL [CHARACTER]

	latin_set_3: SPECIAL [CHARACTER]

end
