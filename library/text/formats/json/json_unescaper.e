note
	description: "JSON unescaper"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-01-05 16:10:35 GMT (Thursday 5th January 2023)"
	revision: "12"

class
	JSON_UNESCAPER

inherit
	EL_ZSTRING_UNESCAPER
		rename
			make as make_unescaper
		redefine
			numeric_sequence_count, unescaped_code
		end

	EL_SHARED_ESCAPE_TABLE

create
	make

feature {NONE} -- Initialization

	make
		do
			make_unescaper (Escape_table.JSON.inverted)
			u_z_code := Codec.as_z_code ('u')
		end

feature -- Access

	unescaped_code (index, a_sequence_count: INTEGER): NATURAL
		do
			if a_sequence_count = 1 and then found then
				Result := found_item

			elseif a_sequence_count >= 5 then
				Result := Codec.as_z_code (Utf_16_sequence.character_32)
			end
		end

feature {NONE} -- Implementation

	numeric_sequence_count (str: EL_READABLE_ZSTRING; index: INTEGER): INTEGER
		local
			utf_16: like Utf_16_sequence; code: INTEGER_64
		do
			code := u_code (str, index)
			if code >= 0 then
				Result := 5
				utf_16 := Utf_16_sequence; utf_16.wipe_out
				utf_16.extend (code.to_natural_32)
				if utf_16.is_surrogate_pair and then index + 10 <= str.count
					and then str.z_code (index + 5) = escape_code
				then
					code := u_code (str, index + 6)
					if code >= 0 then
						utf_16.extend (code.to_natural_32)
						Result := 11
					end
				end
			end
		end

	u_code (str: EL_READABLE_ZSTRING; index: INTEGER): INTEGER_64
		local
			hex: EL_HEXADECIMAL_CONVERTER
		do
			if str.z_code (index) = U_z_code and then index + 4 <= str.count
				and then hex.is_valid_sequence (str, index + 1, index + 4)
			then
				Result := hex.substring_to_natural_32 (str, index + 1, index + 4)
			else
				Result := Result.one.opposite
			end
		end

feature {NONE} -- Constants

	Utf_16_sequence: EL_UTF_16_SEQUENCE
		once
			create Result.make
		end

	u_z_code: NATURAL

end