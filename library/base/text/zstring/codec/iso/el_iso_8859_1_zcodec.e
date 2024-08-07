note
	description: "ISO-8859-1 zcodec"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-07 10:25:32 GMT (Wednesday 7th August 2024)"
	revision: "14"

class
	EL_ISO_8859_1_ZCODEC

inherit
	EL_ZCODEC
		rename
			single_byte_unicode_chars as new_unicode_table
		redefine
			is_compatible_string_8
		end

create
	make

feature {NONE} -- Initialization

	initialize_latin_sets
		do
		end

feature -- Conversion

	as_upper (code: NATURAL): NATURAL
		local
			offset: NATURAL
		do
			inspect code
				when 97..122, 224..246, 248..254 then
					offset := 32

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

			else end
			Result := code + offset
		end

	to_upper_offset (code: NATURAL): INTEGER
		do
			inspect code
				when 97..122, 224..246, 248..254 then
					Result := 32

			else end
			Result := Result.opposite
		end

	to_lower_offset (code: NATURAL): INTEGER
		do
			inspect code
				when 65..90, 192..214, 216..222 then
					Result := 32

			else end
		end

	latin_character (uc: CHARACTER_32): CHARACTER
			--
		do
		end

feature -- Character query

	in_latin_1_disjoint_set (c: CHARACTER): BOOLEAN
		do
			Result := False
		end

	is_alpha (code: NATURAL): BOOLEAN
		do
			Result := is_lower (code) or else is_upper (code)
		end

	is_compatible_string_8 (area: SPECIAL [CHARACTER]; i_lower, i_upper: INTEGER): BOOLEAN
		-- `True' if all Latin-1 encoded characters in `area' from `i_lower' to `i_upper'
		-- do not need to be changed to match current `encoding'
		local
			i: INTEGER; c_i: CHARACTER
		do
			from Result := True; i := i_lower until i > i_upper loop
				c_i := area [i]
				inspect c_i
					when Substitute then
						Result := False
						i := i_upper -- break
				else
				end
				i := i + 1
			end
		end

	is_upper (code: NATURAL): BOOLEAN
		do
			inspect code
				when 65..90, 192..214, 216..222 then
					Result := True
			else
			end
		end

	is_lower (code: NATURAL): BOOLEAN
		do
			inspect code
				when 97..122, 222, 224..246, 248..255 then
					Result := True

				when 181, 223 then -- µ, ß does not have an upper case
					Result := True
			else
			end
		end

	unicode_case_change_substitute (code: NATURAL): CHARACTER_32
		do
			inspect code
				-- µ -> Μ
				when 181 then
					Result := 'Μ'
				-- ÿ -> Ÿ
				when 255 then
					Result := 'Ÿ'
			else end
		end

end