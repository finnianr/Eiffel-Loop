﻿note
	description: "ISO-8859-1 zcodec"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-02-10 15:48:03 GMT (Friday 10th February 2023)"
	revision: "12"

class
	EL_ISO_8859_1_ZCODEC

inherit
	EL_ZCODEC
		rename
			single_byte_unicode_chars as new_unicode_table
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

	is_alpha (code: NATURAL): BOOLEAN
		do
			Result := is_lower (code) or else is_upper (code)
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