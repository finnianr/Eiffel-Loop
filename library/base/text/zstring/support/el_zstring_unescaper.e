note
	description: "[
		Z-code escape table for use with class [$source EL_ZSTRING]. See routine `escape'.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-03 14:55:03 GMT (Sunday 3rd January 2021)"
	revision: "9"

class
	EL_ZSTRING_UNESCAPER

inherit
	EL_STRING_GENERAL_UNESCAPER [EL_READABLE_ZSTRING]
		redefine
			character_to_code, i_th_code
		end

	EL_SHARED_ZSTRING_CODEC

create
	make

feature -- Access

	unescaped (str: EL_READABLE_ZSTRING): EL_ZSTRING
		do
			create Result.make_from_zcode_area (unescaped_array (str))
		end

	unescaped_array (str: EL_READABLE_ZSTRING): SPECIAL [NATURAL]
		local
			l_count, i, seq_count: INTEGER; z_code_i, esc_code: NATURAL
			l_area: SPECIAL [CHARACTER_8]
		do
			l_count := str.count; l_area := str.area
			esc_code := escape_code

			create Result.make_empty (l_count)
			from i := 0 until i = l_count loop
				z_code_i := str.area_i_th_z_code (l_area, i)
				if z_code_i = esc_code then
					seq_count := sequence_count (str, i + 2)
					if seq_count.to_boolean then
						z_code_i := unescaped_code (i + 2, seq_count)
					end
				else
					seq_count := 0
				end
				Result.extend (z_code_i)
				i := i + seq_count + 1
			end
		end

feature {NONE} -- Implementation

	character_to_code (character: CHARACTER_32): NATURAL
		do
			Result := Codec.as_z_code (character)
		end

	i_th_code (str: EL_READABLE_ZSTRING; index: INTEGER): NATURAL
		do
			Result := str.z_code (index)
		end

end